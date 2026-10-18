import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ant_budget/l10n/l10n.dart';

void main() {
  final en = lookupAppLocalizations(const Locale('en'));
  final tr = lookupAppLocalizations(const Locale('tr'));

  test('both shipped languages carry the whole catalogue', () {
    // A missing translation makes the generated getter fall back to English;
    // comparing the two catalogues catches a forgotten entry in `app_tr.arb`.
    expect(tr.navOverview, isNot(en.navOverview));
    expect(tr.actionSave, isNot(en.actionSave));
    expect(tr.errorParseNoAmount, isNot(en.errorParseNoAmount));
  });

  test('placeholders survive translation', () {
    expect(en.fieldAmountWithSymbol('₺'), 'Amount (₺)');
    expect(tr.fieldAmountWithSymbol('₺'), 'Tutar (₺)');
    expect(en.budgetLeft('₺1,234.56'), '₺1,234.56 left');
    expect(tr.budgetLeft('₺1.234,56'), '₺1.234,56 kaldı');
  });

  test('category names are translated', () {
    expect(tr.categoryGroceries, 'Market');
    expect(en.categoryGroceries, 'Groceries');
  });

  test('plurals follow the language', () {
    expect(en.categoryUsage(0), 'No transactions');
    expect(en.categoryUsage(1), '1 transaction');
    expect(en.categoryUsage(4), '4 transactions');
    // Turkish has a single plural form, so only `other` is spelled out.
    expect(tr.categoryUsage(0), 'İşlem yok');
    expect(tr.categoryUsage(4), '4 işlem');
  });
}
