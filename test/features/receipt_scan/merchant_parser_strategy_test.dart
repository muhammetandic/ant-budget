import 'package:flutter_test/flutter_test.dart';
import 'package:ant_budget/features/receipt_scan/domain/parsing/merchant_parser_strategy.dart';
import 'package:ant_budget/features/receipt_scan/domain/parsing/ocr_parse_input.dart';
import 'package:ant_budget/features/receipt_scan/domain/values/ocr_raw_text.dart';

void main() {
  const strategy = MerchantParserStrategy();

  String? merchantOf(String text) => strategy
      .parse(OcrParseInput.from(OcrRawText.fromText(text)))
      .getOrElse(() => fail('expected the strategy to succeed'));

  test('skips the header stack and finds the company name below it', () {
    final merchant = merchantOf('''
TARIH
SAAT
FiŞ NO
TOPKDV
TOPLAM
KREDİ
SÜT 1L
EKMEK
LS SOK MARKETLER TİC.A.Ş
8718 ANTALYA KEPEZ
''');

    expect(merchant, 'LS SOK MARKETLER TİC.A.Ş');
  });

  test('prefers a company line over an earlier short header word', () {
    final merchant = merchantOf('''
Tar ih
Mağ. No
Belge No
TAHTAKALE SPOT Mağazacilik san . Tic.A.Ş
''');

    expect(merchant, 'TAHTAKALE SPOT Mağazacilik san . Tic.A.Ş');
  });

  test('does not return an address line as the merchant', () {
    final merchant = merchantOf('''
Lafer Mh. 2622 Sk. R.N. Harç Sitesi
GARANTİ BANKASI
''');

    expect(merchant, isNot('Lafer Mh. 2622 Sk. R.N. Harç Sitesi'));
  });

  test('keeps a plain name that carries no corporate word', () {
    final merchant = merchantOf('''
MIGROS
14/10/2026
TOPLAM 120,00
''');

    expect(merchant, 'MIGROS');
  });

  test('returns null when every header line is a label or an address', () {
    final merchant = merchantOf('''
TARIH
SAAT
TOPLAM
''');

    expect(merchant, isNull);
  });
}
