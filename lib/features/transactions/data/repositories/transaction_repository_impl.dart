import 'package:smart_budget_tracker/core/error/failure.dart';
import 'package:smart_budget_tracker/core/error/result.dart';
import 'package:smart_budget_tracker/core/values/currency.dart';
import 'package:smart_budget_tracker/core/values/transaction_kind.dart';
import 'package:smart_budget_tracker/core/values/unit.dart';
import 'package:smart_budget_tracker/core/values/year_month.dart';
import 'package:smart_budget_tracker/features/transactions/data/datasources/transaction_dao.dart';
import 'package:smart_budget_tracker/features/transactions/data/mappers/transaction_mapper.dart';
import 'package:smart_budget_tracker/features/transactions/domain/entities/transaction.dart';
import 'package:smart_budget_tracker/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:smart_budget_tracker/features/transactions/domain/values/monthly_totals.dart';
import 'package:smart_budget_tracker/features/transactions/domain/values/transaction_filter.dart';
import 'package:smart_budget_tracker/core/utils/stream_extensions.dart';

/// Drift backed implementation of [TransactionRepository].
///
/// Its only job is orchestration: delegate to the DAO, map rows to entities and
/// turn thrown driver errors into [Failure]s. No business rule lives here.
final class TransactionRepositoryImpl implements TransactionRepository {
  TransactionRepositoryImpl(this._dao);

  final TransactionDao _dao;

  @override
  Stream<List<Transaction>> watch(TransactionFilter filter) => _dao
      .watch(filter)
      .map(
        (rows) => rows
            .map(TransactionMapper.toDomain)
            .toList(growable: false),
      );

  @override
  Stream<MonthlyTotals> watchMonthlyTotals(YearMonth period, Currency currency) {
    final expenses = _dao.watchTotal(
      period: period,
      kind: TransactionKind.expense,
      currency: currency,
    );
    final income = _dao.watchTotal(
      period: period,
      kind: TransactionKind.income,
      currency: currency,
    );

    return expenses.combineLatest(
      income,
      (expenseTotal, incomeTotal) => MonthlyTotals(
        period: period,
        currency: currency,
        expenses: expenseTotal,
        income: incomeTotal,
      ),
    );
  }

  @override
  Future<Result<int, Failure>> save(Transaction transaction) =>
      Result.attemptAsync(
        () => _dao.insert(TransactionMapper.toCompanion(transaction)),
      );

  @override
  Future<Result<Unit, Failure>> deleteById(int id) => Result.attemptAsync(
    () async {
      await _dao.deleteById(id);
      return Unit.instance;
    },
  );
}
