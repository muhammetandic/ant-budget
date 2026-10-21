import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ant_budget/core/widgets/empty_state.dart';
import 'package:ant_budget/core/widgets/failure_view.dart';
import 'package:ant_budget/features/categories/presentation/providers/category_providers.dart';
import 'package:ant_budget/features/reports/presentation/providers/report_providers.dart';
import 'package:ant_budget/features/reports/presentation/widgets/expense_report_list.dart';
import 'package:ant_budget/features/transactions/presentation/providers/transaction_providers.dart';
import 'package:ant_budget/features/transactions/presentation/widgets/month_switcher.dart';
import 'package:ant_budget/l10n/l10n.dart';

/// One selectable expense report for the selected month.
///
/// The screen only subscribes and renders. The [selectedMonthProvider] it reads
/// is the same one that drives the overview and the transaction list, and
/// [expenseBreakdownProvider] turns every write into a fresh emission.
class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  ExpenseReportType _selectedType = ExpenseReportType.category;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final month = ref.watch(selectedMonthProvider);
    final report = ref.watch(expenseBreakdownProvider(month));
    final categories = ref.watch(categoryIndexProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.reportsTitle)),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: MonthSwitcher(),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: SegmentedButton<ExpenseReportType>(
              segments: [
                ButtonSegment(
                  value: ExpenseReportType.category,
                  icon: const Icon(Icons.category_outlined),
                  label: Text(l10n.reportsByCategory),
                ),
                ButtonSegment(
                  value: ExpenseReportType.merchant,
                  icon: const Icon(Icons.storefront_outlined),
                  label: Text(l10n.reportsByMerchant),
                ),
              ],
              selected: {_selectedType},
              onSelectionChanged: (selection) =>
                  setState(() => _selectedType = selection.first),
            ),
          ),
          Expanded(
            child: report.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => FailureView(error: error),
              data: (breakdown) => breakdown.isEmpty
                  ? EmptyState(
                      icon: Icons.pie_chart_outline,
                      message: l10n.reportsNoExpenses,
                    )
                  : ExpenseReportList(
                      report: breakdown,
                      categories: categories,
                      type: _selectedType,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
