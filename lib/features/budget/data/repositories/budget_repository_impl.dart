import 'package:ant_budget/core/error/failure.dart';
import 'package:ant_budget/core/error/result.dart';
import 'package:ant_budget/core/values/money.dart';
import 'package:ant_budget/core/values/unit.dart';
import 'package:ant_budget/core/values/year_month.dart';
import 'package:ant_budget/features/budget/data/datasources/budget_dao.dart';
import 'package:ant_budget/features/budget/data/mappers/budget_mapper.dart';
import 'package:ant_budget/features/budget/data/mappers/category_budget_mapper.dart';
import 'package:ant_budget/features/budget/domain/entities/budget.dart';
import 'package:ant_budget/features/budget/domain/entities/category_budget.dart';
import 'package:ant_budget/features/budget/domain/repositories/budget_repository.dart';

/// Drift backed implementation of [BudgetRepository].
///
/// It only orchestrates: the DAO owns the SQL, the mappers own the row-to-entity
/// translation and every throw becomes a [Failure] through `Result.attemptAsync`
/// or the stream adapter — no business rule lives here.
final class BudgetRepositoryImpl implements BudgetRepository {
  BudgetRepositoryImpl(this._dao);

  final BudgetDao _dao;

  @override
  Stream<Budget?> watchFor(YearMonth period) =>
      _dao.watchFor(period).map((dto) => dto == null ? null : BudgetMapper.toDomain(dto));

  @override
  Future<Result<Unit, Failure>> setLimit({
    required YearMonth period,
    required Money limit,
  }) => Result.attemptAsync(() async {
    await _dao.upsertLimit(period: period, limit: limit);
    return Unit.instance;
  });

  @override
  Stream<List<CategoryBudget>> watchCategoryBudgets(YearMonth period) => _dao
      .watchCategoryBudgets(period)
      .map(
        (rows) => rows
            .map(CategoryBudgetMapper.toDomain)
            .toList(growable: false),
      );

  @override
  Future<Result<Unit, Failure>> setCategoryLimit({
    required YearMonth period,
    required int categoryId,
    required Money limit,
  }) => Result.attemptAsync(() async {
    await _dao.upsertCategoryLimit(
      period: period,
      categoryId: categoryId,
      limit: limit,
    );
    return Unit.instance;
  });

  @override
  Future<Result<Unit, Failure>> deleteCategoryLimit({
    required YearMonth period,
    required int categoryId,
  }) => Result.attemptAsync(() async {
    await _dao.deleteCategoryLimit(period: period, categoryId: categoryId);
    return Unit.instance;
  });
}
