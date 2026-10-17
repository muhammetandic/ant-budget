import 'package:ant_budget/core/values/currency.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Currency.detectIn', () {
    test('reads a symbol that touches a price', () {
      expect(Currency.detectIn(r'$12.50'), Currency.usDollar);
      expect(Currency.detectIn('12,50 ₺'), Currency.turkishLira);
      expect(Currency.detectIn('1.234,56 €'), Currency.euro);
    });

    test('ignores a symbol that is really a misread letter', () {
      expect(Currency.detectIn(r'SSUK MARKETLER TỈC.A.$'), isNull);
      expect(Currency.hasMoneySymbol(r'SSUK MARKETLER TỈC.A.$'), isFalse);
    });

    test('does not let a trailing symbol reach the next line', () {
      expect(
        Currency.detectIn('SSUK MARKETLER TỈC.A.\$\n8718 ANTALYA KEPEZ'),
        isNull,
      );
    });

    test('reads word aliases as standalone tokens', () {
      expect(Currency.detectIn('TOTAL 15.79 USD'), Currency.usDollar);
      expect(Currency.detectIn('TOPLAM 120,00 TL'), Currency.turkishLira);
    });
  });
}
