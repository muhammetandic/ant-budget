import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ant_budget/core/values/category_icon.dart';
import 'package:ant_budget/features/categories/domain/entities/category.dart';
import 'package:ant_budget/features/categories/presentation/category_label.dart';
import 'package:ant_budget/l10n/l10n.dart';

void main() {
  final en = lookupAppLocalizations(const Locale('en'));
  final tr = lookupAppLocalizations(const Locale('tr'));

  Category category(String name, {bool isDefault = true}) => Category(
    name: name,
    icon: CategoryIcon.other,
    colorValue: 0xFF455A64,
    isDefault: isDefault,
  );

  group('categoryLabel', () {
    test('translates a category that ships with the app', () {
      expect(categoryLabel(tr, category('Groceries')), 'Market');
      expect(categoryLabel(en, category('Groceries')), 'Groceries');
    });

    test('shows a user category exactly as typed', () {
      expect(categoryLabel(tr, category('Kahve', isDefault: false)), 'Kahve');
    });

    test('passes an unknown default through unchanged', () {
      expect(categoryLabel(tr, category('Pets')), 'Pets');
    });
  });
}
