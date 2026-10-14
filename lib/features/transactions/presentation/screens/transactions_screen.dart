import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_budget_tracker/app/router/app_routes.dart';
import 'package:smart_budget_tracker/features/transactions/presentation/providers/transaction_providers.dart';
import 'package:smart_budget_tracker/features/transactions/presentation/widgets/month_switcher.dart';
import 'package:smart_budget_tracker/features/transactions/presentation/widgets/transaction_list.dart';

/// Full history of the selected month with swipe-to-delete.
class TransactionsScreen extends ConsumerWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final month = ref.watch(selectedMonthProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Transactions')),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: MonthSwitcher(),
          ),
          const Divider(height: 1),
          Expanded(child: TransactionList(period: month)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.addTransaction),
        tooltip: 'Add transaction',
        child: const Icon(Icons.add),
      ),
    );
  }
}
