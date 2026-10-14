import 'package:smart_budget_tracker/core/error/failure.dart';
import 'package:smart_budget_tracker/core/error/result.dart';
import 'package:smart_budget_tracker/core/values/currency.dart';
import 'package:smart_budget_tracker/core/values/unit.dart';
import 'package:smart_budget_tracker/core/values/year_month.dart';
import 'package:smart_budget_tracker/features/transactions/domain/entities/transaction.dart';
import 'package:smart_budget_tracker/features/transactions/domain/values/monthly_totals.dart';
import 'package:smart_budget_tracker/features/transactions/domain/values/transaction_filter.dart';

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

  /// Inserts [transaction] and returns its new database id.
  Future<Result<int, Failure>> save(Transaction transaction);

  /// Deletes the transaction with [id].
  Future<Result<Unit, Failure>> deleteById(int id);
}
