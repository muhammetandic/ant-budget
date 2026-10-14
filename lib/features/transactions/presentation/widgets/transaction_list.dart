import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ant_budget/core/values/year_month.dart';
import 'package:ant_budget/core/widgets/empty_state.dart';
import 'package:ant_budget/core/widgets/failure_view.dart';
import 'package:ant_budget/features/categories/presentation/providers/category_providers.dart';
import 'package:ant_budget/features/transactions/presentation/providers/transaction_providers.dart';
import 'package:ant_budget/features/transactions/presentation/widgets/transaction_tile.dart';

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
    this.emptyMessage = 'No transactions for this month yet.',
  });

  final YearMonth period;

  /// Whether the list sizes itself to its content (used inside another scroll
  /// view).
  final bool shrinkWrap;

  /// Maximum number of rows to render.
  final int? limit;

  final String emptyMessage;

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
            message: emptyMessage,
          );
        }

        return ListView.separated(
          shrinkWrap: shrinkWrap,
          physics: shrinkWrap ? const NeverScrollableScrollPhysics() : null,
          padding: shrinkWrap ? EdgeInsets.zero : const EdgeInsets.only(bottom: 88),
          itemCount: visible.length,
          separatorBuilder: (_, _) => const Divider(height: 1, indent: 72),
          itemBuilder: (context, index) {
            final transaction = visible[index];
            final tile = TransactionTile(
              transaction: transaction,
              category: categoriesById[transaction.categoryId],
            );
            final id = transaction.id;
            if (shrinkWrap || id == null) return tile;

            return Dismissible(
              key: ValueKey(id),
              direction: DismissDirection.endToStart,
              background: _DeleteBackground(),
              confirmDismiss: (_) => _delete(context, ref, id),
              child: tile,
            );
          },
        );
      },
    );
  }

  Future<bool> _delete(BuildContext context, WidgetRef ref, int id) async {
    final result = await ref.read(deleteTransactionUseCaseProvider)(id);
    if (!context.mounted) return result.isOk;
    return result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(failure.message)),
        );
        return false;
      },
      (_) => true,
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
