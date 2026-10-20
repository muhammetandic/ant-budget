import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:ant_budget/core/values/year_month.dart';
import 'package:ant_budget/features/budget/domain/values/budget_progress.dart';

/// Read model of one category's budget in one month.
///
/// Built by `WatchCategoryBudgetsUseCase` from two reactive sources (the stored
/// limits and the per-category expense totals), so it is a value object: the
/// identity lives in the pair `(period, categoryId)`.
@immutable
final class CategoryBudgetSummary extends Equatable {
  const CategoryBudgetSummary({
    required this.period,
    required this.categoryId,
    required this.progress,
  });

  /// The month the budget belongs to.
  final YearMonth period;

  /// The category this budget caps.
  final int categoryId;

  /// Limit and spending of the category, judged by the shared usage rules.
  final BudgetProgress progress;

  @override
  List<Object?> get props => [period, categoryId, progress];
}
