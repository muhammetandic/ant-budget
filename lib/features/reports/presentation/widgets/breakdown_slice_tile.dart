import 'package:flutter/material.dart';
import 'package:ant_budget/core/utils/money_formatter.dart';
import 'package:ant_budget/features/reports/domain/values/expense_slice.dart';
import 'package:ant_budget/l10n/l10n.dart';

/// One row of a report legend: the colour of its slice, the label, the amount,
/// the share of the month's expenses and how many transactions it covers.
///
/// The colour matches the slice in the chart above it, so the list reads as the
/// legend of the graph rather than as a separate table.
class BreakdownSliceTile extends StatelessWidget {
  const BreakdownSliceTile({
    super.key,
    required this.label,
    required this.slice,
    required this.color,
  });

  /// Localized name of the category (or the shop name) this row stands for.
  final String label;

  final ExpenseSlice slice;

  /// Colour of the slice in the chart.
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = context.l10n;
    final amount = MoneyFormatter.format(
      slice.amount,
      languageCode: l10n.localeName,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 12,
            height: 12,
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(
                  l10n.reportsTransactions(slice.transactions),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(amount, style: theme.textTheme.titleSmall),
              const SizedBox(height: 2),
              Text(
                l10n.reportsShare(slice.sharePercent),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
