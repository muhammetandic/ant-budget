import 'package:smart_budget_tracker/core/values/currency.dart';
import 'package:smart_budget_tracker/core/values/money.dart';

/// Renders [Money] for the UI.
///
/// A single, dependency free place to change how amounts look: grouping with
/// thousands separators, symbol placement, negative amounts. Swapping this for
/// locale aware `intl` formatting later only touches this class.
abstract final class MoneyFormatter {
  /// Formats [money] as e.g. `₺1,234.56` (negative: `-₺1,234.56`).
  static String format(Money money, {bool withSymbol = true}) {
    final sign = money.isNegative ? '-' : '';
    final symbol = withSymbol ? money.currency.symbol : '';
    return '$sign$symbol${formatMinorUnits(money.minorUnits.abs(), money.currency)}';
  }

  /// Formats an exact amount of [minorUnits] without a sign.
  static String formatMinorUnits(int minorUnits, Currency currency) {
    final scale = _scaleFor(currency);
    final whole = minorUnits ~/ scale;
    final fraction = minorUnits % scale;
    final fractionText = fraction.toString().padLeft(currency.decimalDigits, '0');
    final grouped = _groupThousands(whole);
    if (currency.decimalDigits == 0) return grouped;
    return '$grouped.$fractionText';
  }

  static String _groupThousands(int value) {
    final digits = value.toString();
    if (digits.length <= 3) return digits;
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      final remaining = digits.length - i;
      buffer.write(digits[i]);
      if (remaining > 1 && remaining % 3 == 1) buffer.write(',');
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
