import 'package:ant_budget/core/config/app_config.dart';
import 'package:ant_budget/core/error/failure.dart';
import 'package:ant_budget/core/values/money.dart';

/// Validation every budget limit has to pass, whatever it is attached to.
///
/// One definition shared by the month's limit and by each category limit: both
/// are amounts the user typed, and both are compared against the reporting
/// currency the summaries are computed in.
abstract final class BudgetLimitRules {
  /// The failure [limit] violates, or `null` when the value may be stored.
  static Failure? rejectionFor(Money limit) {
    if (!limit.isPositive) {
      return const ValidationFailure(
        message: 'A budget must be greater than zero.',
        issue: ValidationIssue.budgetNotPositive,
        field: 'limit',
      );
    }
    if (limit.currency != AppConfig.reportingCurrency) {
      // Budgets and the monthly report are kept in one currency; mixing them
      // would require exchange rates the app does not have.
      return ValidationFailure(
        message: 'Budgets are tracked in ${AppConfig.reportingCurrency.code}.',
        issue: ValidationIssue.budgetCurrencyMismatch,
        field: 'limit',
      );
    }
    return null;
  }
}
