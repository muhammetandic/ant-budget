import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ant_budget/core/utils/money_formatter.dart';
import 'package:ant_budget/core/values/year_month.dart';
import 'package:ant_budget/core/widgets/failure_view.dart';
import 'package:ant_budget/features/transactions/domain/values/monthly_totals.dart';
import 'package:ant_budget/features/transactions/presentation/providers/transaction_providers.dart';
import 'package:ant_budget/l10n/l10n.dart';

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
    final l10n = context.l10n;
    final language = l10n.localeName;
    final income = MoneyFormatter.format(
      totals.income,
      languageCode: language,
    );
    final expenses = MoneyFormatter.format(
      totals.expenses,
      languageCode: language,
    );
    final balance = MoneyFormatter.format(
      totals.balance,
      languageCode: language,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Row(
          children: [
            _Stat(
              label: l10n.summaryIncome,
              value: income,
              color: scheme.primary,
            ),
            _Stat(
              label: l10n.summaryExpenses,
              value: expenses,
              color: scheme.error,
            ),
            _Stat(
              label: l10n.summaryBalance,
              value: balance,
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
