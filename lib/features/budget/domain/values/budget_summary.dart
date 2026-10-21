import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:ant_budget/core/values/money.dart';
import 'package:ant_budget/core/values/year_month.dart';
import 'package:ant_budget/features/budget/domain/values/budget_progress.dart';

/// Read model combining the sum of category limits with monthly spending.
///
/// Built by `WatchBudgetSummaryUseCase` from category budgets and transaction
/// totals, which is why it is a value object rather than an entity: it has no
/// identity of its own.
///
/// The usage rules themselves live in [BudgetProgress], shared with the
/// per-category budgets; this class only adds the period and the income side.
@immutable
final class BudgetSummary extends Equatable {
  const BudgetSummary({
    required this.period,
    required this.spent,
    required this.income,
    this.limit,
  });

  final YearMonth period;

  /// Money spent in [period], in the reporting currency.
  final Money spent;

  /// Money earned in [period], in the reporting currency.
  final Money income;

  /// Sum of the month's category limits, or `null` when none are configured.
  final Money? limit;

  /// Usage rules of this budget, shared with the category budgets.
  BudgetProgress get progress => BudgetProgress(spent: spent, limit: limit);

  /// Whether a limit is configured for [period].
  bool get hasLimit => progress.hasLimit;

  /// Share of the limit that was used, capped at `0` when no limit is set.
  double get usage => progress.usage;

  /// Money left until the limit is reached; negative once the limit is passed,
  /// zero when no limit is set.
  Money get remaining => progress.remaining;

  /// Amount spent beyond the limit; zero when inside the budget.
  Money get overspend => progress.overspend;

  /// Current health of the budget.
  BudgetStatus get status => progress.status;

  @override
  List<Object?> get props => [period, spent, income, limit];
}
