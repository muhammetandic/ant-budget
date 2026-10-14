import 'package:drift/drift.dart';
import 'package:ant_budget/core/data/database/app_database.dart';
import 'package:ant_budget/core/error/failure_stream_x.dart';

/// Data source owning every SQL statement that touches `categories`.
class CategoryDao {
  CategoryDao(this._database);

  final AppDatabase _database;

  /// Streams all categories ordered by name.
  Stream<List<CategoryDto>> watchAll() =>
      (_database.select(_database.categories)
            ..orderBy([(c) => OrderingTerm.asc(c.name)]))
          .watch()
          .mapErrorsToFailures();

  /// Inserts a row and returns its auto generated id.
  Future<int> insert(CategoriesCompanion companion) =>
      _database.into(_database.categories).insert(companion);
}
