import 'package:ant_budget/core/config/app_config.dart';
import 'package:ant_budget/core/error/failure.dart';
import 'package:ant_budget/core/error/result.dart';
import 'package:ant_budget/core/values/currency.dart';
import 'package:ant_budget/core/values/money.dart';
import 'package:ant_budget/features/receipt_scan/domain/parsing/amount_candidate.dart';
import 'package:ant_budget/features/receipt_scan/domain/parsing/ocr_parse_input.dart';
import 'package:ant_budget/features/receipt_scan/domain/parsing/ocr_parsing_strategy.dart';

/// Extracts the payable total of a receipt.
///
/// Every number on the receipt becomes a candidate (see
/// [AmountCandidateCollector]) and a small selection rule picks the winner,
/// which keeps the complexity linear and each rule independently testable.
/// Selection happens in two stages:
///
/// 1. if a line is labelled as a total (`TOPLAM`, `GENEL TOPLAM`, `TOTAL`, ...)
///    only those candidates compete, and the highest scoring one wins;
/// 2. otherwise (many small receipts print no total at all) the **largest**
///    amount that is not labelled as tax, discount or change wins, because on a
///    receipt the payable figure is almost always the biggest such number.
final class AmountParserStrategy implements OcrParsingStrategy<Money> {
  const AmountParserStrategy({
    this.defaultCurrency = AppConfig.reportingCurrency,
  });

  /// Used when the receipt does not mention a currency at all.
  final Currency defaultCurrency;

  @override
  Result<Money, ParseFailure> parse(OcrParseInput input) {
    final candidates = const AmountCandidateCollector().collect(input);
    if (candidates.isEmpty) {
      return const Result.err(
        ParseFailure.amountNotFound(strategy: 'AmountParserStrategy'),
      );
    }

    final best = _pickBest(candidates);
    final bestLine = input.lines[best.lineIndex];
    final currency =
        Currency.detectIn(bestLine) ??
        Currency.detectIn(input.lowercaseText) ??
        defaultCurrency;

    return Result.ok(Money(best.minorUnits, currency));
  }

  AmountCandidate _pickBest(List<AmountCandidate> candidates) {
    final totals = candidates
        .where((candidate) => candidate.onTotalLine)
        .toList(growable: false);
    if (totals.isNotEmpty) {
      totals.sort(_byScore);
      return totals.first;
    }

    // No total label at all: the payable amount is the largest figure that is
    // not labelled as tax, discount, change, ... (tendered cash/card amounts
    // stay in the race on purpose: they are the best proxy for what was paid).
    final clean = candidates
        .where((candidate) => !candidate.onExcludedLine)
        .toList(growable: false);
    final pool = clean.isNotEmpty ? clean : candidates;
    pool.sort(_byLargest);
    return pool.first;
  }

  int _byScore(AmountCandidate a, AmountCandidate b) {
    if (a.score != b.score) return b.score.compareTo(a.score);
    if (a.minorUnits != b.minorUnits) {
      return b.minorUnits.compareTo(a.minorUnits);
    }
    return b.lineIndex.compareTo(a.lineIndex);
  }

  int _byLargest(AmountCandidate a, AmountCandidate b) {
    if (a.minorUnits != b.minorUnits) {
      return b.minorUnits.compareTo(a.minorUnits);
    }
    if (a.score != b.score) return b.score.compareTo(a.score);
    return b.lineIndex.compareTo(a.lineIndex);
  }
}
