import 'package:drift/drift.dart';
import 'package:smart_budget_tracker/core/data/database/app_database.dart';
import 'package:smart_budget_tracker/core/error/failure_stream_x.dart';
import 'package:smart_budget_tracker/core/values/currency.dart';
import 'package:smart_budget_tracker/core/values/money.dart';
import 'package:smart_budget_tracker/core/values/transaction_kind.dart';
import 'package:smart_budget_tracker/core/values/year_month.dart';
import 'package:smart_budget_tracker/features/transactions/domain/values/transaction_filter.dart';

/// Data source owning every SQL statement that touches `transactions`.
///
/// It is a plain class (no Drift DAO mixin) so it can be constructed with the
/// database instance by a Riverpod provider and faked in tests.
class TransactionDao {
  TransactionDao(this._database);

  final AppDatabase _database;

  /// Streams the rows matching [filter], newest first.
  Stream<List<TransactionDto>> watch(TransactionFilter filter) {
    final query = _database.select(_database.transactions);
    final period = filter.period;
    final categoryId = filter.categoryId;
    final kind = filter.kind;

    if (period != null) {
      query.where(
        (t) =>
            t.occurredAt.isBiggerOrEqualValue(period.start) &
            t.occurredAt.isSmallerThanValue(period.endExclusive),
      );
    }
    if (categoryId != null) {
      query.where((t) => t.categoryId.equals(categoryId));
    }
    if (kind != null) {
      query.where((t) => t.kind.equalsValue(kind));
    }
    query.orderBy([
      (t) => OrderingTerm.desc(t.occurredAt),
      (t) => OrderingTerm.desc(t.id),
    ]);

    return query.watch().mapErrorsToFailures();
  }

  /// Sums the [kind] amounts of [period], restricted to [currency].
  ///
  /// The sum is computed by SQLite; only the resulting minor units travel into
  /// the domain.
  Stream<Money> watchTotal({
    required YearMonth period,
    required TransactionKind kind,
    required Currency currency,
  }) {
    final table = _database.transactions;
    final total = table.amountMinorUnits.sum();
    final query = _database.selectOnly(table)
      ..addColumns([total])
      ..where(
        table.occurredAt.isBiggerOrEqualValue(period.start) &
            table.occurredAt.isSmallerThanValue(period.endExclusive) &
            table.kind.equalsValue(kind) &
            table.currency.equalsValue(currency),
      );

    return query
        .watchSingle()
        .map((row) => Money(row.read(total) ?? 0, currency))
        .mapErrorsToFailures();
  }

  /// Inserts a row and returns its auto generated id.
  Future<int> insert(TransactionsCompanion companion) =>
      _database.into(_database.transactions).insert(companion);

  /// Deletes a row by id; returns the number of deleted rows.
  Future<int> deleteById(int id) =>
      (_database.delete(_database.transactions)..where((t) => t.id.equals(id)))
          .go();
}
