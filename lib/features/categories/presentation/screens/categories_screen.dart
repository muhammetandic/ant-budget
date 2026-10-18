import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ant_budget/core/widgets/empty_state.dart';
import 'package:ant_budget/core/widgets/failure_view.dart';
import 'package:ant_budget/features/categories/presentation/providers/category_providers.dart';
import 'package:ant_budget/features/categories/presentation/widgets/category_form_sheet.dart';
import 'package:ant_budget/features/categories/presentation/widgets/category_list_tile.dart';
import 'package:ant_budget/l10n/l10n.dart';

/// Management of the categories transactions are filed under.
///
/// Every write goes through a use case, so this screen only routes events: the
/// reactive [categoriesProvider] and [categoryUsageProvider] bring the data back.
class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final categories = ref.watch(categoriesProvider);
    final usage = ref.watch(categoryUsageProvider).value ?? const <int, int>{};

    return Scaffold(
      appBar: AppBar(title: Text(l10n.categoriesTitle)),
      body: categories.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => FailureView(error: error),
        data: (items) => items.isEmpty
            ? EmptyState(
                icon: Icons.category_outlined,
                message: l10n.categoriesEmpty,
              )
            : ListView.builder(
                padding: const EdgeInsets.only(bottom: 88),
                itemCount: items.length,
                itemBuilder: (_, index) {
                  final category = items[index];
                  return CategoryListTile(
                    category: category,
                    usageCount: usage[category.id] ?? 0,
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => CategoryFormSheet.show(context),
        tooltip: l10n.categoriesAddTooltip,
        icon: const Icon(Icons.add),
        label: Text(l10n.actionAdd),
      ),
    );
  }
}
