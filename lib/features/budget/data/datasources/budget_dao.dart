import 'package:drift/drift.dart';
import 'package:ant_budget/core/data/database/app_database.dart';
import 'package:ant_budget/core/error/failure_stream_x.dart';
import 'package:ant_budget/core/values/money.dart';
import 'package:ant_budget/core/values/year_month.dart';

/// Data source owning every SQL statement that touches `budgets`.
class BudgetDao {
  BudgetDao(this._database);

  final AppDatabase _database;

  /// Streams the budget row of [period], or `null` when there is none.
  Stream<BudgetDto?> watchFor(YearMonth period) =>
      (_database.select(_database.budgets)
            ..where(
              (b) => b.year.equals(period.year) & b.month.equals(period.month),
            )
            ..limit(1))
          .watchSingleOrNull()
          .mapErrorsToFailures();

  /// Inserts the limit of [period] or updates the existing row.
  ///
  /// The conflict target is the `(year, month)` unique key, not the surrogate
  /// id, which is what makes the statement a real "one budget per month" upsert.
  Future<int> upsertLimit({
    required YearMonth period,
    required Money limit,
  }) {
    final table = _database.budgets;
    return _database
        .into(table)
        .insert(
          BudgetsCompanion.insert(
            year: period.year,
            month: period.month,
            limitMinorUnits: limit.minorUnits,
            currency: limit.currency,
          ),
          onConflict: DoUpdate(
            (_) => BudgetsCompanion(
              limitMinorUnits: Value(limit.minorUnits),
              currency: Value(limit.currency),
            ),
            target: [table.year, table.month],
          ),
        );
  }

  /// Streams every category budget of [period], ordered by category id.
  ///
  /// The order is stable (category ids never change) so the list on screen
  /// cannot reshuffle while the user is reading it; labels are resolved by the
  /// presentation layer.
  Stream<List<CategoryBudgetDto>> watchCategoryBudgets(YearMonth period) =>
      (_database.select(_database.categoryBudgets)
            ..where(
              (b) => b.year.equals(period.year) & b.month.equals(period.month),
            )
            ..orderBy([(b) => OrderingTerm.asc(b.categoryId)]))
          .watch()
          .mapErrorsToFailures();

  /// Inserts [categoryId]'s limit for [period] or replaces the stored one.
  ///
  /// Keyed on `(year, month, categoryId)` like the month's own limit, so
  /// setting a budget twice updates the row instead of duplicating it.
  Future<int> upsertCategoryLimit({
    required YearMonth period,
    required int categoryId,
    required Money limit,
  }) {
    final table = _database.categoryBudgets;
    return _database
        .into(table)
        .insert(
          CategoryBudgetsCompanion.insert(
            year: period.year,
            month: period.month,
            categoryId: categoryId,
            limitMinorUnits: limit.minorUnits,
            currency: limit.currency,
          ),
          onConflict: DoUpdate(
            (_) => CategoryBudgetsCompanion(
              limitMinorUnits: Value(limit.minorUnits),
              currency: Value(limit.currency),
            ),
            target: [table.year, table.month, table.categoryId],
          ),
        );
  }

  /// Deletes [categoryId]'s budget for [period]; returns the rows removed.
  Future<int> deleteCategoryLimit({
    required YearMonth period,
    required int categoryId,
  }) =>
      (_database.delete(_database.categoryBudgets)
            ..where(
              (b) =>
                  b.year.equals(period.year) &
                  b.month.equals(period.month) &
                  b.categoryId.equals(categoryId),
            ))
          .go();
}
