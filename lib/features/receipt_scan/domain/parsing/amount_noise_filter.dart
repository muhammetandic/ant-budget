/// Decides which numbers and lines on a receipt cannot be money.
///
/// The "reject" half of the amount parser. Dates, clocks, percentages, unit
/// prices and long identifiers are never the payable total, and reading any of
/// them as one is the most common way a scan comes out wrong. Keeping these
/// rules in one place leaves `AmountCandidateCollector` to do nothing but walk
/// lines and score the numbers that survive.
final class AmountNoiseFilter {
  const AmountNoiseFilter();

  /// Any run of characters a printed number can be made of.
  static final RegExp numberPattern = RegExp(r'\d[\d.,]*\d|\d');

  /// A number carrying kuruş (`56,05`, `1.234,56`): the shape a real price has.
  static final RegExp _decimalPattern = RegExp(r'\d[\d.,]*[.,]\d');

  static final RegExp _dateLikePattern = RegExp(
    r'\d{1,4}[./-]\d{1,2}[./-]\d{2,4}',
  );
  static final RegExp _timeLikePattern = RegExp(r'\d{1,2}:\d{2}');

  /// `2 x 45,50`, `0,565 KG x 620,00` — the second factor is a unit price.
  static final RegExp _unitPricePattern = RegExp(r'[xX×]\s*\d');

  static final RegExp _digitRun = RegExp(r'\d+');

  /// Whether [line] can be skipped whole: it is a date/clock line or a
  /// `quantity x unit price` line, whose unit price is never the total.
  bool isNoisyLine(String line) {
    final lowercase = line.toLowerCase();
    return _dateLikePattern.hasMatch(lowercase) ||
        _timeLikePattern.hasMatch(lowercase) ||
        _unitPricePattern.hasMatch(line);
  }

  /// Whether [line] carries a decimal amount (`56,05`).
  bool hasDecimalAmount(String line) => _decimalPattern.hasMatch(line);

  /// Whether the [token] starting at [start] is a percentage, a clock or an
  /// identifier rather than a price.
  bool isNoiseToken(String line, int start, String token) =>
      _isPercent(line, start, token) ||
      _isTime(line, start, token) ||
      _looksLikeIdentifier(token);

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
