import 'package:flutter/material.dart';
import 'package:ant_budget/core/values/year_month.dart';
import 'package:ant_budget/features/budget/domain/values/category_budget_summary.dart';
import 'package:ant_budget/features/budget/presentation/widgets/category_budget_form.dart';

/// Presents the category budget form as a modal bottom sheet.
///
/// The sheet only owns presentation: opening itself, and keeping the form above
/// the keyboard. The fields and the use cases live in [CategoryBudgetForm].
class CategoryBudgetSheet extends StatelessWidget {
  const CategoryBudgetSheet({super.key, required this.period, this.initial});

  final YearMonth period;

  /// The budget being edited; `null` starts a new one.
  final CategoryBudgetSummary? initial;

  /// Opens the form; completes once the sheet is closed.
  static Future<void> show(
    BuildContext context, {
    required YearMonth period,
    CategoryBudgetSummary? initial,
  }) => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => CategoryBudgetSheet(period: period, initial: initial),
  );

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.fromLTRB(
      16,
      16,
      16,
      MediaQuery.viewInsetsOf(context).bottom + 16,
    ),
    child: CategoryBudgetForm(period: period, initial: initial),
  );
}
