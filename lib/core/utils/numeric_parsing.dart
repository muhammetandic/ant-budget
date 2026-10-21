/// Parsing of OCR/human written decimal numbers into integer minor units.
///
/// Handles the two conventions that appear on real receipts:
///
/// * `1.234,56` / `1 234,56` — dot as grouping, comma as decimal separator
/// * `1,234.56`              — comma as grouping, dot as decimal separator
/// * `1234.56`, `45,50`      — single separator, treated as decimal when it is
///                             followed by 1..decimalDigits digits
///
/// All arithmetic stays on `int`, so no binary floating point rounding can ever
/// distort a monetary amount.
library;

/// Parses [rawToken] into minor units, or returns `null` when it is not a
/// number. Only non-negative amounts are accepted: the sign of a transaction is
/// modelled by its kind, never by a negative amount typed on a receipt.
int? parseAmountToMinorUnits(String rawToken, {int decimalDigits = 2}) {
  if (decimalDigits < 0) {
    throw ArgumentError.value(decimalDigits, 'decimalDigits');
  }

  var cleaned = rawToken.replaceAll(RegExp(r'[^0-9.,]'), '');
  if (!cleaned.contains(RegExp(r'\d'))) return null;

  // Trim trailing separators (e.g. `100.` -> `100`).
  cleaned = cleaned.replaceAll(RegExp(r'[.,]+$'), '');

  // Normalize leading separator with a decimal fraction (e.g. `.50` or `,50` -> `0.50` or `0,50`).
  // Strip extraneous consecutive leading separators first.
  cleaned = cleaned.replaceAll(RegExp(r'^[.,]+(?=[.,])'), '');
  if (cleaned.startsWith('.') || cleaned.startsWith(',')) {
    cleaned = '0$cleaned';
  }

  final digitsAndSeparators = cleaned;

  final lastDot = digitsAndSeparators.lastIndexOf('.');
  final lastComma = digitsAndSeparators.lastIndexOf(',');
  final decimalSeparatorIndex = lastDot > lastComma ? lastDot : lastComma;

  var wholePart = digitsAndSeparators;
  var fractionPart = '';

  if (decimalSeparatorIndex >= 0) {
    final fractionCandidate = digitsAndSeparators.substring(
      decimalSeparatorIndex + 1,
    );
    final isDecimal =
        fractionCandidate.isNotEmpty &&
        fractionCandidate.length <= decimalDigits &&
        !fractionCandidate.contains(RegExp(r'[.,]'));
    if (isDecimal) {
      wholePart = digitsAndSeparators.substring(0, decimalSeparatorIndex);
      fractionPart = fractionCandidate;
    }
  }

  final wholeDigits = wholePart.replaceAll(RegExp(r'[^0-9]'), '');
  final fractionDigits = fractionPart.replaceAll(RegExp(r'[^0-9]'), '');
  if (wholeDigits.isEmpty && fractionDigits.isEmpty) return null;

  final whole = int.tryParse(wholeDigits.isEmpty ? '0' : wholeDigits);
  if (whole == null) return null;

  final scale = _pow10(decimalDigits);
  final paddedFraction = fractionDigits.padRight(decimalDigits, '0');
  final fraction = decimalDigits == 0 || paddedFraction.isEmpty
      ? 0
      : int.tryParse(paddedFraction.substring(0, decimalDigits)) ?? 0;

  return whole * scale + fraction;
}

int _pow10(int exponent) {
  var result = 1;
  for (var i = 0; i < exponent; i++) {
    result *= 10;
  }
  return result;
}
