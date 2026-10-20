import 'package:drift/drift.dart';
import 'package:ant_budget/core/data/database/database_seeder.dart';
import 'package:ant_budget/core/data/database/tables/tables.dart';

// Imported so the generated `part` file (which references the enum columns of
// the tables) can see them: a `part` only inherits its parent library's scope.
import 'package:ant_budget/core/values/category_icon.dart';
import 'package:ant_budget/core/values/currency.dart';
import 'package:ant_budget/core/values/transaction_kind.dart';
import 'package:ant_budget/core/values/transaction_source.dart';

part 'app_database.g.dart';

/// The single Drift database of the application.
///
/// It is opened once (see `appDatabaseProvider`) and shared by every feature
/// data source. DAOs live inside their feature and only receive this instance,
/// which keeps query logic close to the feature that owns it.
@DriftDatabase(tables: [Budgets, CategoryBudgets, Categories, Transactions])
class AppDatabase extends _$AppDatabase {
  /// Creates the database on top of [executor].
  ///
  /// Production code passes the result of `driftDatabase(name: ...)`, tests pass
  /// `NativeDatabase.memory()`.
  AppDatabase(super.executor, {List<DatabaseSeeder> seeders = const []})
    : _seeders = seeders;

  final List<DatabaseSeeder> _seeders;

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) => m.createAll(),
    onUpgrade: (Migrator m, int from, int to) async {
      // v2 added per-category budgets. Devices already run v1 with real data,
      // so the migration is purely additive: one new table, nothing reindexed.
      if (from < 2) await m.createTable(categoryBudgets);
    },
    beforeOpen: (OpeningDetails details) async {
      // SQLite ignores foreign keys unless asked to; the cascade of
      // `category_budgets.category_id` (and the guard on
      // `transactions.category_id`) only exists while this is set.
      await customStatement('PRAGMA foreign_keys = ON');
      if (!details.wasCreated) return;
      for (final seeder in _seeders) {
        await seeder.seed(this);
      }
    },
  );
}
