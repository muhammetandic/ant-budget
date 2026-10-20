import 'package:ant_budget/core/error/failure.dart';
import 'package:ant_budget/core/error/result.dart';
import 'package:ant_budget/core/values/unit.dart';
import 'package:ant_budget/core/values/year_month.dart';
import 'package:ant_budget/features/budget/domain/repositories/budget_repository.dart';

/// Removes one category's budget for one month.
///
/// Deleting a limit the user never set stays a success: the outcome the UI
/// cares about is "the category no longer has a budget for this month".
final class DeleteCategoryBudgetUseCase {
  const DeleteCategoryBudgetUseCase(this._repository);

  final BudgetRepository _repository;

  Future<Result<Unit, Failure>> call({
    required YearMonth period,
    required int categoryId,
  }) => _repository.deleteCategoryLimit(period: period, categoryId: categoryId);
}
