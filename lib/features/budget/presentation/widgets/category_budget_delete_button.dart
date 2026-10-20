import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ant_budget/core/presentation/failure_message.dart';
import 'package:ant_budget/core/values/year_month.dart';
import 'package:ant_budget/features/budget/presentation/providers/budget_providers.dart';
import 'package:ant_budget/features/categories/domain/entities/category.dart';
import 'package:ant_budget/features/categories/presentation/category_label.dart';
import 'package:ant_budget/features/categories/presentation/providers/category_providers.dart';
import 'package:ant_budget/l10n/l10n.dart';

/// Text button removing one category's budget, after asking for confirmation.
///
/// Split from the form so the form only collects input: this widget owns the
/// "really delete it?" question and both outcomes — reporting through a
/// snackbar and closing the form via [onDeleted].
class CategoryBudgetDeleteButton extends ConsumerWidget {
  const CategoryBudgetDeleteButton({
    super.key,
    required this.period,
    required this.categoryId,
    required this.onDeleted,
  });

  final YearMonth period;

  final int categoryId;

  /// Invoked after the budget was removed, to close the form.
  final VoidCallback onDeleted;

  @override
  Widget build(BuildContext context, WidgetRef ref) => TextButton(
    onPressed: () => _delete(context, ref),
    style: TextButton.styleFrom(
      foregroundColor: Theme.of(context).colorScheme.error,
    ),
    child: Text(context.l10n.actionDelete),
  );

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.budgetCategoryDeleteTitle),
        content: Text(
          l10n.budgetCategoryDeleteConfirm(_categoryName(l10n, ref)),
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
    if (confirmed != true || !context.mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    final result = await ref.read(deleteCategoryBudgetUseCaseProvider)(
      period: period,
      categoryId: categoryId,
    );
    if (!context.mounted) return;
    result.fold(
      (failure) => messenger.showSnackBar(
        SnackBar(content: Text(failureMessageOf(context, failure))),
      ),
      (_) {
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.budgetCategoryDeleted)),
        );
        onDeleted();
      },
    );
  }

  /// The name the confirmation question mentions.
  String _categoryName(AppLocalizations l10n, WidgetRef ref) {
    final categories = ref.read(categoriesProvider).value ?? const <Category>[];
    for (final category in categories) {
      if (category.id == categoryId) return categoryLabel(l10n, category);
    }
    return l10n.reportsUnknownCategory;
  }
}
