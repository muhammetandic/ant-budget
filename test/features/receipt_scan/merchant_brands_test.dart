import 'package:ant_budget/features/receipt_scan/domain/parsing/ascii_folding.dart';
import 'package:ant_budget/features/receipt_scan/domain/parsing/merchant_brands.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MerchantBrands', () {
    test('restores every OCR spelling of ŞOK', () {
      expect(MerchantBrands.correct('SOK'), 'ŞOK');
      expect(MerchantBrands.correct('ŞOK'), 'ŞOK');
      expect(MerchantBrands.correct('SSUK'), 'ŞOK');
      expect(MerchantBrands.correct('SSOK'), 'ŞOK');
    });

    test('restores BİM whichever dot survived', () {
      expect(MerchantBrands.correct('BIM'), 'BİM');
      expect(MerchantBrands.correct('BİM'), 'BİM');
    });

    test('restores A101 when the terminal swaps letters and digits', () {
      expect(MerchantBrands.correct('A101'), 'A101');
      expect(MerchantBrands.correct('A1O1'), 'A101');
      expect(MerchantBrands.correct('AIO1'), 'A101');
    });

    test('leaves a shop outside the catalogue untouched', () {
      expect(MerchantBrands.correct('TAHTAKALE'), 'TAHTAKALE');
      expect(MerchantBrands.correct('KUZEY'), 'KUZEY');
    });
  });

  group('AsciiFolding', () {
    test('folds the dotted Turkish capital that lowercasing splits apart', () {
      expect(AsciiFolding.fold('BİM'), 'bim');
      expect(AsciiFolding.fold('TİC'), 'tic');
    });

    test('folds accented OCR output', () {
      expect(AsciiFolding.fold('TÍC'), 'tic');
      expect(AsciiFolding.fold('Mağazacilik'), 'magazacilik');
    });
  });
}
