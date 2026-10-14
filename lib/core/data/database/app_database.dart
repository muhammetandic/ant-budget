import 'package:drift/drift.dart';
import 'package:smart_budget_tracker/core/data/database/database_seeder.dart';
import 'package:smart_budget_tracker/core/data/database/tables/tables.dart';

// Imported so the generated `part` file (which references the enum columns of
// the tables) can see them: a `part` only inherits its parent library's scope.
import 'package:smart_budget_tracker/core/values/category_icon.dart';
import 'package:smart_budget_tracker/core/values/currency.dart';
import 'package:smart_budget_tracker/core/values/transaction_kind.dart';
import 'package:smart_budget_tracker/core/values/transaction_source.dart';

part 'app_database.g.dart';

/// The single Drift database of the application.
///
/// It is opened once (see `appDatabaseProvider`) and shared by every feature
/// data source. DAOs live inside their feature and only receive this instance,
/// which keeps query logic close to the feature that owns it.
@DriftDatabase(tables: [Budgets, Categories, Transactions])
class AppDatabase extends _$AppDatabase {
  /// Creates the database on top of [executor].
  ///
  /// Production code passes the result of `driftDatabase(name: ...)`, tests pass
  /// `NativeDatabase.memory()`.
  AppDatabase(super.executor, {List<DatabaseSeeder> seeders = const []})
    : _seeders = seeders;

  final List<DatabaseSeeder> _seeders;

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) => m.createAll(),
    beforeOpen: (OpeningDetails details) async {
      if (!details.wasCreated) return;
      for (final seeder in _seeders) {
        await seeder.seed(this);
      }
    },
  );
}
