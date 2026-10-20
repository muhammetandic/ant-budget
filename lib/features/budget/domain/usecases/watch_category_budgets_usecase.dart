import 'package:ant_budget/core/utils/stream_extensions.dart';
import 'package:ant_budget/core/values/currency.dart';
import 'package:ant_budget/core/values/money.dart';
import 'package:ant_budget/core/values/year_month.dart';
import 'package:ant_budget/features/budget/domain/repositories/budget_repository.dart';
import 'package:ant_budget/features/budget/domain/values/budget_progress.dart';
import 'package:ant_budget/features/budget/domain/values/category_budget_summary.dart';
import 'package:ant_budget/features/transactions/domain/repositories/transaction_repository.dart';

/// Pairs each stored category budget of a month with what was actually spent
/// in that category.
///
/// Like `WatchBudgetSummaryUseCase`, two independent reactive sources feed one
/// read model and `combineLatest` re-emits whenever either side changes, so a
/// new expense updates the matching progress bar without any manual
/// invalidation. Categories without expenses count as zero, and only the
/// categories that *have* a budget appear in the result — the screen renders
/// limits, not a full category list.
///
/// The dependency on [TransactionRepository] is intentional and one-way: the
/// budget feature *reads* transactions, transactions know nothing about budgets.
final class WatchCategoryBudgetsUseCase {
  const WatchCategoryBudgetsUseCase(
    this._budgetRepository,
    this._transactionRepository,
    this._currency,
  );

  final BudgetRepository _budgetRepository;
  final TransactionRepository _transactionRepository;
  final Currency _currency;

  Stream<List<CategoryBudgetSummary>> call(YearMonth period) {
    final budgets = _budgetRepository.watchCategoryBudgets(period);
    final totals = _transactionRepository.watchExpenseTotalsByCategory(
      period,
      _currency,
    );

    return budgets.combineLatest(
      totals,
      (budgets, totals) => [
        for (final budget in budgets)
          CategoryBudgetSummary(
            period: period,
            categoryId: budget.categoryId,
            progress: BudgetProgress(
              spent: totals[budget.categoryId] ?? Money.zero(_currency),
              limit: budget.limit,
            ),
          ),
      ],
    );
  }
}
