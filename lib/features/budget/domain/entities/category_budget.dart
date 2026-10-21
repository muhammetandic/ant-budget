import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:ant_budget/core/values/money.dart';
import 'package:ant_budget/core/values/year_month.dart';

/// The spending limit of one category in one civil month.
///
/// The pair `(period, categoryId)` is its natural key. The monthly budget is
/// derived by summing these category limits.
@immutable
final class CategoryBudget extends Equatable {
  const CategoryBudget({
    this.id,
    required this.period,
    required this.categoryId,
    required this.limit,
  });

  /// Database identity; `null` for a budget that was not saved yet.
  final int? id;

  /// The month this limit applies to.
  final YearMonth period;

  /// The category whose spending the limit caps.
  final int categoryId;

  /// How much the user is willing to spend on [categoryId] in [period].
  final Money limit;

  @override
  List<Object?> get props => [id, period, categoryId, limit];
}
