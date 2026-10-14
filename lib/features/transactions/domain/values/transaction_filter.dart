import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:smart_budget_tracker/core/values/transaction_kind.dart';
import 'package:smart_budget_tracker/core/values/year_month.dart';

/// Criteria used when querying transactions.
///
/// Expressed as a value object so the repository interface stays stable when a
/// new criterion (date range, text search, ...) is added.
@immutable
final class TransactionFilter extends Equatable {
  const TransactionFilter({this.period, this.categoryId, this.kind});

  /// Restricts the result to a single civil month.
  final YearMonth? period;

  /// Restricts the result to a single category.
  final int? categoryId;

  /// Restricts the result to expenses or income only.
  final TransactionKind? kind;

  /// Whether no criterion is set, i.e. the query returns everything.
  bool get isUnfiltered =>
      period == null && categoryId == null && kind == null;

  /// The same filter limited to [period].
  TransactionFilter withPeriod(YearMonth? period) => TransactionFilter(
    period: period,
    categoryId: categoryId,
    kind: kind,
  );

  @override
  List<Object?> get props => [period, categoryId, kind];
}
