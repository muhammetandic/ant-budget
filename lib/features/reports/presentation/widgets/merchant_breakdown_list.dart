import 'package:flutter/material.dart';
import 'package:ant_budget/core/utils/money_formatter.dart';
import 'package:ant_budget/features/reports/domain/values/expense_slice.dart';
import 'package:ant_budget/l10n/l10n.dart';

/// Ranked horizontal bars: one row per shop, largest first.
///
/// Bars are scaled against the largest shop of the month rather than against
/// the total, so the biggest spender is easy to spot; the printed share keeps
/// each row's weight of the whole month honest.
class MerchantBreakdownList extends StatelessWidget {
  const MerchantBreakdownList({super.key, required this.slices});

  final List<ExpenseSlice> slices;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    if (slices.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          l10n.reportsNoMerchants,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    final largest = slices.first.amount.minorUnits;
    return Column(
      children: [
        for (final slice in slices)
          _MerchantBar(
            slice: slice,
            fraction: largest == 0 ? 0 : slice.amount.minorUnits / largest,
          ),
      ],
    );
  }
}

/// Label, bar and numbers of a single shop.
class _MerchantBar extends StatelessWidget {
  const _MerchantBar({required this.slice, required this.fraction});

  final ExpenseSlice slice;

  /// Width of the bar relative to the largest shop, `0..1`.
  final double fraction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = context.l10n;
    final amount = MoneyFormatter.format(
      slice.amount,
      languageCode: l10n.localeName,
    );
    final detailStyle = theme.textTheme.bodySmall?.copyWith(
      color: scheme.onSurfaceVariant,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  slice.merchant ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyLarge,
                ),
              ),
              const SizedBox(width: 12),
              Text(amount, style: theme.textTheme.titleSmall),
            ],
          ),
          const SizedBox(height: 4),
          Container(
            height: 8,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(4),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) => Align(
                alignment: AlignmentDirectional.centerStart,
                child: SizedBox(
                  width: (constraints.maxWidth * fraction).clamp(
                    0.0,
                    constraints.maxWidth,
                  ),
                  height: constraints.maxHeight,
                  child: ColoredBox(color: scheme.primary),
                ),
              ),
            ),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Text(
                l10n.reportsTransactions(slice.transactions),
                style: detailStyle,
              ),
              const Spacer(),
              Text(l10n.reportsShare(slice.sharePercent), style: detailStyle),
            ],
          ),
        ],
      ),
    );
  }
}
