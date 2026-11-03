import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ant_budget/app/router/app_routes.dart';
import 'package:ant_budget/core/config/app_config.dart';
import 'package:ant_budget/features/dashboard/presentation/widgets/monthly_overview_card.dart';
import 'package:ant_budget/features/transactions/presentation/providers/transaction_providers.dart';
import 'package:ant_budget/features/transactions/presentation/widgets/month_switcher.dart';
import 'package:ant_budget/features/transactions/presentation/widgets/transaction_list.dart';
import 'package:ant_budget/l10n/l10n.dart';

/// Overview of the selected month: budget health, totals and recent activity.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  /// Number of recent transactions shown before "see all".
  static const int recentCount = 3;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final month = ref.watch(selectedMonthProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConfig.appName),
        actions: [
          IconButton(
            tooltip: l10n.dashboardScanTooltip,
            onPressed: () => context.push(AppRoutes.scan),
            icon: const Icon(Icons.document_scanner_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 96),
        children: [
          const Center(child: MonthSwitcher()),
          const SizedBox(height: 4),
          MonthlyOverviewCard(period: month),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                l10n.dashboardRecentTransactions,
                style: theme.textTheme.titleMedium,
              ),
              const Spacer(),
              TextButton(
                onPressed: () => context.go(AppRoutes.transactions),
                child: Text(l10n.actionSeeAll),
              ),
            ],
          ),
          TransactionList(period: month, shrinkWrap: true, limit: recentCount),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.addTransaction),
        icon: const Icon(Icons.add),
        label: Text(l10n.actionAdd),
      ),
    );
  }
}
