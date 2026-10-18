import 'package:flutter_test/flutter_test.dart';
import 'package:ant_budget/features/receipt_scan/domain/parsing/ascii_folding.dart';
import 'package:ant_budget/features/receipt_scan/domain/values/merchant_key.dart';

/// The key is what lets "the shop I filed under Shopping yesterday" be found
/// again today, so it has to survive the spellings a receipt and a user produce.
void main() {
  test('folds the canonical chain spelling to one key', () {
    expect(MerchantKey.of('ŞOK'), 'sok');
    expect(MerchantKey.of('A101'), 'a101');
    expect(MerchantKey.of('MİGROS'), 'migros');
  });

  test('keys the OCR spellings of a chain to the same value', () {
    expect(MerchantKey.of('SOK'), 'sok');
    expect(MerchantKey.of('SSUK'), 'sok');
    expect(MerchantKey.of('BIM'), 'bim');
  });

  test('skips the logo fragment and store number before the name', () {
    expect(MerchantKey.of('LS SOK MARKETLER TÍC.A.Ş'), 'sok');
    expect(MerchantKey.of('8718 SOK'), 'sok');
  });

  test('folds a shop name typed by the user', () {
    expect(MerchantKey.of(' Yıldız Bakkal '), 'yildiz');
    expect(MerchantKey.of('YILDIZ BAKKAL'), 'yildiz');
    expect(MerchantKey.of('Yildiz'), 'yildiz');
  });

  test('has no key without a name-worthy token', () {
    expect(MerchantKey.of(''), isEmpty);
    expect(MerchantKey.of('815 342'), isEmpty);
    expect(MerchantKey.of('NO'), isEmpty);
  });

  test('is stable against the folding used elsewhere', () {
    for (final name in ['ŞOK', 'BİM', 'MİGROS']) {
      expect(MerchantKey.of(name), AsciiFolding.fold(name).toLowerCase());
    }
  });
}
