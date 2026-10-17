import 'package:ant_budget/core/error/failure.dart';
import 'package:ant_budget/core/error/result.dart';
import 'package:ant_budget/features/receipt_scan/domain/parsing/merchant_keywords.dart';
import 'package:ant_budget/features/receipt_scan/domain/parsing/ocr_parse_input.dart';
import 'package:ant_budget/features/receipt_scan/domain/parsing/ocr_parsing_strategy.dart';

/// Extracts the merchant name from the header of a receipt.
///
/// Optional by design: when nothing convincing is found the strategy succeeds
/// with `null` and the UI falls back to a generic title.
///
/// The merchant is rarely the first readable line. Real receipts open with
/// column labels (`TARIH`, `SAAT`, `TOPKDV`) or a legal title, and the shop name
/// can sit below a run of product rows. So each header line is *scored* — a
/// corporate word, capitals and length help; an address or a late position
/// hurts — and the best candidate wins instead of the first that merely looks
/// like a name.
final class MerchantParserStrategy implements OcrParsingStrategy<String?> {
  const MerchantParserStrategy();

  /// Merchants are printed near the top, but often after header labels and a
  /// few product rows, so the window spans more than the visible title block.
  static const int headerLineCount = 15;

  /// Longer lines are almost always addresses or legal footers.
  static const int maxNameLength = 48;

  static const int _companyMarkerScore = 100;
  static const int _uppercaseScore = 20;
  static const int _addressPenalty = -40;

  static const Map<String, String> _foldings = {
    'ı': 'i',
    'ş': 's',
    'ğ': 'g',
    'ü': 'u',
    'ö': 'o',
    'ç': 'c',
    'â': 'a',
    'î': 'i',
    'û': 'u',
    'é': 'e',
    'è': 'e',
    'í': 'i',
    'á': 'a',
    'ó': 'o',
    'ú': 'u',
    'ñ': 'n',
    'ï': 'i',
    'ì': 'i',
    'ê': 'e',
    'ô': 'o',
  };

  static final RegExp _lettersOnlyPattern = RegExp(r'[^A-Za-zĞÜŞİÖÇğüşıöç]');
  static final RegExp _uppercasePattern = RegExp(r'[^A-ZĞÜŞİÖÇ]');
  static final RegExp _digitsOnlyPattern = RegExp(r'[^0-9]');
  static final RegExp _currencyPattern = RegExp(r'[₺$€£]');
  static final RegExp _dateLikePattern = RegExp(
    r'\d{1,4}[./-]\d{1,2}[./-]\d{2,4}',
  );

  @override
  Result<String?, ParseFailure> parse(OcrParseInput input) {
    final limit = input.lines.length < headerLineCount
        ? input.lines.length
        : headerLineCount;
    String? best;
    var bestScore = 0;
    for (var index = 0; index < limit; index++) {
      final candidate = _selectCandidate(input.lines[index]);
      if (candidate == null) continue;
      final score = _score(candidate, index);
      if (score > bestScore) {
        bestScore = score;
        best = candidate;
      }
    }
    return Result.ok(best);
  }

  /// Ranks a plausible name: a corporate word dominates, capitals and length
  /// help, being an address or appearing late hurts.
  int _score(String line, int index) {
    final normalized = _normalize(line);
    var score = line.length - index;
    if (_containsWord(normalized, MerchantKeywords.company)) {
      score += _companyMarkerScore;
    }
    if (_containsWord(normalized, MerchantKeywords.address)) {
      score += _addressPenalty;
    }
    if (_isUppercase(line)) score += _uppercaseScore;
    return score;
  }

  /// Word-boundary search over the folded ASCII text (`TÍC` has become `tic`).
  bool _containsWord(String normalized, Set<String> words) {
    for (final word in words) {
      final boundary = RegExp(
        '(^|[^a-z0-9])${RegExp.escape(word)}([^a-z0-9]|\$)',
      );
      if (boundary.hasMatch(normalized)) return true;
    }
    return false;
  }

  bool _isUppercase(String line) {
    final letters = line.replaceAll(_lettersOnlyPattern, '');
    if (letters.isEmpty) return false;
    final uppercase = letters.replaceAll(_uppercasePattern, '').length;
    return uppercase * 2 >= letters.length;
  }

  String? _selectCandidate(String line) {
    final trimmed = line.trim();
    if (trimmed.length < 3 || trimmed.length > maxNameLength) return null;

    final lowercase = trimmed.toLowerCase();
    if (OcrKeywordMatcher.containsAny(lowercase, MerchantKeywords.noise)) {
      return null;
    }
    if (lowercase.contains('@') || lowercase.contains('http')) return null;
    if (_currencyPattern.hasMatch(trimmed)) return null;
    if (_dateLikePattern.hasMatch(trimmed)) return null;

    final letters = trimmed.replaceAll(_lettersOnlyPattern, '');
    if (letters.length < 3) return null;

    final digits = trimmed.replaceAll(_digitsOnlyPattern, '');
    if (digits.length > letters.length) return null;

    return trimmed;
  }

  /// Lowercases and folds Turkish/accented letters to ASCII, so a marker like
  /// `tic` still matches the `TÍC` OCR often prints.
  static String _normalize(String text) {
    final buffer = StringBuffer();
    for (final rune in text.toLowerCase().runes) {
      final char = String.fromCharCode(rune);
      buffer.write(_foldings[char] ?? char);
    }
    return buffer.toString();
  }
}
