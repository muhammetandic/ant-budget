import 'package:ant_budget/core/error/failure.dart';
import 'package:ant_budget/core/error/result.dart';
import 'package:ant_budget/core/values/currency.dart';
import 'package:ant_budget/core/values/money.dart';
import 'package:ant_budget/core/values/unit.dart';
import 'package:ant_budget/core/values/year_month.dart';
import 'package:ant_budget/features/transactions/domain/entities/transaction.dart';
import 'package:ant_budget/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:ant_budget/features/transactions/domain/values/monthly_totals.dart';
import 'package:ant_budget/features/transactions/domain/values/transaction_filter.dart';

/// Hand written [TransactionRepository] exposing what the budget use cases
/// read: the expenses of a month, per category.
final class FakeTransactionRepository implements TransactionRepository {
  /// Expense totals the fake streams, keyed by category id.
  Map<int, Money> expenseTotals = {};

  @override
  Stream<List<Transaction>> watch(TransactionFilter filter) =>
      Stream.value(const []);

  @override
  Stream<MonthlyTotals> watchMonthlyTotals(
    YearMonth period,
    Currency currency,
  ) => Stream.value(MonthlyTotals.empty(period, currency));

  @override
  Stream<Map<int, Money>> watchExpenseTotalsByCategory(
    YearMonth period,
    Currency currency,
  ) => Stream.value(expenseTotals);

  @override
  Future<Result<int, Failure>> save(Transaction transaction) async =>
      Result.success(1);

  @override
  Future<Result<int, Failure>> update(Transaction transaction) async =>
      Result.success(transaction.id ?? 0);

  @override
  Future<Result<Unit, Failure>> deleteById(int id) async =>
      Result.success(Unit.instance);
}
