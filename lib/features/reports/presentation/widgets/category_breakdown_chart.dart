import 'package:flutter/material.dart';
import 'package:ant_budget/core/utils/money_formatter.dart';
import 'package:ant_budget/core/values/money.dart';
import 'package:ant_budget/features/categories/domain/entities/category.dart';
import 'package:ant_budget/features/categories/presentation/category_label.dart';
import 'package:ant_budget/features/reports/domain/values/expense_slice.dart';
import 'package:ant_budget/features/reports/presentation/widgets/donut_painter.dart';
import 'package:ant_budget/l10n/l10n.dart';

/// Donut chart of one month's expenses per category.
///
/// The slices are the chart's whole input; labels and colours come from the
/// categories the user manages. At most [_maxSections] categories are drawn and
/// the tail is merged into a single "other" section, which keeps a long list of
/// small categories readable — the legend below still shows every row.
class CategoryBreakdownChart extends StatelessWidget {
  const CategoryBreakdownChart({
    super.key,
    required this.slices,
    required this.categories,
    required this.total,
  });

  /// Largest number of categories drawn before the tail is merged.
  static const int _maxSections = 7;

  /// Thickness of the ring; the hole holds the month total.
  static const double _ringThickness = 30;

  final List<ExpenseSlice> slices;

  /// Categories by id, for colours and localized names.
  final Map<int, Category> categories;

  /// Month total shown in the hole of the donut.
  final Money total;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = context.l10n;
    final values = <double>[];
    final colors = <Color>[];
    final spoken = <String>[];

    void addSlice(double value, Color color, String label) {
      values.add(value);
      colors.add(color);
      spoken.add(label);
    }

    for (final slice in slices.take(_maxSections)) {
      final category = categories[slice.categoryId];
      addSlice(
        slice.amount.minorUnits.toDouble(),
        category == null ? scheme.outline : Color(category.colorValue),
        category == null
            ? '${l10n.reportsUnknownCategory} ${l10n.reportsShare(slice.sharePercent)}'
            : '${categoryLabel(l10n, category)} ${l10n.reportsShare(slice.sharePercent)}',
      );
    }

    final tail = slices.skip(_maxSections);
    final tailMinor = tail.fold<int>(
      0,
      (sum, slice) => sum + slice.amount.minorUnits,
    );
    if (tailMinor > 0) {
      addSlice(
        tailMinor.toDouble(),
        scheme.outline,
        '${l10n.reportsOther} ${l10n.reportsShare((tailMinor / total.minorUnits * 100).round())}',
      );
    }

    return Semantics(
      // The chart paints its story; this sentence is the same story for a
      // screen reader, and the legend below repeats it row by row.
      label: '${l10n.reportsByCategory}: ${spoken.join(', ')}',
      excludeSemantics: true,
      child: SizedBox(
        height: 200,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              painter: DonutPainter(
                values: values,
                colors: colors,
                strokeWidth: _ringThickness,
              ),
              child: const SizedBox.expand(),
            ),
            IgnorePointer(
              child: Center(
                child: SizedBox(
                  width: 120,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      MoneyFormatter.format(
                        total,
                        languageCode: l10n.localeName,
                      ),
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
