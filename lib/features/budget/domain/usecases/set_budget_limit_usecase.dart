import 'package:ant_budget/core/error/failure.dart';
import 'package:ant_budget/core/error/result.dart';
import 'package:ant_budget/core/values/money.dart';
import 'package:ant_budget/core/values/unit.dart';
import 'package:ant_budget/core/values/year_month.dart';
import 'package:ant_budget/features/budget/domain/repositories/budget_repository.dart';
import 'package:ant_budget/features/budget/domain/usecases/budget_limit_rules.dart';

/// Creates or replaces the monthly budget limit.
final class SetBudgetLimitUseCase {
  const SetBudgetLimitUseCase(this._repository);

  final BudgetRepository _repository;

  Future<Result<Unit, Failure>> call({
    required YearMonth period,
    required Money limit,
  }) {
    final rejection = BudgetLimitRules.rejectionFor(limit);
    if (rejection != null) return Future.value(Result.failure(rejection));
    return _repository.setLimit(period: period, limit: limit);
  }
}
