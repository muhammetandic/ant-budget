import 'package:flutter/material.dart';
import 'package:ant_budget/features/categories/domain/entities/category.dart';
import 'package:ant_budget/features/categories/presentation/widgets/category_form.dart';

/// Presents the category form as a modal bottom sheet.
///
/// The sheet only owns the presentation: opening itself, and keeping the form
/// above the keyboard. The fields and the use case live in [CategoryForm].
class CategoryFormSheet extends StatelessWidget {
  const CategoryFormSheet({super.key, this.category});

  /// Category being edited; `null` creates a new one.
  final Category? category;

  /// Opens the form; completes once the sheet is closed.
  static Future<void> show(BuildContext context, {Category? category}) =>
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (_) => CategoryFormSheet(category: category),
      );

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.fromLTRB(
      16,
      16,
      16,
      MediaQuery.viewInsetsOf(context).bottom + 16,
    ),
    child: CategoryForm(category: category),
  );
}
