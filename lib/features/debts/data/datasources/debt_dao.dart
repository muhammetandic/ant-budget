import 'package:drift/drift.dart';
import 'package:ant_budget/core/data/database/app_database.dart';
import 'package:ant_budget/core/error/failure_stream_x.dart';

/// Data source owning SQL statements for `debts`.
class DebtDao {
  DebtDao(this._database);

  final AppDatabase _database;

  /// Streams all debts and claims ordered by settled status (pending first) and date.
  Stream<List<DebtDto>> watchAll() =>
      (_database.select(_database.debts)..orderBy([
            (d) => OrderingTerm.asc(d.isSettled),
            (d) => OrderingTerm.desc(d.dueDate),
          ]))
          .watch()
          .mapErrorsToFailures();

  /// Inserts [companion] or updates the row with [id].
  Future<int> save(DebtsCompanion companion, {int? id}) async {
    if (id == null) {
      return _database.into(_database.debts).insert(companion);
    }
    await (_database.update(
      _database.debts,
    )..where((d) => d.id.equals(id))).write(companion);
    return id;
  }

  /// Deletes the row with [id].
  Future<int> deleteById(int id) =>
      (_database.delete(_database.debts)..where((d) => d.id.equals(id))).go();

  /// Updates settled flag for [id].
  Future<int> setSettled(int id, bool isSettled) =>
      (_database.update(_database.debts)..where((d) => d.id.equals(id))).write(
        DebtsCompanion(isSettled: Value(isSettled)),
      );
}
