import 'package:ant_budget/core/error/failure.dart';
import 'package:ant_budget/core/error/result.dart';
import 'package:ant_budget/core/values/currency.dart';
import 'package:ant_budget/core/values/money.dart';
import 'package:ant_budget/core/values/unit.dart';
import 'package:ant_budget/core/values/year_month.dart';
import 'package:ant_budget/features/transactions/domain/entities/transaction.dart';
import 'package:ant_budget/features/transactions/domain/values/monthly_totals.dart';
import 'package:ant_budget/features/transactions/domain/values/transaction_filter.dart';

/// Port describing how the domain talks to transaction storage.
///
/// The implementation (Drift + SQLite) lives in the data layer; the domain only
/// knows this interface, which is what makes the use cases unit-testable with a
/// hand written fake and the storage engine replaceable.
abstract interface class TransactionRepository {
  /// Emits the transactions matching [filter], newest first, and re-emits on
  /// every write that affects the result set.
  Stream<List<Transaction>> watch(TransactionFilter filter);

  /// Emits the aggregated totals of [period] in [currency], re-emitting when
  /// either the transactions or their categories change.
  Stream<MonthlyTotals> watchMonthlyTotals(YearMonth period, Currency currency);

  /// Emits the expenses of [period] per category in [currency], keyed by
  /// category id.
  ///
  /// Categories without expenses in the month are absent from the map rather
  /// than present with zero, which is what lets a consumer iterate only the
  /// groups that actually spent something.
  Stream<Map<int, Money>> watchExpenseTotalsByCategory(
    YearMonth period,
    Currency currency,
  );

  /// Inserts [transaction] and returns its new database id.
  Future<Result<int, Failure>> save(Transaction transaction);

  /// Overwrites the stored transaction identified by [transaction.id] and
  /// returns that id.
  ///
  /// The whole row is replaced — receipt columns included — so an edit can
  /// never leave stale values behind.
  Future<Result<int, Failure>> update(Transaction transaction);

  /// Deletes the transaction with [id].
  Future<Result<Unit, Failure>> deleteById(int id);
}
