import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ant_budget/core/values/year_month.dart';
import 'package:ant_budget/features/budget/presentation/providers/budget_providers.dart';
import 'package:ant_budget/features/budget/presentation/widgets/category_budget_delete_button.dart';
import 'package:ant_budget/l10n/l10n.dart';

/// The footer of the category budget form: the delete affordance when the
/// chosen category already has a budget in this month, and save with its
/// progress spinner.
///
/// Split from the form so the form only collects input; whether the category
/// is already budgeted is answered here by the same stream the list renders.
class CategoryBudgetActions extends ConsumerWidget {
  const CategoryBudgetActions({
    super.key,
    required this.period,
    required this.categoryId,
    required this.submitting,
    required this.onSave,
    required this.onDeleted,
  });

  final YearMonth period;

  /// The chosen category, or `null` while nothing is selected.
  final int? categoryId;

  final bool submitting;

  /// Validates and stores the form.
  final VoidCallback onSave;

  /// Closes the form once the budget was removed.
  final VoidCallback onDeleted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasBudget =
        ref
            .watch(categoryBudgetsProvider(period))
            .value
            ?.any((summary) => summary.categoryId == categoryId) ??
        false;

    return Row(
      children: [
        if (hasBudget && categoryId != null)
          CategoryBudgetDeleteButton(
            period: period,
            categoryId: categoryId!,
            onDeleted: onDeleted,
          ),
        const Spacer(),
        FilledButton(
          onPressed: submitting ? null : onSave,
          child: submitting
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(context.l10n.actionSave),
        ),
      ],
    );
  }
}
