import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Raw text produced by an OCR engine, normalised for the parsers.
///
/// This is a domain value object: it carries the recognised text and the
/// non-empty lines derived from it, but nothing that is specific to ML Kit.
@immutable
final class OcrRawText extends Equatable {
  const OcrRawText({required this.fullText, required this.lines});

  /// Builds a value object from a single recognised text block.
  ///
  /// Blank lines are dropped (`lines`) because receipt layouts are full of
  /// them, while `fullText` keeps the original content for debugging.
  factory OcrRawText.fromText(String text) => OcrRawText(
    fullText: text,
    lines: text
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList(growable: false),
  );

  /// The complete recognised text.
  final String fullText;

  /// The recognised text, split into non-empty, trimmed lines.
  final List<String> lines;

  /// Whether anything was recognised at all.
  bool get isEmpty => lines.isEmpty;

  @override
  List<Object?> get props => [fullText];
}
