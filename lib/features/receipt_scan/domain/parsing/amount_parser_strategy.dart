import 'package:ant_budget/core/config/app_config.dart';
import 'package:ant_budget/core/error/failure.dart';
import 'package:ant_budget/core/error/result.dart';
import 'package:ant_budget/core/utils/numeric_parsing.dart';
import 'package:ant_budget/core/values/currency.dart';
import 'package:ant_budget/core/values/money.dart';
import 'package:ant_budget/features/receipt_scan/domain/parsing/ocr_parse_input.dart';
import 'package:ant_budget/features/receipt_scan/domain/parsing/ocr_parsing_strategy.dart';

/// Extracts the payable total of a receipt.
///
/// Instead of one giant regex, every number on the receipt becomes a candidate
/// and the winner is chosen by a small scoring function that rewards "total"
/// keywords and the bottom of the receipt, and penalises lines that are known
/// to hold something else (tax, change, dates, percentages). That keeps the
/// complexity linear and each rule independently testable.
final class AmountParserStrategy implements OcrParsingStrategy<Money> {
  const AmountParserStrategy({
    this.defaultCurrency = AppConfig.reportingCurrency,
  });

  /// Used when the receipt does not mention a currency at all.
  final Currency defaultCurrency;

  /// Labels marking the line that holds the amount actually paid.
  static const Set<String> totalKeywords = {
    'total',
    'grand total',
    'total amount',
    'total due',
    'amount due',
    'balance due',
    'net total',
    'to pay',
    'toplam',
    'genel toplam',
    'toplam tutar',
    'net toplam',
    'ödenecek',
    'ödenecek tutar',
    'tutar',
  };

  /// Labels marking amounts that are *not* the payable total.
  static const Set<String> excludedKeywords = {
    'subtotal',
    'sub total',
    'ara toplam',
    'tax',
    'vat',
    'kdv',
    'change',
    'para üstü',
    'cash',
    'nakit',
    'discount',
    'indirim',
    'tip',
    'bahşiş',
    'service',
    'servis',
    'loyalty',
    'points',
    'puan',
  };

  static const int _totalKeywordScore = 1000;
  static const int _excludedKeywordPenalty = -600;
  static const int _decimalBonus = 10;
  static const int _datePenalty = -400;
  static const int _timePenalty = -300;

  static final RegExp _numberPattern = RegExp(r'\d[\d.,]*\d|\d');
  static final RegExp _dateLikePattern = RegExp(
    r'\d{1,4}[./-]\d{1,2}[./-]\d{2,4}',
  );
  static final RegExp _timeLikePattern = RegExp(r'\d{1,2}:\d{2}');

  @override
  Result<Money, ParseFailure> parse(OcrParseInput input) {
    final candidates = _collectCandidates(input);
    if (candidates.isEmpty) {
      return const Result.err(
        ParseFailure.amountNotFound(strategy: 'AmountParserStrategy'),
      );
    }

    candidates.sort(_byBestCandidate);
    final best = candidates.first;
    final bestLine = input.lines[best.lineIndex];
    final currency =
        Currency.detectIn(bestLine) ??
        Currency.detectIn(input.lowercaseText) ??
        defaultCurrency;

    return Result.ok(Money(best.minorUnits, currency));
  }

  List<({int minorUnits, int lineIndex, int score})> _collectCandidates(
    OcrParseInput input,
  ) {
    final candidates = <({int minorUnits, int lineIndex, int score})>[];
    for (var index = 0; index < input.lines.length; index++) {
      final line = input.lines[index];
      final lowercaseLine = line.toLowerCase();
      final isTotalLine = OcrKeywordMatcher.containsAny(
        lowercaseLine,
        totalKeywords,
      );
      final isExcludedLine = OcrKeywordMatcher.containsAny(
        lowercaseLine,
        excludedKeywords,
      );

      for (final match in _numberPattern.allMatches(line)) {
        final token = match.group(0);
        if (token == null) continue;
        if (_isPercentValue(line, match.start)) continue;
        final minorUnits = parseAmountToMinorUnits(token);
        if (minorUnits == null) continue;
        candidates.add((
          minorUnits: minorUnits,
          lineIndex: index,
          score: _scoreFor(
            token: token,
            lineIndex: index,
            lowercaseLine: lowercaseLine,
            isTotalLine: isTotalLine,
            isExcludedLine: isExcludedLine,
          ),
        ));
      }
    }
    return candidates;
  }

  int _scoreFor({
    required String token,
    required int lineIndex,
    required String lowercaseLine,
    required bool isTotalLine,
    required bool isExcludedLine,
  }) {
    var score = lineIndex;
    if (isTotalLine) score += _totalKeywordScore;
    if (isExcludedLine) score += _excludedKeywordPenalty;
    if (token.contains('.') || token.contains(',')) score += _decimalBonus;
    if (_dateLikePattern.hasMatch(lowercaseLine)) score += _datePenalty;
    if (_timeLikePattern.hasMatch(lowercaseLine)) score += _timePenalty;
    return score;
  }

  int _byBestCandidate(
    ({int minorUnits, int lineIndex, int score}) a,
    ({int minorUnits, int lineIndex, int score}) b,
  ) {
    if (a.score != b.score) return b.score.compareTo(a.score);
    if (a.minorUnits != b.minorUnits) {
      return b.minorUnits.compareTo(a.minorUnits);
    }
    return b.lineIndex.compareTo(a.lineIndex);
  }

  /// Whether the number starting at [start] belongs to a percentage (`KDV %20`).
  bool _isPercentValue(String line, int start) =>
      start > 0 && line[start - 1] == '%';
}
