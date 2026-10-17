import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ant_budget/core/utils/money_formatter.dart';
import 'package:ant_budget/core/values/money.dart';
import 'package:ant_budget/core/values/year_month.dart';
import 'package:ant_budget/core/widgets/failure_view.dart';
import 'package:ant_budget/features/budget/domain/values/budget_summary.dart';
import 'package:ant_budget/features/budget/presentation/providers/budget_providers.dart';
import 'package:ant_budget/l10n/l10n.dart';

/// Progress of [period]'s budget: spent amount, remaining and health colour.
class BudgetProgressCard extends ConsumerWidget {
  const BudgetProgressCard({super.key, required this.period, this.onEdit});

  final YearMonth period;

  /// Invoked when the user wants to set or change the limit.
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(budgetSummaryProvider(period))
        .when(
          loading: () => const Card(
            child: SizedBox(
              height: 132,
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
          error: (error, _) => Card(child: FailureView(error: error)),
          data: (summary) => _BudgetContent(summary: summary, onEdit: onEdit),
        );
  }
}

class _BudgetContent extends StatelessWidget {
  const _BudgetContent({required this.summary, this.onEdit});

  final BudgetSummary summary;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = context.l10n;
    final language = l10n.localeName;
    final color = _StatusPalette.colorFor(summary.status, scheme);
    final limit = summary.limit;

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
                if (onEdit != null)
                  TextButton(
                    onPressed: onEdit,
                    child: Text(limit == null ? l10n.actionSet : l10n.actionEdit),
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
              const SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    MoneyFormatter.format(
                      summary.spent,
                      languageCode: language,
                    ),
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.budgetOfLimit(
                      MoneyFormatter.format(
                        limit,
                        languageCode: language,
                      ),
                    ),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: summary.usage.clamp(0.0, 1.0).toDouble(),
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
                color: color,
                backgroundColor: scheme.surfaceContainerHighest,
              ),
              const SizedBox(height: 8),
              Text(
                _StatusPalette.labelFor(context, summary),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Maps a [BudgetStatus] onto colours and copy.
///
/// The mapping lives next to the card (not in the domain) because colours are a
/// presentation concern; the *thresholds* that produce the status stay in the
/// domain.
abstract final class _StatusPalette {
  static Color colorFor(BudgetStatus status, ColorScheme scheme) =>
      switch (status) {
        BudgetStatus.exceeded => scheme.error,
        BudgetStatus.warning => Colors.orange.shade700,
        BudgetStatus.healthy => scheme.primary,
        BudgetStatus.noBudget => scheme.outline,
      };

  static String labelFor(BuildContext context, BudgetSummary summary) {
    final l10n = context.l10n;
    final language = l10n.localeName;
    String format(Money money) =>
        MoneyFormatter.format(money, languageCode: language);
    return switch (summary.status) {
      BudgetStatus.exceeded => l10n.budgetOverBudget(format(summary.overspend)),
      BudgetStatus.warning => l10n.budgetLeftNearLimit(
        format(summary.remaining),
      ),
      BudgetStatus.healthy => l10n.budgetLeft(format(summary.remaining)),
      BudgetStatus.noBudget => '',
    };
  }
}
