/// ISO-4217 currencies understood by the app.
///
/// Each value knows its ISO code, its symbol and the textual aliases that OCR
/// engines produce on receipts, so parsing and formatting stay declarative.
enum Currency {
  turkishLira(
    code: 'TRY',
    symbol: '₺',
    aliases: ['₺', 'tl', 'try', 'türk lirası'],
    decimalDigits: 2,
  ),
  usDollar(
    code: 'USD',
    symbol: r'$',
    aliases: [r'$', 'usd', 'dollar'],
    decimalDigits: 2,
  ),
  euro(
    code: 'EUR',
    symbol: '€',
    aliases: ['€', 'eur', 'euro'],
    decimalDigits: 2,
  ),
  poundSterling(
    code: 'GBP',
    symbol: '£',
    aliases: ['£', 'gbp', 'pound'],
    decimalDigits: 2,
  );

  const Currency({
    required this.code,
    required this.symbol,
    required this.aliases,
    required this.decimalDigits,
  });

  /// ISO-4217 alphabetic code, e.g. `TRY`.
  final String code;

  /// The currency symbol, e.g. `₺`.
  final String symbol;

  /// Lowercase tokens that identify this currency inside OCR text.
  final List<String> aliases;

  /// Number of decimal digits used for minor units (2 for all supported ones).
  final int decimalDigits;

  /// Resolves a currency from its ISO code (case insensitive), or `null`.
  static Currency? fromCode(String code) {
    final normalized = code.trim().toUpperCase();
    for (final currency in Currency.values) {
      if (currency.code == normalized) return currency;
    }
    return null;
  }

  /// Finds the first currency mentioned in [text], or `null`.
  ///
  /// Symbols such as `₺` are searched directly, word-like aliases (`tl`, `usd`)
  /// only as standalone tokens to avoid matching inside merchant names.
  static Currency? detectIn(String text) {
    final lowercase = text.toLowerCase();
    for (final currency in Currency.values) {
      for (final alias in currency.aliases) {
        final isSymbol = alias.length == 1 && !_isAsciiLetter(alias);
        if (isSymbol && lowercase.contains(alias)) return currency;
        if (!isSymbol && _containsWord(lowercase, alias)) return currency;
      }
    }
    return null;
  }

  static bool _containsWord(String text, String word) {
    final pattern = RegExp('[^a-z]${RegExp.escape(word)}[^a-z]');
    return pattern.hasMatch(' $text ');
  }

  static bool _isAsciiLetter(String value) {
    final code = value.codeUnitAt(0);
    return (code >= 97 && code <= 122) || (code >= 65 && code <= 90);
  }
}
