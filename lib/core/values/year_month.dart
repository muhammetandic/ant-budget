import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Immutable value object describing a civil month, e.g. `2026-10`.
///
/// Budgets, monthly reports and period filters are all keyed by a [YearMonth]
/// instead of a raw [DateTime], so no accidental time-of-day component can leak
/// into a query.
@immutable
final class YearMonth extends Equatable implements Comparable<YearMonth> {
  /// Creates a month, asserting the `1 <= month <= 12` invariant.
  const YearMonth(this.year, this.month)
    : assert(month >= 1 && month <= 12, 'month must be within 1..12');

  /// The month [date] belongs to.
  factory YearMonth.fromDate(DateTime date) => YearMonth(date.year, date.month);

  /// The month of [now], or of the current system time.
  factory YearMonth.current([DateTime? now]) =>
      YearMonth.fromDate(now ?? DateTime.now());

  final int year;

  /// Month of the year, `1` (January) to `12` (December).
  final int month;

  /// Sortable, database friendly representation, e.g. `202610`.
  int get key => year * 100 + month;

  /// First instant of this month, inclusive.
  DateTime get start => DateTime(year, month);

  /// First instant of the next month, exclusive (use it as an upper bound).
  DateTime get endExclusive => DateTime(year, month + 1);

  /// Whether [date] falls inside this month.
  bool contains(DateTime date) => date.year == year && date.month == month;

  /// The following month.
  YearMonth get next => YearMonth(year + (month == 12 ? 1 : 0), month % 12 + 1);

  /// The preceding month.
  YearMonth get previous =>
      YearMonth(year - (month == 1 ? 1 : 0), (month + 10) % 12 + 1);

  @override
  int compareTo(YearMonth other) => key.compareTo(other.key);

  @override
  List<Object?> get props => [year, month];

  /// Machine readable representation, e.g. `2026-10`.
  @override
  String toString() => '$year-${month.toString().padLeft(2, '0')}';
}
