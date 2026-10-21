import 'package:ant_budget/core/error/failure.dart';
import 'package:ant_budget/core/error/result.dart';
import 'package:ant_budget/core/values/money.dart';
import 'package:ant_budget/core/values/unit.dart';
import 'package:ant_budget/core/values/year_month.dart';
import 'package:ant_budget/features/budget/domain/entities/budget.dart';
import 'package:ant_budget/features/budget/domain/entities/category_budget.dart';

/// Port describing how the domain stores category budgets and reads legacy
/// monthly budget records.
abstract interface class BudgetRepository {
  /// Emits the budget of [period], or `null` when the user has not set one.
  Stream<Budget?> watchFor(YearMonth period);

  /// Creates or replaces the limit of [period].
  Future<Result<Unit, Failure>> setLimit({
    required YearMonth period,
    required Money limit,
  });

  /// Emits every category budget of [period], ordered by category id.
  Stream<List<CategoryBudget>> watchCategoryBudgets(YearMonth period);

  /// Creates or replaces [categoryId]'s limit for [period].
  Future<Result<Unit, Failure>> setCategoryLimit({
    required YearMonth period,
    required int categoryId,
    required Money limit,
  });

  /// Removes [categoryId]'s limit for [period]; a no-op when there is none.
  Future<Result<Unit, Failure>> deleteCategoryLimit({
    required YearMonth period,
    required int categoryId,
  });
}
