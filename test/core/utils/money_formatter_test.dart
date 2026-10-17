import 'package:flutter_test/flutter_test.dart';
import 'package:ant_budget/core/utils/money_formatter.dart';
import 'package:ant_budget/core/values/currency.dart';
import 'package:ant_budget/core/values/money.dart';

void main() {
  const lira = Currency.turkishLira;

  group('MoneyFormatter', () {
    test('groups thousands and keeps the dot as decimal separator in English', () {
      expect(
        MoneyFormatter.format(Money.fromMajorUnits(1234.56, lira)),
        '₺1,234.56',
      );
    });

    test('swaps the separators for Turkish', () {
      expect(
        MoneyFormatter.format(
          Money.fromMajorUnits(1234.56, lira),
          languageCode: 'tr',
        ),
        '₺1.234,56',
      );
    });

    test('keeps the symbol in front in both languages', () {
      const amount = Money(5, Currency.usDollar);
      expect(MoneyFormatter.format(amount), r'$0.05');
      expect(MoneyFormatter.format(amount, languageCode: 'tr'), r'$0,05');
    });

    test('prints the sign before the symbol', () {
      const amount = Money(-5050, Currency.euro);
      expect(MoneyFormatter.format(amount), '-€50.50');
      expect(MoneyFormatter.format(amount, languageCode: 'tr'), '-€50,50');
    });

    test('falls back to English for an unmodelled language', () {
      expect(
        MoneyFormatter.format(
          Money.fromMajorUnits(1234.56, lira),
          languageCode: 'de',
        ),
        '₺1,234.56',
      );
    });

    test('omits the symbol when asked to', () {
      expect(
        MoneyFormatter.format(
          Money.fromMajorUnits(1000, lira),
          withSymbol: false,
          languageCode: 'tr',
        ),
        '1.000,00',
      );
    });
  });
}
