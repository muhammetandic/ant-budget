import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:ant_budget/features/receipt_scan/domain/values/ocr_raw_text.dart';

/// The normalised input every parsing strategy works on.
///
/// Building the lowercase text and the line list once, instead of inside each
/// strategy, keeps the strategies small *and* makes the pipeline cheap: N
/// strategies parse the same prepared input.
@immutable
final class OcrParseInput extends Equatable {
  const OcrParseInput({required this.rawText, required this.lowercaseText});

  /// Prepares [rawText] for parsing.
  factory OcrParseInput.from(OcrRawText rawText) => OcrParseInput(
    rawText: rawText,
    lowercaseText: rawText.fullText.toLowerCase(),
  );

  final OcrRawText rawText;

  /// `rawText.fullText`, lowercased once for keyword matching.
  final String lowercaseText;

  /// The recognised lines, in reading order.
  List<String> get lines => rawText.lines;

  /// Whether the input contains any of [keywords] as a word or phrase.
  bool containsAnyKeyword(Set<String> keywords) =>
      OcrKeywordMatcher.containsAny(lowercaseText, keywords);

  /// Whether [line] contains any of [keywords] as a word or phrase.
  bool lineContainsAny(String line, Set<String> keywords) =>
      OcrKeywordMatcher.containsAny(line.toLowerCase(), keywords);

  @override
  List<Object?> get props => [rawText];
}

/// Word-aware keyword matching for OCR text.
///
/// Plain `String.contains` would match `total` inside `subtotal` and `tax`
/// inside `taxation`, which produces wrong amounts on real receipts; this helper
/// matches single words on word boundaries and multi-word phrases literally.
abstract final class OcrKeywordMatcher {
  /// Whether [text] contains any keyword of [keywords].
  static bool containsAny(String text, Set<String> keywords) {
    for (final keyword in keywords) {
      if (contains(text, keyword)) return true;
    }
    return false;
  }

  /// Whether [text] contains [keyword].
  static bool contains(String text, String keyword) {
    if (keyword.contains(' ')) return text.contains(keyword);
    final boundary = RegExp(
      '(^|[^a-z0-9ğüşıöç])${RegExp.escape(keyword)}([^a-z0-9ğüşıöç]|\$)',
    );
    return boundary.hasMatch(text);
  }
}
