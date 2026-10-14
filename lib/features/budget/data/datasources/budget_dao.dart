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
}
