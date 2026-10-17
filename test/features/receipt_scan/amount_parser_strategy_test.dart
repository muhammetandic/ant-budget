import 'package:flutter_test/flutter_test.dart';
import 'package:ant_budget/core/values/currency.dart';
import 'package:ant_budget/core/values/money.dart';
import 'package:ant_budget/features/receipt_scan/domain/parsing/amount_parser_strategy.dart';
import 'package:ant_budget/features/receipt_scan/domain/parsing/ocr_parse_input.dart';
import 'package:ant_budget/features/receipt_scan/domain/values/ocr_raw_text.dart';

void main() {
  const strategy = AmountParserStrategy();

  Money amountOf(String text) {
    final result = strategy.parse(
      OcrParseInput.from(OcrRawText.fromText(text)),
    );
    return result.getOrElse(
      () => fail('expected the parser to find an amount'),
    );
  }

  test('prefers the labelled total over line items and subtotal', () {
    final money = amountOf('''
MIGROS TICARET A.S.
TARİH: 14.10.2026 SAAT: 15:30
Sut 1L            2     45,50
Ekmek             1     10,00
ARA TOPLAM             55,50
KDV %1                  0,55
TOPLAM                56,05 TL
NAKIT               100,00
PARA USTU           43,95
FIS NO: 12345678
''');

    expect(money, const Money(5605, Currency.turkishLira));
  });

  test('ignores a discount line that also contains the word "tutar"', () {
    final money = amountOf('''
CARREFOURSA
14-10-2026 19:44
SUT 1L                 45,50
ISKONTO TUTARI         -4,55
GENEL TOPLAM           40,95
KART                   40,95
''');

    expect(money, const Money(4095, Currency.turkishLira));
  });

  test('reads the amount when the total label sits on its own line', () {
    final money = amountOf('''
BAKKAL
14.10.2026
TOPLAM
56,05 TL
''');

    expect(money, const Money(5605, Currency.turkishLira));
  });

  test('treats a spaced percentage as a rate, not a price', () {
    final money = amountOf('''
MARKET
KDV % 20             18,66
TOPLAM              112,00
''');

    expect(money, const Money(11200, Currency.turkishLira));
  });

  test('falls back to the largest clean amount when nothing is labelled', () {
    final money = amountOf('''
KAHVE DUNYASI
14/10/2026 15:30
2x TURK KAHVESI     48,00
1x LATTE            75,00
NAKIT              140,00
FIS NO 7712345
''');

    // 140,00 (tendered) beats the 75,00 line item; the receipt id is ignored.
    expect(money, const Money(14000, Currency.turkishLira));
  });

  test('never mistakes a receipt or terminal id for the total', () {
    final money = amountOf('''
PETROL
2x SU               48,00
1x CAY              10,00
ARSIV NO 44120333
Z NO 89  TERM 00321
''');

    expect(money, const Money(4800, Currency.turkishLira));
  });

  test('handles thousands separators and detects the currency', () {
    final money = amountOf('''
ELEKTRONIK MAGAZA
TOPLAM 1.234,56 ₺
''');

    expect(money, const Money(123456, Currency.turkishLira));
  });

  test('does not read a \$ that is really a misread Ş as dollars', () {
    final money = amountOf('''
SSUK MARKETLER TỈC.A.\$
TOPLAM 293,90
''');

    expect(money, const Money(29390, Currency.turkishLira));
  });

  test('detects a foreign currency instead of the default', () {
    final money = amountOf('''
NEW YORK BAGEL SHOP
TOTAL 15.79 USD
''');

    expect(money, const Money(1579, Currency.usDollar));
  });
}
