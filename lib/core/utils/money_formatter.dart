import 'package:ant_budget/core/values/currency.dart';
import 'package:ant_budget/core/values/money.dart';

/// Separators of a language: `1,234.56` (English) vs `1.234,56` (Turkish).
final class _Separators {
  const _Separators({required this.group, required this.decimal});

  final String group;
  final String decimal;

  static const _Separators english = _Separators(group: ',', decimal: '.');
  static const _Separators turkish = _Separators(group: '.', decimal: ',');

  /// Separators used for [languageCode]; English for anything unmodelled.
  static _Separators of(String languageCode) =>
      languageCode == 'tr' ? turkish : english;
}

/// Renders [Money] for the UI.
///
/// A single, dependency free place to change how amounts look: grouping with
/// thousands separators, symbol placement, negative amounts. Language only
/// changes the separators, so no locale bundle has to be initialised.
abstract final class MoneyFormatter {
  /// Default language: grouped with `,` and a `.` decimal point.
  static const String _defaultLanguage = 'en';

  /// Formats [money] as `₺1,234.56` in English, `₺1.234,56` in Turkish
  /// (negative: `-₺1,234.56`).
  static String format(
    Money money, {
    bool withSymbol = true,
    String languageCode = _defaultLanguage,
  }) {
    final sign = money.isNegative ? '-' : '';
    final symbol = withSymbol ? money.currency.symbol : '';
    final amount = formatMinorUnits(
      money.minorUnits.abs(),
      money.currency,
      languageCode: languageCode,
    );
    return '$sign$symbol$amount';
  }

  /// Formats an exact amount of [minorUnits] without a sign.
  static String formatMinorUnits(
    int minorUnits,
    Currency currency, {
    String languageCode = _defaultLanguage,
  }) {
    final separators = _Separators.of(languageCode);
    final scale = _scaleFor(currency);
    final whole = minorUnits ~/ scale;
    final fraction = minorUnits % scale;
    final grouped = _groupThousands(whole, separators.group);
    if (currency.decimalDigits == 0) return grouped;
    final fractionText = fraction.toString().padLeft(currency.decimalDigits, '0');
    return '$grouped${separators.decimal}$fractionText';
  }

  static String _groupThousands(int value, String separator) {
    final digits = value.toString();
    if (digits.length <= 3) return digits;
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      final remaining = digits.length - i;
      buffer.write(digits[i]);
      if (remaining > 1 && remaining % 3 == 1) buffer.write(separator);
    }
    return buffer.toString();
  }

  static int _scaleFor(Currency currency) {
    var scale = 1;
    for (var i = 0; i < currency.decimalDigits; i++) {
      scale *= 10;
    }
    return scale;
  }
}
