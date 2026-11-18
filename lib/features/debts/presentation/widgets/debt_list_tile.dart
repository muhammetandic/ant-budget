import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ant_budget/core/utils/date_formatter.dart';
import 'package:ant_budget/core/utils/money_formatter.dart';
import 'package:ant_budget/features/debts/domain/entities/debt_entry.dart';
import 'package:ant_budget/features/debts/presentation/providers/debt_providers.dart';
import 'package:ant_budget/features/debts/presentation/widgets/debt_form_sheet.dart';
import 'package:ant_budget/l10n/l10n.dart';

/// One row in the debts and claims list.
class DebtListTile extends ConsumerWidget {
  const DebtListTile({super.key, required this.entry});

  final DebtEntry entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = context.l10n;
    final language = l10n.localeName;

    final isClaim = entry.isClaim;
    final primaryColor = isClaim ? Colors.teal : scheme.error;
    final formattedAmount = MoneyFormatter.format(
      entry.amount,
      languageCode: language,
    );

    return ListTile(
      onTap: () => DebtFormSheet.show(context, entry: entry),
      leading: CircleAvatar(
        backgroundColor: primaryColor.withValues(alpha: 0.15),
        child: Icon(
          isClaim ? Icons.call_received : Icons.call_made,
          color: primaryColor,
          size: 20,
        ),
      ),
      title: Text(
        entry.person,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w600,
          decoration: entry.isSettled ? TextDecoration.lineThrough : null,
          color: entry.isSettled ? scheme.outline : null,
        ),
      ),
      subtitle: Row(
        children: [
          Text(
            DateFormatter.short(entry.dueDate, languageCode: language),
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: entry.isSettled
                  ? scheme.surfaceContainerHighest
                  : primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              entry.isSettled ? l10n.debtSettled : l10n.debtPending,
              style: theme.textTheme.labelSmall?.copyWith(
                color: entry.isSettled ? scheme.outline : primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${isClaim ? '+' : '-'}$formattedAmount',
            style: theme.textTheme.titleMedium?.copyWith(
              color: entry.isSettled ? scheme.outline : primaryColor,
              fontWeight: FontWeight.bold,
              decoration: entry.isSettled ? TextDecoration.lineThrough : null,
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            tooltip: entry.isSettled
                ? l10n.debtMarkPending
                : l10n.debtMarkSettled,
            icon: Icon(
              entry.isSettled
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              color: entry.isSettled ? Colors.teal : scheme.outline,
            ),
            onPressed: () {
              final id = entry.id;
              if (id != null) {
                ref.read(toggleDebtSettledUseCaseProvider)(
                  id,
                  !entry.isSettled,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
