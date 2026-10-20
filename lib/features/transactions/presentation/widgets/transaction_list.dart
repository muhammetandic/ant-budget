import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ant_budget/app/router/app_routes.dart';
import 'package:ant_budget/core/presentation/failure_message.dart';
import 'package:ant_budget/core/values/year_month.dart';
import 'package:ant_budget/core/widgets/empty_state.dart';
import 'package:ant_budget/core/widgets/failure_view.dart';
import 'package:ant_budget/features/categories/presentation/providers/category_providers.dart';
import 'package:ant_budget/features/transactions/domain/entities/transaction.dart';
import 'package:ant_budget/features/transactions/presentation/providers/transaction_providers.dart';
import 'package:ant_budget/features/transactions/presentation/widgets/transaction_tile.dart';
import 'package:ant_budget/l10n/l10n.dart';

/// Reactive list of the transactions of [period].
///
/// Reused by the overview (compact, [limit]ed, no swipe) and by the dedicated
/// screen (full height, swipe to delete), so both stay in sync automatically.
class TransactionList extends ConsumerWidget {
  const TransactionList({
    super.key,
    required this.period,
    this.shrinkWrap = false,
    this.limit,
    this.emptyMessage,
  });

  final YearMonth period;

  /// Whether the list sizes itself to its content (used inside another scroll
  /// view).
  final bool shrinkWrap;

  /// Maximum number of rows to render.
  final int? limit;

  /// Overrides the placeholder shown when the month has no transactions; the
  /// localized default is used when this is `null`.
  final String? emptyMessage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(monthlyTransactionsProvider(period));
    final categoriesById = ref.watch(categoryIndexProvider);

    return transactions.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => FailureView(error: error),
      data: (items) {
        final visible = limit == null
            ? items
            : items.take(limit!).toList(growable: false);
        if (visible.isEmpty) {
          return EmptyState(
            icon: Icons.receipt_long_outlined,
            message: emptyMessage ?? context.l10n.transactionsEmpty,
          );
        }

        return ListView.separated(
          shrinkWrap: shrinkWrap,
          physics: shrinkWrap ? const NeverScrollableScrollPhysics() : null,
          padding: shrinkWrap
              ? EdgeInsets.zero
              : const EdgeInsets.only(bottom: 88),
          itemCount: visible.length,
          separatorBuilder: (_, _) => const Divider(height: 1, indent: 72),
          itemBuilder: (context, index) {
            final transaction = visible[index];
            final tile = TransactionTile(
              transaction: transaction,
              category: categoriesById[transaction.categoryId],
              onTap: () => _openEditor(context, transaction),
            );
            final id = transaction.id;
            if (shrinkWrap || id == null) return tile;

            return Dismissible(
              key: ValueKey(id),
              direction: DismissDirection.endToStart,
              background: _DeleteBackground(),
              confirmDismiss: (_) =>
                  _confirmAndDelete(context, ref, transaction),
              child: tile,
            );
          },
        );
      },
    );
  }

  /// Opens the edit form of [transaction], pushed above whatever tab shows it.
  void _openEditor(BuildContext context, Transaction transaction) =>
      context.push(AppRoutes.editTransaction, extra: transaction);

  /// Asks before deleting; the swipe only completes once the user confirmed.
  Future<bool> _confirmAndDelete(
    BuildContext context,
    WidgetRef ref,
    Transaction transaction,
  ) async {
    final l10n = context.l10n;
    final title = transaction.displayTitle;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.transactionDeleteTitle),
        content: Text(
          l10n.transactionDeleteConfirm(
            title.isEmpty ? l10n.transactionUntitled : title,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.actionCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.actionDelete),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return false;

    final id = transaction.id;
    if (id == null) return false;
    final result = await ref.read(deleteTransactionUseCaseProvider)(id);
    if (!context.mounted) return result.isOk;
    final messenger = ScaffoldMessenger.of(context);
    return result.fold(
      (failure) {
        messenger.showSnackBar(
          SnackBar(content: Text(failureMessageOf(context, failure))),
        );
        return false;
      },
      (_) {
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.transactionDeleted)),
        );
        return true;
      },
    );
  }
}

class _DeleteBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      color: scheme.errorContainer,
      child: Icon(Icons.delete_outline, color: scheme.onErrorContainer),
    );
  }
}
