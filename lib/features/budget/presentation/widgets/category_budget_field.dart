import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ant_budget/core/widgets/failure_view.dart';
import 'package:ant_budget/features/categories/presentation/category_label.dart';
import 'package:ant_budget/features/categories/presentation/providers/category_providers.dart';
import 'package:ant_budget/l10n/l10n.dart';

/// Dropdown collecting the category a budget belongs to.
///
/// It only forwards the id: which categories exist is `categoriesProvider`'s
/// business, and what to do with the choice stays in the form. A value that is
/// not (or no longer) in the list simply renders as "nothing selected" instead
/// of tripping the dropdown's own assertion.
class CategoryBudgetField extends ConsumerWidget {
  const CategoryBudgetField({
    super.key,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  final int? value;

  final ValueChanged<int?> onChanged;

  final bool enabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);
    final l10n = context.l10n;

    return categories.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => FailureView(error: error),
      data: (items) => DropdownButtonFormField<int>(
        initialValue: items.any((category) => category.id == value)
            ? value
            : null,
        decoration: InputDecoration(labelText: l10n.fieldCategory),
        items: [
          for (final category in items)
            DropdownMenuItem<int>(
              value: category.id,
              child: Text(categoryLabel(l10n, category)),
            ),
        ],
        onChanged: enabled ? onChanged : null,
        validator: (value) =>
            value == null ? l10n.validationChooseCategory : null,
      ),
    );
  }
}
