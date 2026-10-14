import 'package:ant_budget/core/utils/stream_extensions.dart';
import 'package:ant_budget/core/values/currency.dart';
import 'package:ant_budget/core/values/year_month.dart';
import 'package:ant_budget/features/budget/domain/repositories/budget_repository.dart';
import 'package:ant_budget/features/budget/domain/values/budget_summary.dart';
import 'package:ant_budget/features/transactions/domain/repositories/transaction_repository.dart';

/// Combines the monthly limit with the month's expenses into a [BudgetSummary].
///
/// Two independent reactive sources feed one read model: the budget row and the
/// `SUM` of the month's transactions. `combineLatest` re-emits whenever either
/// side changes, so adding an expense updates the progress bar without any
/// manual invalidation.
///
/// The dependency on [TransactionRepository] is intentional and one-way: the
/// budget feature *reads* transactions, transactions know nothing about budgets.
final class WatchBudgetSummaryUseCase {
  const WatchBudgetSummaryUseCase(
    this._budgetRepository,
    this._transactionRepository,
    this._currency,
  );

  final BudgetRepository _budgetRepository;
  final TransactionRepository _transactionRepository;
  final Currency _currency;

  Stream<BudgetSummary> call(YearMonth period) {
    final budget = _budgetRepository.watchFor(period);
    final totals = _transactionRepository.watchMonthlyTotals(period, _currency);

    return budget.combineLatest(
      totals,
      (budget, totals) => BudgetSummary(
        period: period,
        spent: totals.expenses,
        income: totals.income,
        limit: budget?.limit,
      ),
    );
  }
}
