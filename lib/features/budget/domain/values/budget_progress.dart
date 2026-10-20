import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:ant_budget/core/values/money.dart';

/// Health of a budget, derived from the usage ratio.
///
/// The thresholds are domain rules: "80% spent" is a warning, "over the limit"
/// is an overspend. Keeping them here means every screen shows the same colour
/// for the same number — for the month's total budget and for each category.
enum BudgetStatus {
  /// No limit configured.
  noBudget,

  /// Less than 80% of the limit is used.
  healthy,

  /// 80% or more of the limit is used, but it is not exceeded yet.
  warning,

  /// More money was spent than the limit allows.
  exceeded,
}

/// How much of a limit was spent, and what that means.
///
/// The single definition of the usage rules, shared by the monthly budget and
/// by every category budget: ratio, remainder, overspend and status all derive
/// from [spent] and [limit] alone, which is why this is a value object with no
/// identity and no period attached.
@immutable
final class BudgetProgress extends Equatable {
  const BudgetProgress({required this.spent, this.limit});

  /// Ratio of the limit at which the progress starts to be reported as
  /// [BudgetStatus.warning].
  static const double warningThreshold = 0.8;

  /// Money spent so far, in the reporting currency.
  final Money spent;

  /// The configured limit, or `null` when the user has not set one.
  final Money? limit;

  /// Whether a limit is configured.
  bool get hasLimit => limit != null;

  /// Share of the limit that was used, capped at `0` when no limit is set.
  double get usage {
    final allowance = limit;
    if (allowance == null || allowance.isZero) return 0;
    return spent.ratioTo(allowance);
  }

  /// Money left until the limit is reached; negative once the limit is passed,
  /// zero when no limit is set.
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
  List<Object?> get props => [spent, limit];
}
