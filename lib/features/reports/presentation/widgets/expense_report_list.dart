import 'package:flutter/material.dart';
import 'package:ant_budget/core/utils/money_formatter.dart';
import 'package:ant_budget/features/categories/domain/entities/category.dart';
import 'package:ant_budget/features/categories/presentation/category_label.dart';
import 'package:ant_budget/features/reports/domain/values/expense_breakdown.dart';
import 'package:ant_budget/features/reports/presentation/widgets/breakdown_slice_tile.dart';
import 'package:ant_budget/features/reports/presentation/widgets/category_breakdown_chart.dart';
import 'package:ant_budget/features/reports/presentation/widgets/merchant_breakdown_list.dart';
import 'package:ant_budget/l10n/l10n.dart';

/// One selected report dimension for a month, with its chart and details.
///
/// This widget only arranges what the domain decided; it performs no
/// aggregation of its own.
class ExpenseReportList extends StatelessWidget {
  const ExpenseReportList({
    super.key,
    required this.report,
    required this.categories,
    required this.type,
  });

  final ExpenseBreakdown report;

  /// Categories by id, for labels and colours.
  final Map<int, Category> categories;

  final ExpenseReportType type;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = context.l10n;
    final unknown = l10n.reportsUnknownCategory;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.reportsTotalExpenses,
                style: theme.textTheme.titleMedium,
              ),
            ),
            Text(
              MoneyFormatter.format(
                report.total,
                languageCode: l10n.localeName,
              ),
              style: theme.textTheme.titleLarge,
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (type == ExpenseReportType.category) ...[
          _ReportHeading(title: l10n.reportsByCategory),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: CategoryBreakdownChart(
                slices: report.byCategory,
                categories: categories,
                total: report.total,
              ),
            ),
          ),
          const SizedBox(height: 8),
          for (final slice in report.byCategory)
            BreakdownSliceTile(
              label: categories[slice.categoryId] == null
                  ? unknown
                  : categoryLabel(l10n, categories[slice.categoryId]!),
              slice: slice,
              color: categories[slice.categoryId] == null
                  ? scheme.outline
                  : Color(categories[slice.categoryId]!.colorValue),
            ),
        ] else ...[
          _ReportHeading(title: l10n.reportsByMerchant),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: MerchantBreakdownList(slices: report.byMerchant),
            ),
          ),
        ],
      ],
    );
  }
}

enum ExpenseReportType { category, merchant }

class _ReportHeading extends StatelessWidget {
  const _ReportHeading({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) =>
      Text(title, style: Theme.of(context).textTheme.titleMedium);
}
