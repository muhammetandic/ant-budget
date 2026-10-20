import 'package:flutter/material.dart';
import 'package:ant_budget/core/utils/money_formatter.dart';
import 'package:ant_budget/core/values/money.dart';
import 'package:ant_budget/features/budget/domain/values/budget_progress.dart';
import 'package:ant_budget/l10n/l10n.dart';

/// Maps a [BudgetStatus] onto colours and copy for every budget widget.
///
/// The mapping lives next to the widgets (not in the domain) because colours
/// are a presentation concern; the *thresholds* that produce the status stay in
/// the domain. Sharing it keeps the month card and each category tile on the
/// identical colour for the identical number.
abstract final class BudgetStatusPalette {
  static Color colorFor(BudgetStatus status, ColorScheme scheme) =>
      switch (status) {
        BudgetStatus.exceeded => scheme.error,
        BudgetStatus.warning => Colors.orange.shade700,
        BudgetStatus.healthy => scheme.primary,
        BudgetStatus.noBudget => scheme.outline,
      };

  /// One line describing what is left, what was exceeded — or nothing at all.
  static String labelFor(BuildContext context, BudgetProgress progress) {
    final l10n = context.l10n;
    String format(Money money) =>
        MoneyFormatter.format(money, languageCode: l10n.localeName);
    final remaining = format(progress.remaining);
    return switch (progress.status) {
      BudgetStatus.exceeded => l10n.budgetOverBudget(
        format(progress.overspend),
      ),
      BudgetStatus.warning => l10n.budgetLeftNearLimit(remaining),
      BudgetStatus.healthy => l10n.budgetLeft(remaining),
      BudgetStatus.noBudget => '',
    };
  }
}
