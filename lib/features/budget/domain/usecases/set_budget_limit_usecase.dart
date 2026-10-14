import 'package:smart_budget_tracker/core/config/app_config.dart';
import 'package:smart_budget_tracker/core/error/failure.dart';
import 'package:smart_budget_tracker/core/error/result.dart';
import 'package:smart_budget_tracker/core/values/money.dart';
import 'package:smart_budget_tracker/core/values/unit.dart';
import 'package:smart_budget_tracker/core/values/year_month.dart';
import 'package:smart_budget_tracker/features/budget/domain/repositories/budget_repository.dart';

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
            field: 'limit',
          ),
        ),
      );
    }
    return _repository.setLimit(period: period, limit: limit);
  }
}
