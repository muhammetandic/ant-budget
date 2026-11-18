import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ant_budget/core/utils/money_formatter.dart';
import 'package:ant_budget/core/values/money.dart';
import 'package:ant_budget/features/debts/presentation/providers/debt_providers.dart';
import 'package:ant_budget/l10n/l10n.dart';

/// Card summarizing pending claims, debts and the net position.
class DebtSummaryCard extends ConsumerWidget {
  const DebtSummaryCard({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = context.l10n;
    final language = l10n.localeName;
    final summary = ref.watch(debtSummaryProvider);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(l10n.debtsTitle, style: theme.textTheme.titleMedium),
                  if (onTap != null) ...[
                    const Spacer(),
                    Icon(Icons.chevron_right, size: 20, color: scheme.outline),
                  ],
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _Stat(
                    label: l10n.debtsTotalClaims,
                    value: summary.totalClaims,
                    color: Colors.teal,
                    language: language,
                  ),
                  _Stat(
                    label: l10n.debtsTotalDebts,
                    value: summary.totalDebts,
                    color: scheme.error,
                    language: language,
                  ),
                  _Stat(
                    label: l10n.debtsNetBalance,
                    value: summary.netBalance,
                    color: summary.netBalance.isNegative
                        ? scheme.error
                        : (summary.netBalance.isPositive
                              ? Colors.teal
                              : scheme.onSurface),
                    language: language,
                  ),
                ],
              ),
            ],
          ),
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
          const SizedBox(height: 4),
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
