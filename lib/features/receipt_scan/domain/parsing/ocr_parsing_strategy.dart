import 'package:ant_budget/core/error/failure.dart';
import 'package:ant_budget/core/error/result.dart';
import 'package:ant_budget/features/receipt_scan/domain/parsing/ocr_parse_input.dart';

/// Contract of one extraction step of the receipt pipeline.
///
/// The type parameter is what the strategy extracts, which is what makes the
/// pipeline type safe: `ReceiptParserPipeline` injects an
/// `OcrParsingStrategy<Money>`, an `OcrParsingStrategy<DateTime?>` and an
/// `OcrParsingStrategy<String?>` instead of juggling `dynamic` results.
///
/// A strategy never throws: it returns the extracted value, or a [ParseFailure]
/// when it cannot decide. Strategies that extract optional data express "not
/// found" as a successful `null`.
abstract interface class OcrParsingStrategy<T> {
  /// Extracts [T] from [input].
  Result<T, ParseFailure> parse(OcrParseInput input);
}
