import 'package:flutter_test/flutter_test.dart';
import 'package:ant_budget/features/receipt_scan/domain/parsing/merchant_parser_strategy.dart';
import 'package:ant_budget/features/receipt_scan/domain/parsing/ocr_parse_input.dart';
import 'package:ant_budget/features/receipt_scan/domain/values/ocr_raw_text.dart';

void main() {
  const strategy = MerchantParserStrategy();

  String? merchantOf(String text) => strategy
      .parse(OcrParseInput.from(OcrRawText.fromText(text)))
      .getOrElse(() => fail('expected the strategy to succeed'));

  test(
    'skips the header stack and keeps the shop word of the company line',
    () {
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

      expect(merchant, 'ŞOK');
    },
  );

  test('prefers a company line over an earlier short header word', () {
    final merchant = merchantOf('''
Tar ih
Mağ. No
Belge No
TAHTAKALE SPOT Mağazacilik san . Tic.A.Ş
''');

    expect(merchant, 'TAHTAKALE');
  });

  test('does not return an address line as the merchant', () {
    final merchant = merchantOf('''
Lafer Mh. 2622 Sk. R.N. Harç Sitesi
GARANTİ BANKASI
''');

    expect(merchant, isNot('Lafer Mh. 2622 Sk. R.N. Harç Sitesi'));
    expect(merchant, 'GARANTİ');
  });

  test('restores the spelling of a chain whose logo OCR mangled', () {
    final merchant = merchantOf('''
MIGROS
14/10/2026
TOPLAM 120,00
''');

    expect(merchant, 'MİGROS');
  });

  test('keeps a plain name that carries no corporate word', () {
    final merchant = merchantOf('''
KUZEY GIDA
14/10/2026
TOPLAM 120,00
''');

    expect(merchant, 'KUZEY');
  });

  test('reads a line whose \$ is really a misread letter', () {
    final merchant = merchantOf('''
TARIH
SSUK MARKETLER TỈC.A.\$
8718 ANTALYA KEPEZ BİLİM SAAT
''');

    expect(merchant, 'ŞOK');
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
