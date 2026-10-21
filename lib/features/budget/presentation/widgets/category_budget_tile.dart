import 'package:flutter/material.dart';
import 'package:ant_budget/core/utils/money_formatter.dart';
import 'package:ant_budget/core/values/money.dart';
import 'package:ant_budget/features/budget/domain/values/category_budget_summary.dart';
import 'package:ant_budget/features/budget/presentation/widgets/budget_status_palette.dart';
import 'package:ant_budget/features/budget/presentation/widgets/category_budget_sheet.dart';
import 'package:ant_budget/features/categories/domain/entities/category.dart';
import 'package:ant_budget/features/categories/presentation/category_label.dart';
import 'package:ant_budget/features/categories/presentation/widgets/category_avatar.dart';
import 'package:ant_budget/l10n/l10n.dart';

/// One category's budget: spending against its limit, with the shared health
/// colour, one line of copy and a tap target that opens the form for it.
///
/// [category] is nullable because a category can be deleted a moment before the
/// list rebuilds; such a row renders as "unknown" instead of crashing.
class CategoryBudgetTile extends StatelessWidget {
  const CategoryBudgetTile({
    super.key,
    required this.summary,
    required this.category,
  });

  final CategoryBudgetSummary summary;

  /// The category this budget caps, resolved from the category index.
  final Category? category;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = context.l10n;
    final progress = summary.progress;
    final color = BudgetStatusPalette.colorFor(progress.status, scheme);
    final category = this.category;
    final limit = progress.limit;
    String format(Money money) =>
        MoneyFormatter.format(money, languageCode: l10n.localeName);

    return InkWell(
      onTap: () => CategoryBudgetSheet.show(
        context,
        period: summary.period,
        initial: summary,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            category == null
                ? const UnknownCategoryAvatar()
                : CategoryAvatar(category: category),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          category == null
                              ? l10n.reportsUnknownCategory
                              : categoryLabel(l10n, category),
                          style: theme.textTheme.titleSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (limit != null)
                        Text(
                          l10n.budgetOfLimit(format(limit)),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          format(progress.spent),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          BudgetStatusPalette.labelFor(context, progress),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progress.usage.clamp(0.0, 1.0).toDouble(),
                    minHeight: 5,
                    borderRadius: BorderRadius.circular(3),
                    color: color,
                    backgroundColor: scheme.surfaceContainerHighest,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
