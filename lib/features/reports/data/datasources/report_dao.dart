import 'package:drift/drift.dart';
import 'package:ant_budget/core/data/database/app_database.dart';
import 'package:ant_budget/core/error/failure_stream_x.dart';
import 'package:ant_budget/core/values/currency.dart';
import 'package:ant_budget/core/values/money.dart';
import 'package:ant_budget/core/values/transaction_kind.dart';
import 'package:ant_budget/core/values/year_month.dart';
import 'package:ant_budget/features/reports/domain/values/expense_group.dart';

/// Data source owning every SQL statement the reports feature needs.
///
/// It aggregates `transactions` directly: the table belongs to the core schema,
/// so the report can be built without this feature depending on the
/// transactions feature — the same arrangement the categories feature uses for
/// its usage counts.
class ReportDao {
  ReportDao(this._database);

  final AppDatabase _database;

  /// Sums the expenses of [period] per (category, merchant), in [currency].
  ///
  /// SQLite does the grouping, the summing and the counting; only the resulting
  /// buckets travel into the domain. [ExpenseGroup.lastOccurredAt] is the newest
  /// transaction of the bucket, which is what lets the report label a shop with
  /// the spelling the user has seen most recently.
  Stream<List<ExpenseGroup>> watchExpenseGroups({
    required YearMonth period,
    required Currency currency,
  }) {
    final table = _database.transactions;
    final categoryId = table.categoryId;
    final merchant = table.receiptMerchant;
    final amount = table.amountMinorUnits.sum();
    final count = table.id.count();
    final lastSeen = table.occurredAt.max();

    final query = _database.selectOnly(table)
      ..addColumns([categoryId, merchant, amount, count, lastSeen])
      ..where(
        table.occurredAt.isBiggerOrEqualValue(period.start) &
            table.occurredAt.isSmallerThanValue(period.endExclusive) &
            table.kind.equalsValue(TransactionKind.expense) &
            table.currency.equalsValue(currency),
      )
      ..groupBy([categoryId, merchant]);

    return query
        .watch()
        .map(
          (rows) => [
            for (final row in rows)
              ExpenseGroup(
                categoryId: row.read(categoryId)!,
                merchant: row.read(merchant),
                amount: Money(row.read(amount) ?? 0, currency),
                transactions: row.read(count) ?? 0,
                lastOccurredAt: row.read(lastSeen) ?? period.start,
              ),
          ],
        )
        .mapErrorsToFailures();
  }
}
