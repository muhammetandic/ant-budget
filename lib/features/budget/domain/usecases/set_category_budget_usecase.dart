import 'package:ant_budget/core/error/failure.dart';
import 'package:ant_budget/core/error/result.dart';
import 'package:ant_budget/core/values/money.dart';
import 'package:ant_budget/core/values/unit.dart';
import 'package:ant_budget/core/values/year_month.dart';
import 'package:ant_budget/features/budget/domain/repositories/budget_repository.dart';
import 'package:ant_budget/features/budget/domain/usecases/budget_limit_rules.dart';

/// Creates or replaces one category's budget for one month.
///
/// The category itself is chosen by the form (it only offers existing
/// categories), so the rules worth enforcing here are the ones about the
/// amount — the same ones the month's limit has to pass.
final class SetCategoryBudgetUseCase {
  const SetCategoryBudgetUseCase(this._repository);

  final BudgetRepository _repository;

  Future<Result<Unit, Failure>> call({
    required YearMonth period,
    required int categoryId,
    required Money limit,
  }) {
    final rejection = BudgetLimitRules.rejectionFor(limit);
    if (rejection != null) return Future.value(Result.failure(rejection));
    return _repository.setCategoryLimit(
      period: period,
      categoryId: categoryId,
      limit: limit,
    );
  }
}
