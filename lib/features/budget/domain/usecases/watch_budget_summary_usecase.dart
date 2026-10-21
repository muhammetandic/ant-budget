import 'package:ant_budget/core/utils/stream_extensions.dart';
import 'package:ant_budget/core/values/currency.dart';
import 'package:ant_budget/core/values/money.dart';
import 'package:ant_budget/core/values/year_month.dart';
import 'package:ant_budget/features/budget/domain/repositories/budget_repository.dart';
import 'package:ant_budget/features/budget/domain/values/budget_summary.dart';
import 'package:ant_budget/features/transactions/domain/repositories/transaction_repository.dart';

/// Combines all category limits with the month's expenses into a [BudgetSummary].
///
/// The monthly limit is the sum of category limits. The category budget stream
/// and the transaction totals feed one read model, so either changing a limit
/// or adding an expense updates the progress without manual invalidation.
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
    final budgets = _budgetRepository.watchCategoryBudgets(period);
    final totals = _transactionRepository.watchMonthlyTotals(period, _currency);

    return budgets.combineLatest(
      totals,
      (budgets, totals) {
        final limit = budgets.fold(
          Money.zero(_currency),
          (sum, budget) => sum + budget.limit,
        );
        return BudgetSummary(
          period: period,
          spent: totals.expenses,
          income: totals.income,
          limit: budgets.isEmpty ? null : limit,
        );
      },
    );
  }
}
