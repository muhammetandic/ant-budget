import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:ant_budget/core/values/currency.dart';

/// Immutable money value object.
///
/// Amounts are stored as an integer number of **minor units** (kuruş, cents, …)
/// which makes arithmetic exact: no `double` rounding errors can ever leak into
/// a budget. Use [Money.fromMajorUnits] to build an instance from a human
/// readable amount.
@immutable
final class Money extends Equatable implements Comparable<Money> {
  /// Creates money from an exact number of [minorUnits].
  const Money(this.minorUnits, this.currency);

  /// Creates money from a major unit amount, e.g. `Money.fromMajorUnits(12.5, c)`.
  ///
  /// The value is rounded to the nearest minor unit, which is the only accepted
  /// lossy operation in this class and is reserved for external input.
  factory Money.fromMajorUnits(num majorUnits, Currency currency) {
    final scale = _scaleFor(currency);
    return Money((majorUnits * scale).round(), currency);
  }

  /// Zero money in [currency].
  factory Money.zero(Currency currency) => Money(0, currency);

  /// The amount, expressed in the currency's minor unit (2 decimals → cents).
  final int minorUnits;

  /// The currency of [minorUnits].
  final Currency currency;

  /// Whether the amount equals zero.
  bool get isZero => minorUnits == 0;

  /// Whether the amount is strictly below zero.
  bool get isNegative => minorUnits < 0;

  /// Whether the amount is strictly above zero.
  bool get isPositive => minorUnits > 0;

  /// The amount without its sign.
  Money get abs => Money(minorUnits.abs(), currency);

  /// Convenience conversion for display code; prefer keeping ints until the
  /// very last rendering step.
  double get majorUnits => minorUnits / _scaleFor(currency);

  /// Adds two amounts of the same currency.
  Money operator +(Money other) {
    _assertSameCurrency(other);
    return Money(minorUnits + other.minorUnits, currency);
  }

  /// Subtracts two amounts of the same currency.
  Money operator -(Money other) {
    _assertSameCurrency(other);
    return Money(minorUnits - other.minorUnits, currency);
  }

  /// Multiplies this amount by an integer [factor].
  Money times(int factor) => Money(minorUnits * factor, currency);

  /// Returns the ratio of this amount to [total] as a `0..n` factor.
  double ratioTo(Money total) {
    _assertSameCurrency(total);
    if (total.minorUnits == 0) return 0;
    return minorUnits / total.minorUnits;
  }

  /// Returns the larger of two amounts.
  Money max(Money other) => compareTo(other) >= 0 ? this : other;

  /// Returns the smaller of two amounts.
  Money min(Money other) => compareTo(other) <= 0 ? this : other;

  /// Clamps the amount between [lower] and [upper].
  Money clamp(Money lower, Money upper) {
    if (compareTo(lower) < 0) return lower;
    if (compareTo(upper) > 0) return upper;
    return this;
  }

  @override
  int compareTo(Money other) {
    _assertSameCurrency(other);
    return minorUnits.compareTo(other.minorUnits);
  }

  bool operator >(Money other) => compareTo(other) > 0;

  bool operator <(Money other) => compareTo(other) < 0;

  @override
  List<Object?> get props => [minorUnits, currency];

  @override
  String toString() {
    final sign = isNegative ? '-' : '';
    final absolute = minorUnits.abs();
    final whole = absolute ~/ _scaleFor(currency);
    final fraction = absolute % _scaleFor(currency);
    final fractionText = fraction.toString().padLeft(currency.decimalDigits, '0');
    return '$sign$whole.$fractionText ${currency.code}';
  }

  void _assertSameCurrency(Money other) {
    if (other.currency != currency) {
      throw CurrencyMismatchError(currency, other.currency);
    }
  }

  static int _scaleFor(Currency currency) {
    var scale = 1;
    for (var i = 0; i < currency.decimalDigits; i++) {
      scale *= 10;
    }
    return scale;
  }
}

/// Thrown when two [Money] values of different currencies are combined.
///
/// This is a programming error (an `Error`, not an `Exception`): monetary
/// conversions must happen explicitly before arithmetic is attempted.
final class CurrencyMismatchError extends Error {
  CurrencyMismatchError(this.left, this.right);

  final Currency left;
  final Currency right;

  @override
  String toString() =>
      'Cannot combine $left and $right: convert the amount first.';
}
