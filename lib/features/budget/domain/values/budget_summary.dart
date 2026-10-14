import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:smart_budget_tracker/core/values/money.dart';
import 'package:smart_budget_tracker/core/values/year_month.dart';

/// Health of a monthly budget, derived from the usage ratio.
///
/// The thresholds are domain rules: "80% spent" is a warning, "over the limit"
/// is an overspend. Keeping them here means every screen shows the same colour
/// for the same number.
enum BudgetStatus {
  /// No limit configured for the month.
  noBudget,

  /// Less than 80% of the limit is used.
  healthy,

  /// 80% or more of the limit is used, but it is not exceeded yet.
  warning,

  /// More money was spent than the limit allows.
  exceeded,
}

/// Read model combining a month's limit with what was actually spent.
///
/// Built by `WatchBudgetSummaryUseCase` from two reactive sources (the limit and
/// the transaction totals), which is why it is a value object rather than an
/// entity: it has no identity of its own.
@immutable
final class BudgetSummary extends Equatable {
  const BudgetSummary({
    required this.period,
    required this.spent,
    required this.income,
    this.limit,
  });

  /// Ratio of the limit at which the budget starts to be reported as
  /// [BudgetStatus.warning].
  static const double warningThreshold = 0.8;

  final YearMonth period;

  /// Money spent in [period], in the reporting currency.
  final Money spent;

  /// Money earned in [period], in the reporting currency.
  final Money income;

  /// The configured limit, or `null` when the user has not set one.
  final Money? limit;

  /// Whether a limit is configured for [period].
  bool get hasLimit => limit != null;

  /// Share of the limit that was used, capped at `0` when no limit is set.
  double get usage {
    final allowance = limit;
    if (allowance == null || allowance.isZero) return 0;
    return spent.ratioTo(allowance);
  }

  /// Money left until the limit is reached; zero when no limit is set.
  Money get remaining {
    final allowance = limit;
    if (allowance == null) return Money.zero(spent.currency);
    return allowance - spent;
  }

  /// Amount spent beyond the limit; zero when inside the budget.
  Money get overspend {
    final allowance = limit;
    if (allowance == null || spent < allowance) {
      return Money.zero(spent.currency);
    }
    return spent - allowance;
  }

  /// Current health of the budget.
  BudgetStatus get status {
    final allowance = limit;
    if (allowance == null) return BudgetStatus.noBudget;
    if (spent > allowance) return BudgetStatus.exceeded;
    if (usage >= warningThreshold) return BudgetStatus.warning;
    return BudgetStatus.healthy;
  }

  @override
  List<Object?> get props => [period, spent, income, limit];
}
