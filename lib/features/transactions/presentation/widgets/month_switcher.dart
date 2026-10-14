import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_budget_tracker/core/utils/date_formatter.dart';
import 'package:smart_budget_tracker/features/transactions/presentation/providers/transaction_providers.dart';

/// Previous / current / next month control shared by the overview and the
/// transaction list.
///
/// It only moves [SelectedMonth]; every screen reading that provider follows.
class MonthSwitcher extends ConsumerWidget {
  const MonthSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final month = ref.watch(selectedMonthProvider);
    final notifier = ref.read(selectedMonthProvider.notifier);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: notifier.previous,
          icon: const Icon(Icons.chevron_left),
          tooltip: 'Previous month',
        ),
        Text(
          DateFormatter.month(month.start),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        IconButton(
          onPressed: notifier.next,
          icon: const Icon(Icons.chevron_right),
          tooltip: 'Next month',
        ),
      ],
    );
  }
}
