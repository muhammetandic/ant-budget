import 'package:ant_budget/core/utils/numeric_parsing.dart';
import 'package:ant_budget/features/receipt_scan/domain/parsing/amount_keywords.dart';
import 'package:ant_budget/features/receipt_scan/domain/parsing/amount_noise_filter.dart';
import 'package:ant_budget/features/receipt_scan/domain/parsing/ocr_parse_input.dart';

/// One number found on the receipt, with the context that scores it.
///
/// [hasDecimals] records whether the printed figure carried kuruş (`293,90`),
/// which is what separates a real price from a bare store number or an item
/// count (`8718`, `103`).
typedef AmountCandidate = ({
  int minorUnits,
  int lineIndex,
  int score,
  bool onTotalLine,
  bool onExcludedLine,
  bool hasDecimals,
});

/// Turns the raw OCR lines into [AmountCandidate]s.
///
/// The "evidence gathering" half of the parser: it walks the lines, decides
/// which of them can carry the total, and drops numbers that cannot be money
/// (that judgement lives in [AmountNoiseFilter]).
final class AmountCandidateCollector {
  const AmountCandidateCollector();

  static const int _totalKeywordScore = 1000;
  static const int _excludedPenalty = -1200;
  static const int _decimalBonus = 10;

  static const _noise = AmountNoiseFilter();

  List<AmountCandidate> collect(OcrParseInput input) {
    final totalLines = _totalAmountLines(input.lines);
    final candidates = <AmountCandidate>[];
    for (var index = 0; index < input.lines.length; index++) {
      final line = input.lines[index];
      final lowercase = line.toLowerCase();
      final isTotalLine = totalLines.contains(index);
      final isExcludedLine = OcrKeywordMatcher.containsAny(
        lowercase,
        AmountKeywords.excluded,
      );
      // A date, a clock or a `quantity x unit price` line holds no total.
      if (!isTotalLine && _noise.isNoisyLine(line)) continue;

      for (final match in AmountNoiseFilter.numberPattern.allMatches(line)) {
        final token = match.group(0);
        if (token == null) continue;
        if (_noise.isNoiseToken(line, match.start, token)) continue;
        final minorUnits = parseAmountToMinorUnits(token);
        if (minorUnits == null) continue;
        final hasDecimals = token.contains('.') || token.contains(',');
        candidates.add((
          minorUnits: minorUnits,
          lineIndex: index,
          onTotalLine: isTotalLine,
          onExcludedLine: isExcludedLine,
          hasDecimals: hasDecimals,
          score: _scoreFor(
            lineIndex: index,
            isTotalLine: isTotalLine,
            isExcludedLine: isExcludedLine,
            hasDecimals: hasDecimals,
          ),
        ));
      }
    }
    return candidates;
  }

  /// Line indexes whose number *is* the total.
  ///
  /// Handles both shapes a receipt uses: the amount on the same line as the
  /// label (`TOPLAM 56,05`) and the label on its own line, which happens on
  /// narrow thermal paper. The label-only shape is trusted only when the line
  /// underneath carries a decimal amount: `Toplam` followed by an item count
  /// (`: 103`) is a table cell, not the payable total.
  Set<int> _totalAmountLines(List<String> lines) {
    final result = <int>{};
    for (var index = 0; index < lines.length; index++) {
      final lowercase = lines[index].toLowerCase();
      if (!OcrKeywordMatcher.containsAny(lowercase, AmountKeywords.total)) {
        continue;
      }
      if (OcrKeywordMatcher.containsAny(lowercase, AmountKeywords.excluded)) {
        continue;
      }
      if (AmountNoiseFilter.numberPattern.hasMatch(lines[index])) {
        result.add(index);
      } else if (index + 1 < lines.length &&
          _noise.hasDecimalAmount(lines[index + 1])) {
        result.add(index + 1);
      }
    }
    return result;
  }

  int _scoreFor({
    required int lineIndex,
    required bool isTotalLine,
    required bool isExcludedLine,
    required bool hasDecimals,
  }) {
    var score = lineIndex;
    if (isTotalLine) score += _totalKeywordScore;
    if (isExcludedLine) score += _excludedPenalty;
    if (hasDecimals) score += _decimalBonus;
    return score;
  }
}
