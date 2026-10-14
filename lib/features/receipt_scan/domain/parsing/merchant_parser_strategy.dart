import 'package:ant_budget/core/error/failure.dart';
import 'package:ant_budget/core/error/result.dart';
import 'package:ant_budget/features/receipt_scan/domain/parsing/ocr_parse_input.dart';
import 'package:ant_budget/features/receipt_scan/domain/parsing/ocr_parsing_strategy.dart';

/// Extracts the merchant name from the header of a receipt.
///
/// Optional by design: when nothing convincing is found the strategy succeeds
/// with `null` and the UI falls back to a generic title.
final class MerchantParserStrategy implements OcrParsingStrategy<String?> {
  const MerchantParserStrategy();

  /// Merchants are printed close to the top of the receipt.
  static const int headerLineCount = 6;

  /// Longer lines are almost always addresses or legal footers.
  static const int maxNameLength = 48;

  /// Words that disqualify a line: they belong to totals, taxes or footers.
  static const Set<String> noiseKeywords = {
    'total',
    'subtotal',
    'tax',
    'vat',
    'kdv',
    'change',
    'cash',
    'card',
    'visa',
    'mastercard',
    'credit',
    'debit',
    'receipt',
    'invoice',
    'invoice no',
    'date',
    'time',
    'tel',
    'phone',
    'fax',
    'www',
    'thank you',
    'welcome',
    'fiş',
    'fatura',
    'tarih',
    'saat',
    'toplam',
    'nakit',
    'kart',
    'müşteri',
    'kasiyer',
    'teşekkür',
  };

  static final RegExp _lettersOnlyPattern = RegExp(
    r'[^A-Za-zĞÜŞİÖÇğüşıöç]',
  );
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
    for (var index = 0; index < limit; index++) {
      final candidate = _selectCandidate(input.lines[index]);
      if (candidate != null) return Result.ok(candidate);
    }
    return const Result.ok(null);
  }

  String? _selectCandidate(String line) {
    final trimmed = line.trim();
    if (trimmed.length < 3 || trimmed.length > maxNameLength) return null;

    final lowercase = trimmed.toLowerCase();
    if (OcrKeywordMatcher.containsAny(lowercase, noiseKeywords)) return null;
    if (lowercase.contains('@') || lowercase.contains('http')) return null;
    if (_currencyPattern.hasMatch(trimmed)) return null;
    if (_dateLikePattern.hasMatch(trimmed)) return null;

    final letters = trimmed.replaceAll(_lettersOnlyPattern, '');
    if (letters.length < 3) return null;

    final digits = trimmed.replaceAll(_digitsOnlyPattern, '');
    if (digits.length > letters.length) return null;

    return trimmed;
  }
}
