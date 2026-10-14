import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_budget_tracker/core/utils/money_formatter.dart';
import 'package:smart_budget_tracker/core/values/year_month.dart';
import 'package:smart_budget_tracker/core/widgets/failure_view.dart';
import 'package:smart_budget_tracker/features/transactions/domain/values/monthly_totals.dart';
import 'package:smart_budget_tracker/features/transactions/presentation/providers/transaction_providers.dart';

/// Income / expenses / balance of [period], computed by SQLite.
class MonthlySummaryCard extends ConsumerWidget {
  const MonthlySummaryCard({super.key, required this.period});

  final YearMonth period;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(monthlyTotalsProvider(period))
        .when(
          loading: () => const Card(
            child: SizedBox(
              height: 104,
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
          error: (error, _) => Card(child: FailureView(error: error)),
          data: (totals) => _SummaryContent(totals: totals),
        );
  }
}

class _SummaryContent extends StatelessWidget {
  const _SummaryContent({required this.totals});

  final MonthlyTotals totals;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Row(
          children: [
            _Stat(
              label: 'Income',
              value: MoneyFormatter.format(totals.income),
              color: scheme.primary,
            ),
            _Stat(
              label: 'Expenses',
              value: MoneyFormatter.format(totals.expenses),
              color: scheme.error,
            ),
            _Stat(
              label: 'Balance',
              value: MoneyFormatter.format(totals.balance),
              color: scheme.onSurface,
            ),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value, required this.color});

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
