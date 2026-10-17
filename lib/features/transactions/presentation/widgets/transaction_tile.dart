import 'package:flutter/material.dart';
import 'package:ant_budget/core/utils/date_formatter.dart';
import 'package:ant_budget/core/utils/money_formatter.dart';
import 'package:ant_budget/features/categories/domain/entities/category.dart';
import 'package:ant_budget/features/categories/presentation/category_label.dart';
import 'package:ant_budget/features/categories/presentation/widgets/category_avatar.dart';
import 'package:ant_budget/features/transactions/domain/entities/transaction.dart';
import 'package:ant_budget/l10n/l10n.dart';

/// One row of a transaction list: category, title, date and signed amount.
///
/// Purely presentational; deleting is the list's responsibility.
class TransactionTile extends StatelessWidget {
  const TransactionTile({
    super.key,
    required this.transaction,
    this.category,
    this.onTap,
  });

  final Transaction transaction;

  /// Category of the transaction, or `null` while categories are still loading.
  final Category? category;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final language = l10n.localeName;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isExpense = transaction.kind.isExpense;
    final amountColor = isExpense ? scheme.error : scheme.primary;

    final currentCategory = category;
    final subtitle = [
      DateFormatter.short(transaction.occurredAt, languageCode: language),
      if (currentCategory != null) categoryLabel(l10n, currentCategory),
    ].join('  •  ');
    final title = transaction.displayTitle;

    return ListTile(
      onTap: onTap,
      leading: currentCategory == null
          ? const UnknownCategoryAvatar()
          : CategoryAvatar(category: currentCategory),
      title: Text(
        title.isEmpty ? l10n.transactionUntitled : title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        subtitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        '${isExpense ? '-' : '+'}'
        '${MoneyFormatter.format(transaction.amount, languageCode: language)}',
        style: theme.textTheme.titleMedium?.copyWith(
          color: amountColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
