import 'package:smart_budget_tracker/core/utils/numeric_parsing.dart';
import 'package:smart_budget_tracker/core/values/currency.dart';
import 'package:smart_budget_tracker/core/values/money.dart';

/// Turns what a user typed into a [Money] value.
///
/// Form fields are strings; converting them is a presentation concern, but the
/// number crunching is shared with OCR parsing through
/// [parseAmountToMinorUnits], so both paths accept `1.234,56` as well as
/// `1,234.56`.
abstract final class AmountInputParser {
  /// Parses [input], returning `null` when it is empty or not a valid
  /// non-negative amount.
  static Money? tryParse(String input, {required Currency currency}) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) return null;
    if (trimmed.startsWith('-')) return null;
    final minorUnits = parseAmountToMinorUnits(
      trimmed,
      decimalDigits: currency.decimalDigits,
    );
    if (minorUnits == null) return null;
    return Money(minorUnits, currency);
  }
}
