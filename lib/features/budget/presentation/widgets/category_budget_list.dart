import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ant_budget/core/values/year_month.dart';
import 'package:ant_budget/core/widgets/failure_view.dart';
import 'package:ant_budget/features/budget/presentation/providers/budget_providers.dart';
import 'package:ant_budget/features/budget/presentation/widgets/category_budget_sheet.dart';
import 'package:ant_budget/features/budget/presentation/widgets/category_budget_tile.dart';
import 'package:ant_budget/features/categories/presentation/providers/category_providers.dart';
import 'package:ant_budget/l10n/l10n.dart';

/// The month's category budgets: a title with the "add" control, then the tiles.
///
/// The list only subscribes and renders. The read model (each stored limit
/// paired with the live spending) is assembled by `WatchCategoryBudgetsUseCase`,
/// and the labels come from `categoryIndexProvider`, so no domain object ever
/// carries a translated name.
class CategoryBudgetList extends ConsumerWidget {
  const CategoryBudgetList({super.key, required this.period});

  final YearMonth period;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgets = ref.watch(categoryBudgetsProvider(period));
    final categories = ref.watch(categoryIndexProvider);
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.budgetByCategory,
                style: theme.textTheme.titleMedium,
              ),
            ),
            IconButton(
              onPressed: () =>
                  CategoryBudgetSheet.show(context, period: period),
              tooltip: l10n.budgetCategoryAdd,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        const SizedBox(height: 4),
        budgets.when(
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, _) => FailureView(error: error),
          data: (summaries) {
            if (summaries.isEmpty) {
              return Text(
                l10n.budgetCategoryNoneSet,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              );
            }
            return Card(
              clipBehavior: Clip.antiAlias,
              margin: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var index = 0; index < summaries.length; index++) ...[
                    CategoryBudgetTile(
                      summary: summaries[index],
                      category: categories[summaries[index].categoryId],
                    ),
                    if (index < summaries.length - 1)
                      const Divider(height: 1, indent: 68),
                  ],
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
