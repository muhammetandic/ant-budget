import 'package:flutter_test/flutter_test.dart';
import 'package:ant_budget/core/values/currency.dart';
import 'package:ant_budget/core/values/money.dart';

void main() {
  group('Money', () {
    test('adds amounts of the same currency', () {
      const left = Money(1250, Currency.turkishLira);
      const right = Money(750, Currency.turkishLira);
      expect((left + right).minorUnits, 2000);
    });

    test('rejects mixing currencies', () {
      const lira = Money(100, Currency.turkishLira);
      const dollar = Money(100, Currency.usDollar);
      expect(() => lira + dollar, throwsA(isA<CurrencyMismatchError>()));
    });

    test('fromMajorUnits rounds to the nearest minor unit', () {
      expect(
        Money.fromMajorUnits(12.345, Currency.turkishLira).minorUnits,
        1235,
      );
    });

    test('ratioTo is relative to the total', () {
      const part = Money(25, Currency.turkishLira);
      const whole = Money(100, Currency.turkishLira);
      expect(part.ratioTo(whole), 0.25);
    });
  });
}
