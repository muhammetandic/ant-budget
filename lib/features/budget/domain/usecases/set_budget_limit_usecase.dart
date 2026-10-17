import 'package:ant_budget/core/config/app_config.dart';
import 'package:ant_budget/core/error/failure.dart';
import 'package:ant_budget/core/error/result.dart';
import 'package:ant_budget/core/values/money.dart';
import 'package:ant_budget/core/values/unit.dart';
import 'package:ant_budget/core/values/year_month.dart';
import 'package:ant_budget/features/budget/domain/repositories/budget_repository.dart';

/// Creates or replaces the monthly budget limit.
final class SetBudgetLimitUseCase {
  const SetBudgetLimitUseCase(this._repository);

  final BudgetRepository _repository;

  Future<Result<Unit, Failure>> call({
    required YearMonth period,
    required Money limit,
  }) {
    if (!limit.isPositive) {
      return Future.value(
        Result.failure(
          const ValidationFailure(
            message: 'The monthly budget must be greater than zero.',
            issue: ValidationIssue.budgetNotPositive,
            field: 'limit',
          ),
        ),
      );
    }
    if (limit.currency != AppConfig.reportingCurrency) {
      // Budgets and the monthly report are kept in one currency; mixing them
      // would require exchange rates the app does not have.
      return Future.value(
        Result.failure(
          ValidationFailure(
            message:
                'Budgets are tracked in ${AppConfig.reportingCurrency.code}.',
            issue: ValidationIssue.budgetCurrencyMismatch,
            field: 'limit',
          ),
        ),
      );
    }
    return _repository.setLimit(period: period, limit: limit);
  }
}
