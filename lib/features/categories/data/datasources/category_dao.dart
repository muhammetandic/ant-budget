import 'package:drift/drift.dart';
import 'package:ant_budget/core/data/database/app_database.dart';
import 'package:ant_budget/core/error/failure_stream_x.dart';

/// Data source owning every SQL statement that touches `categories`.
///
/// The usage queries also read `transactions`, which is fine: both tables belong
/// to the core schema, so counting references here keeps the categories feature
/// from having to depend on the transactions feature.
class CategoryDao {
  CategoryDao(this._database);

  final AppDatabase _database;

  /// Streams all categories ordered by name.
  Stream<List<CategoryDto>> watchAll() =>
      (_database.select(_database.categories)
            ..orderBy([(c) => OrderingTerm.asc(c.name)]))
          .watch()
          .mapErrorsToFailures();

  /// Streams how many transactions reference each category, keyed by category
  /// id. Categories without transactions are absent from the map.
  Stream<Map<int, int>> watchUsageCounts() {
    final table = _database.transactions;
    final categoryId = table.categoryId;
    final total = table.id.count();
    final query = _database.selectOnly(table)
      ..addColumns([categoryId, total])
      ..groupBy([categoryId]);

    return query
        .watch()
        .map(
          (rows) => {
            for (final row in rows) row.read(categoryId)!: row.read(total)!,
          },
        )
        .mapErrorsToFailures();
  }

  /// Counts the transactions currently referencing [categoryId].
  Future<int> countTransactions(int categoryId) {
    final table = _database.transactions;
    final total = table.id.count();
    final query = _database.selectOnly(table)
      ..addColumns([total])
      ..where(table.categoryId.equals(categoryId));

    return query.map((row) => row.read(total) ?? 0).getSingle();
  }

  /// Inserts [companion], or updates the row with [id] when it is not null.
  Future<int> save(CategoriesCompanion companion, {int? id}) async {
    if (id == null) {
      return _database.into(_database.categories).insert(companion);
    }
    await (_database.update(
      _database.categories,
    )..where((c) => c.id.equals(id))).write(companion);
    return id;
  }

  /// Deletes a row by id; returns the number of deleted rows.
  Future<int> deleteById(int id) =>
      (_database.delete(_database.categories)..where((c) => c.id.equals(id)))
          .go();
}
