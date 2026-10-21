import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ant_budget/app/router/app_routes.dart';
import 'package:ant_budget/core/utils/money_formatter.dart';
import 'package:ant_budget/core/values/money.dart';
import 'package:ant_budget/core/values/year_month.dart';
import 'package:ant_budget/core/widgets/failure_view.dart';
import 'package:ant_budget/features/budget/domain/values/budget_summary.dart';
import 'package:ant_budget/features/budget/presentation/providers/budget_providers.dart';
import 'package:ant_budget/features/budget/presentation/widgets/budget_status_palette.dart';
import 'package:ant_budget/features/transactions/domain/values/monthly_totals.dart';
import 'package:ant_budget/features/transactions/presentation/providers/transaction_providers.dart';
import 'package:ant_budget/l10n/l10n.dart';

/// One compact overview of this month's budget progress and cash flow.
class MonthlyOverviewCard extends ConsumerWidget {
  const MonthlyOverviewCard({super.key, required this.period});

  final YearMonth period;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budget = ref.watch(budgetSummaryProvider(period));
    final totals = ref.watch(monthlyTotalsProvider(period));

    if (budget.isLoading || totals.isLoading) {
      return const Card(
        child: SizedBox(
          height: 176,
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }
    if (budget.hasError) return Card(child: FailureView(error: budget.error!));
    if (totals.hasError) return Card(child: FailureView(error: totals.error!));

    final summary = budget.requireValue;
    final monthlyTotals = totals.requireValue;
    return _OverviewContent(summary: summary, totals: monthlyTotals);
  }
}

class _OverviewContent extends StatelessWidget {
  const _OverviewContent({required this.summary, required this.totals});

  final BudgetSummary summary;
  final MonthlyTotals totals;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = context.l10n;
    final language = l10n.localeName;
    final limit = summary.limit;
    final statusColor = BudgetStatusPalette.colorFor(summary.status, scheme);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.budgetMonthlyBudget,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                TextButton(
                  onPressed: () => context.go(AppRoutes.budget),
                  child: Text(l10n.actionSeeAll),
                ),
              ],
            ),
            if (limit == null)
              Text(
                l10n.budgetNoneSet,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              )
            else ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    MoneyFormatter.format(
                      summary.spent,
                      languageCode: language,
                    ),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.budgetOfLimit(
                        MoneyFormatter.format(limit, languageCode: language),
                      ),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: summary.usage.clamp(0.0, 1.0).toDouble(),
                minHeight: 6,
                borderRadius: BorderRadius.circular(3),
                color: statusColor,
                backgroundColor: scheme.surfaceContainerHighest,
              ),
              const SizedBox(height: 4),
              Text(
                BudgetStatusPalette.labelFor(context, summary.progress),
                style: theme.textTheme.labelMedium?.copyWith(
                  color: statusColor,
                ),
              ),
            ],
            const SizedBox(height: 12),
            Divider(height: 1, color: scheme.outlineVariant),
            const SizedBox(height: 12),
            Row(
              children: [
                _Stat(
                  label: l10n.summaryIncome,
                  value: totals.income,
                  color: scheme.primary,
                  language: language,
                ),
                _Stat(
                  label: l10n.summaryExpenses,
                  value: totals.expenses,
                  color: scheme.error,
                  language: language,
                ),
                _Stat(
                  label: l10n.summaryBalance,
                  value: totals.balance,
                  color: scheme.onSurface,
                  language: language,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.label,
    required this.value,
    required this.color,
    required this.language,
  });

  final String label;
  final Money value;
  final Color color;
  final String language;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formatted = MoneyFormatter.format(value, languageCode: language);
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 3),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              formatted,
              style: theme.textTheme.titleSmall?.copyWith(
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
