import 'package:flutter/material.dart';
import 'package:smart_budget_tracker/core/utils/date_formatter.dart';
import 'package:smart_budget_tracker/core/utils/money_formatter.dart';
import 'package:smart_budget_tracker/features/categories/domain/entities/category.dart';
import 'package:smart_budget_tracker/features/categories/presentation/widgets/category_avatar.dart';
import 'package:smart_budget_tracker/features/transactions/domain/entities/transaction.dart';

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
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isExpense = transaction.kind.isExpense;
    final amountColor = isExpense ? scheme.error : scheme.primary;

    final currentCategory = category;
    final subtitle = [
      DateFormatter.short(transaction.occurredAt),
      if (currentCategory != null) currentCategory.name,
    ].join('  •  ');

    return ListTile(
      onTap: onTap,
      leading: currentCategory == null
          ? const UnknownCategoryAvatar()
          : CategoryAvatar(category: currentCategory),
      title: Text(
        transaction.displayTitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        subtitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        '${isExpense ? '-' : '+'}${MoneyFormatter.format(transaction.amount)}',
        style: theme.textTheme.titleMedium?.copyWith(
          color: amountColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
