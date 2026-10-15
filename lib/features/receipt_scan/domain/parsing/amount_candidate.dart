import 'package:ant_budget/core/utils/numeric_parsing.dart';
import 'package:ant_budget/features/receipt_scan/domain/parsing/amount_keywords.dart';
import 'package:ant_budget/features/receipt_scan/domain/parsing/ocr_parse_input.dart';

/// One number found on the receipt, with the context that scores it.
typedef AmountCandidate = ({
  int minorUnits,
  int lineIndex,
  int score,
  bool onTotalLine,
  bool onExcludedLine,
});

/// Turns the raw OCR lines into [AmountCandidate]s.
///
/// The "evidence gathering" half of the parser: it walks the lines, decides
/// which of them can carry the total, and rejects numbers that cannot be money.
final class AmountCandidateCollector {
  const AmountCandidateCollector();

  static const int _totalKeywordScore = 1000;
  static const int _excludedPenalty = -1200;
  static const int _decimalBonus = 10;

  static final RegExp _numberPattern = RegExp(r'\d[\d.,]*\d|\d');
  static final RegExp _dateLikePattern = RegExp(
    r'\d{1,4}[./-]\d{1,2}[./-]\d{2,4}',
  );
  static final RegExp _timeLikePattern = RegExp(r'\d{1,2}:\d{2}');
  static final RegExp _digitRun = RegExp(r'\d+');

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
      // A date or a clock is never a price. Skip the whole line (unless it is
      // the total line, which may legitimately carry a date next to the amount).
      if (!isTotalLine &&
          (_dateLikePattern.hasMatch(lowercase) ||
              _timeLikePattern.hasMatch(lowercase))) {
        continue;
      }

      for (final match in _numberPattern.allMatches(line)) {
        final token = match.group(0);
        if (token == null) continue;
        if (_isPercent(line, match.start, token)) continue;
        if (_isTime(line, match.start, token)) continue;
        if (_looksLikeIdentifier(token)) continue;
        final minorUnits = parseAmountToMinorUnits(token);
        if (minorUnits == null) continue;
        candidates.add((
          minorUnits: minorUnits,
          lineIndex: index,
          onTotalLine: isTotalLine,
          onExcludedLine: isExcludedLine,
          score: _scoreFor(
            token: token,
            lineIndex: index,
            isTotalLine: isTotalLine,
            isExcludedLine: isExcludedLine,
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
  /// narrow thermal paper where the amount is printed underneath.
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
      if (_numberPattern.hasMatch(lines[index])) {
        result.add(index);
      } else if (index + 1 < lines.length) {
        result.add(index + 1);
      }
    }
    return result;
  }

  int _scoreFor({
    required String token,
    required int lineIndex,
    required bool isTotalLine,
    required bool isExcludedLine,
  }) {
    var score = lineIndex;
    if (isTotalLine) score += _totalKeywordScore;
    if (isExcludedLine) score += _excludedPenalty;
    if (token.contains('.') || token.contains(',')) score += _decimalBonus;
    return score;
  }

  /// Whether the number starting at [start] is a percentage (`%20`, `KDV % 20`,
  /// `20 %`). Amounts are printed next to the rate often enough that missing
  /// this would read `20` as a price.
  bool _isPercent(String line, int start, String token) {
    final end = start + token.length;
    if (start > 0 && line[start - 1] == '%') return true;
    if (end < line.length && line[end] == '%') return true;
    if (start > 1 && line[start - 2] == '%' && line[start - 1].trim().isEmpty) {
      return true;
    }
    if (end + 1 < line.length &&
        line[end + 1] == '%' &&
        line[end].trim().isEmpty) {
      return true;
    }
    return false;
  }

  /// Whether the number starting at [start] belongs to a clock (`15:30`).
  bool _isTime(String line, int start, String token) {
    final end = start + token.length;
    if (start > 0 && line[start - 1] == ':') return true;
    if (end < line.length && line[end] == ':') return true;
    return false;
  }

  /// `123456`, `7712345` — receipt, terminal or card identifiers, not money.
  ///
  /// A real price always carries decimals on a printed receipt, so a long bare
  /// integer is an id; skipping it stops `FIŞ NO 7712345` from out-sizing every
  /// price when no total label exists.
  bool _looksLikeIdentifier(String token) {
    if (token.contains('.') || token.contains(',')) return false;
    final digits = _digitRun.stringMatch(token) ?? '';
    return digits.length >= 5;
  }
}
