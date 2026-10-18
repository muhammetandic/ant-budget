import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ant_budget/core/presentation/failure_message.dart';
import 'package:ant_budget/features/categories/domain/entities/category.dart';
import 'package:ant_budget/features/categories/presentation/category_label.dart';
import 'package:ant_budget/features/categories/presentation/providers/category_providers.dart';
import 'package:ant_budget/features/categories/presentation/widgets/category_avatar.dart';
import 'package:ant_budget/features/categories/presentation/widgets/category_form_sheet.dart';
import 'package:ant_budget/l10n/l10n.dart';

/// One row of the category list: tap to edit, trailing button to delete.
///
/// Deletion is offered only while nothing is filed under the category; the rule
/// itself still lives in `DeleteCategoryUseCase`.
class CategoryListTile extends ConsumerWidget {
  const CategoryListTile({
    super.key,
    required this.category,
    required this.usageCount,
  });

  final Category category;

  /// Transactions currently filed under [category].
  final int usageCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final canDelete = usageCount == 0;
    return ListTile(
      leading: CategoryAvatar(category: category),
      title: Text(categoryLabel(l10n, category)),
      subtitle: Text(l10n.categoryUsage(usageCount)),
      onTap: () => CategoryFormSheet.show(context, category: category),
      trailing: IconButton(
        onPressed: canDelete ? () => _confirmDelete(context, ref) : null,
        tooltip: canDelete ? l10n.actionDelete : l10n.errorCategoryInUse,
        icon: const Icon(Icons.delete_outline),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.categoryDeleteTitle),
        content: Text(l10n.categoryDeleteConfirm(categoryLabel(l10n, category))),
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

    final result = await ref.read(deleteCategoryUseCaseProvider)(category.id!);
    if (!context.mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    result.fold(
      (failure) => messenger.showSnackBar(
        SnackBar(content: Text(failureMessageOf(context, failure))),
      ),
      (_) => messenger.showSnackBar(
        SnackBar(content: Text(context.l10n.categoryDeleted)),
      ),
    );
  }
}
