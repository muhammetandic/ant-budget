import 'package:ant_budget/core/error/failure.dart';
import 'package:ant_budget/core/error/result.dart';
import 'package:ant_budget/core/values/money.dart';
import 'package:ant_budget/features/receipt_scan/domain/entities/scanned_receipt.dart';
import 'package:ant_budget/features/receipt_scan/domain/parsing/ocr_parse_input.dart';
import 'package:ant_budget/features/receipt_scan/domain/parsing/ocr_parsing_strategy.dart';
import 'package:ant_budget/features/receipt_scan/domain/values/ocr_raw_text.dart';

/// Runs the extraction strategies and assembles a [ScannedReceipt].
///
/// The pipeline itself contains no knowledge about *how* an amount or a merchant
/// is found — that lives in the strategies. Adding a new extraction (tax number,
/// invoice id, ...) means writing one more `OcrParsingStrategy` and wiring it in,
/// without touching the existing ones (Open/Closed Principle).
///
/// Composition uses the `Result` monad (`flatMap`) instead of nested `if`s, so
/// the whole orchestration fits in a handful of lines.
final class ReceiptParserPipeline {
  const ReceiptParserPipeline({
    required OcrParsingStrategy<Money> amountParser,
    required OcrParsingStrategy<DateTime?> dateParser,
    required OcrParsingStrategy<String?> merchantParser,
    DateTime Function()? clock,
  }) : _amountParser = amountParser,
       _dateParser = dateParser,
       _merchantParser = merchantParser,
       _clock = clock;

  final OcrParsingStrategy<Money> _amountParser;
  final OcrParsingStrategy<DateTime?> _dateParser;
  final OcrParsingStrategy<String?> _merchantParser;
  final DateTime Function()? _clock;

  /// Parses [rawText] into a reviewable receipt.
  ///
  /// Only the total is mandatory: the date falls back to "now" and the merchant
  /// to `null` when the strategies cannot find them.
  Result<ScannedReceipt, ParseFailure> parse(OcrRawText rawText) {
    if (rawText.isEmpty) {
      return const Result.err(ParseFailure.emptyInput());
    }

    final input = OcrParseInput.from(rawText);
    return _amountParser
        .parse(input)
        .flatMap(
          (total) => Result.ok(
            ScannedReceipt(
              total: total,
              purchasedAt: _dateParser.parse(input).valueOrNull ?? _now(),
              merchantName: _merchantParser.parse(input).getOrElse(() => null),
              rawText: rawText,
            ),
          ),
        );
  }

  DateTime _now() => _clock?.call() ?? DateTime.now();
}
