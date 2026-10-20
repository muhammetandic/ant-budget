import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ant_budget/core/config/app_config.dart';
import 'package:ant_budget/core/values/year_month.dart';
import 'package:ant_budget/features/transactions/data/providers/transaction_data_providers.dart';
import 'package:ant_budget/features/transactions/domain/entities/transaction.dart';
import 'package:ant_budget/features/transactions/domain/usecases/add_transaction_usecase.dart';
import 'package:ant_budget/features/transactions/domain/usecases/delete_transaction_usecase.dart';
import 'package:ant_budget/features/transactions/domain/usecases/update_transaction_usecase.dart';
import 'package:ant_budget/features/transactions/domain/usecases/watch_monthly_totals_usecase.dart';
import 'package:ant_budget/features/transactions/domain/usecases/watch_transactions_usecase.dart';
import 'package:ant_budget/features/transactions/domain/values/monthly_totals.dart';
import 'package:ant_budget/features/transactions/domain/values/transaction_filter.dart';

part 'transaction_providers.g.dart';

/// Use case providers: the UI depends on behaviour, not on the repository.
@riverpod
WatchTransactionsUseCase watchTransactionsUseCase(Ref ref) =>
    WatchTransactionsUseCase(ref.watch(transactionRepositoryProvider));

@riverpod
AddTransactionUseCase addTransactionUseCase(Ref ref) =>
    AddTransactionUseCase(ref.watch(transactionRepositoryProvider));

@riverpod
UpdateTransactionUseCase updateTransactionUseCase(Ref ref) =>
    UpdateTransactionUseCase(ref.watch(transactionRepositoryProvider));

@riverpod
DeleteTransactionUseCase deleteTransactionUseCase(Ref ref) =>
    DeleteTransactionUseCase(ref.watch(transactionRepositoryProvider));

@riverpod
WatchMonthlyTotalsUseCase watchMonthlyTotalsUseCase(Ref ref) =>
    WatchMonthlyTotalsUseCase(
      ref.watch(transactionRepositoryProvider),
      AppConfig.reportingCurrency,
    );

/// The month the dashboard and the transaction list are currently showing.
///
/// A tiny synchronous [Notifier]: moving between months is pure UI state, but it
/// has to be *shared* between the overview and the transaction list, which is
/// exactly what makes it a provider rather than local `setState`.
@riverpod
class SelectedMonth extends _$SelectedMonth {
  @override
  YearMonth build() => YearMonth.current();

  /// Switches to the following month.
  void next() => state = state.next;

  /// Switches to the preceding month.
  void previous() => state = state.previous;

  /// Switches to [month].
  void select(YearMonth month) => state = month;
}

/// Transactions of [period], reactively and auto-disposed per month.
@riverpod
Stream<List<Transaction>> monthlyTransactions(Ref ref, YearMonth period) =>
    ref.watch(watchTransactionsUseCaseProvider)(
      TransactionFilter(period: period),
    );

/// Aggregated totals of [period], reactively and auto-disposed per month.
@riverpod
Stream<MonthlyTotals> monthlyTotals(Ref ref, YearMonth period) =>
    ref.watch(watchMonthlyTotalsUseCaseProvider)(period);

/// Every recorded transaction, newest first.
///
/// Deliberately unfiltered: the category suggestions look at a shop's whole
/// history, which the visible month would cut off.
@riverpod
Stream<List<Transaction>> allTransactions(Ref ref) =>
    ref.watch(watchTransactionsUseCaseProvider)(const TransactionFilter());
