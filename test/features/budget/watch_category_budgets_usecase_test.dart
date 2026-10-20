import 'package:flutter_test/flutter_test.dart';
import 'package:ant_budget/core/values/currency.dart';
import 'package:ant_budget/core/values/money.dart';
import 'package:ant_budget/core/values/year_month.dart';
import 'package:ant_budget/features/budget/domain/entities/category_budget.dart';
import 'package:ant_budget/features/budget/domain/usecases/watch_category_budgets_usecase.dart';
import 'package:ant_budget/features/budget/domain/values/budget_progress.dart';

import 'fake_budget_repository.dart';
import 'fake_transaction_repository.dart';

void main() {
  late FakeBudgetRepository budgets;
  late FakeTransactionRepository transactions;
  late WatchCategoryBudgetsUseCase useCase;

  final month = YearMonth(2026, 10);
  Money money(int minorUnits) => Money(minorUnits, Currency.turkishLira);

  setUp(() {
    budgets = FakeBudgetRepository();
    transactions = FakeTransactionRepository();
    useCase = WatchCategoryBudgetsUseCase(
      budgets,
      transactions,
      Currency.turkishLira,
    );
  });

  test('pairs every stored limit with the spending of its category', () async {
    budgets.categoryBudgets = [
      CategoryBudget(period: month, categoryId: 1, limit: money(50_000)),
      CategoryBudget(period: month, categoryId: 2, limit: money(20_000)),
    ];
    transactions.expenseTotals = {1: money(12_050)};

    final summaries = await useCase(month).first;

    expect(summaries.map((summary) => summary.categoryId), [1, 2]);
    expect(summaries.first.progress.spent, money(12_050));
    expect(summaries.last.progress.spent, money(0));
    expect(summaries.every((summary) => summary.period == month), isTrue);
  });

  test('reports a category that spent past its limit as exceeded', () async {
    budgets.categoryBudgets = [
      CategoryBudget(period: month, categoryId: 1, limit: money(10_000)),
    ];
    transactions.expenseTotals = {1: money(13_500)};

    final summary = (await useCase(month).first).single;

    expect(summary.progress.remaining, money(-3_500));
    expect(summary.progress.overspend, money(3_500));
    expect(summary.progress.status, BudgetStatus.exceeded);
  });

  test('warns once eighty percent of the limit is used', () async {
    budgets.categoryBudgets = [
      CategoryBudget(period: month, categoryId: 1, limit: money(10_000)),
    ];
    transactions.expenseTotals = {1: money(8_000)};

    final summary = (await useCase(month).first).single;

    expect(summary.progress.usage, closeTo(0.8, 0.0001));
    expect(summary.progress.status, BudgetStatus.warning);
  });

  test('ignores spending of categories without a budget', () async {
    budgets.categoryBudgets = [
      CategoryBudget(period: month, categoryId: 1, limit: money(50_000)),
    ];
    transactions.expenseTotals = {2: money(9_900)};

    final summaries = await useCase(month).first;

    expect(summaries.single.categoryId, 1);
    expect(summaries.single.progress.spent, money(0));
  });
}
