import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ant_budget/features/budget/presentation/widgets/budget_progress_card.dart';
import 'package:ant_budget/features/budget/presentation/widgets/category_budget_list.dart';
import 'package:ant_budget/features/transactions/presentation/providers/transaction_providers.dart';
import 'package:ant_budget/features/transactions/presentation/widgets/month_switcher.dart';
import 'package:ant_budget/l10n/l10n.dart';

/// Budget health of the selected month: the summed category limit and each
/// category's live spending underneath.
///
/// The screen only subscribes and renders; every number comes from a provider
/// (the month summary and the category budgets), both of which follow the
/// selected month.
class BudgetScreen extends ConsumerWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final month = ref.watch(selectedMonthProvider);
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.budgetTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Center(child: MonthSwitcher()),
          const SizedBox(height: 8),
          BudgetProgressCard(period: month),
          const SizedBox(height: 16),
          CategoryBudgetList(period: month),
        ],
      ),
    );
  }
}
