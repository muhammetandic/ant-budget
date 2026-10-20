import 'package:ant_budget/core/error/failure.dart';
import 'package:ant_budget/core/error/result.dart';
import 'package:ant_budget/core/values/money.dart';
import 'package:ant_budget/core/values/unit.dart';
import 'package:ant_budget/core/values/year_month.dart';
import 'package:ant_budget/features/budget/domain/entities/budget.dart';
import 'package:ant_budget/features/budget/domain/entities/category_budget.dart';
import 'package:ant_budget/features/budget/domain/repositories/budget_repository.dart';

/// Hand written [BudgetRepository] proving the budget use cases need no
/// database, exactly like `FakeCategoryRepository` does for categories.
final class FakeBudgetRepository implements BudgetRepository {
  /// Category budgets handed to the watchers.
  List<CategoryBudget> categoryBudgets = [];

  /// Limits handed to [setLimit], in call order.
  final List<Money> limits = [];

  /// `(categoryId, limit)` pairs handed to [setCategoryLimit], in call order.
  final List<(int, Money)> categoryLimits = [];

  /// `(period, categoryId)` pairs handed to [deleteCategoryLimit], in order.
  final List<(YearMonth, int)> deleted = [];

  @override
  Stream<Budget?> watchFor(YearMonth period) => Stream.value(null);

  @override
  Future<Result<Unit, Failure>> setLimit({
    required YearMonth period,
    required Money limit,
  }) async {
    limits.add(limit);
    return Result.success(Unit.instance);
  }

  @override
  Stream<List<CategoryBudget>> watchCategoryBudgets(YearMonth period) =>
      Stream.value(categoryBudgets);

  @override
  Future<Result<Unit, Failure>> setCategoryLimit({
    required YearMonth period,
    required int categoryId,
    required Money limit,
  }) async {
    categoryLimits.add((categoryId, limit));
    return Result.success(Unit.instance);
  }

  @override
  Future<Result<Unit, Failure>> deleteCategoryLimit({
    required YearMonth period,
    required int categoryId,
  }) async {
    deleted.add((period, categoryId));
    return Result.success(Unit.instance);
  }
}
