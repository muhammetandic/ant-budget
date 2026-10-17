import 'package:ant_budget/features/categories/domain/entities/category.dart';
import 'package:ant_budget/l10n/l10n.dart';

/// Localized, user facing name of [category].
///
/// The categories that ship with the app are seeded once, in English, when the
/// database is created; their name therefore doubles as a stable key and is
/// translated here. Categories the user created are shown exactly as typed.
String categoryLabel(AppLocalizations l10n, Category category) {
  if (!category.isDefault) return category.name;
  return switch (category.name) {
    'Groceries' => l10n.categoryGroceries,
    'Dining out' => l10n.categoryDining,
    'Transport' => l10n.categoryTransport,
    'Shopping' => l10n.categoryShopping,
    'Bills & utilities' => l10n.categoryBills,
    'Health' => l10n.categoryHealth,
    'Entertainment' => l10n.categoryEntertainment,
    'Salary' => l10n.categorySalary,
    'Other' => l10n.categoryOther,
    _ => category.name,
  };
}
