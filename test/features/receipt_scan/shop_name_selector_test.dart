import 'package:ant_budget/features/receipt_scan/domain/parsing/shop_name_selector.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const selector = ShopNameSelector();

  group('a known chain', () {
    test('collapses to its brand word, dropping the legal tail', () {
      expect(selector.nameFor('LS SOK MARKETLER TÍC.A.S'), 'ŞOK');
    });

    test('restores the spelling the logo OCR mangled', () {
      expect(selector.nameFor('SSUK MARKETLER TỈC.A.\$'), 'ŞOK');
    });

    test('keeps a lone brand as one word', () {
      expect(selector.nameFor('MIGROS'), 'MİGROS');
    });

    test('wins over the words printed around it', () {
      expect(selector.nameFor('ANTALYA SOK MARKET'), 'ŞOK');
    });
  });

  group('any other shop', () {
    test('keeps three name-worthy words, not the legal tail', () {
      expect(
        selector.nameFor('TAHTAKALE SPOT Mağazacilik san . Tic.A.5'),
        'TAHTAKALE SPOT Mağazacilik',
      );
    });

    test('keeps the two words a short name has', () {
      expect(selector.nameFor('KUZEY GIDA'), 'KUZEY GIDA');
    });

    test('skips a bare store number printed in front of the name', () {
      expect(selector.nameFor('8718 ANTALYA KEPEZ'), 'ANTALYA KEPEZ');
    });
  });

  test('firstToken keeps only the leading word, for the merchant key', () {
    expect(
      selector.firstToken('TAHTAKALE SPOT Mağazacilik san . Tic.A.5'),
      'TAHTAKALE',
    );
    expect(selector.firstToken('LS SOK MARKETLER TÍC.A.S'), 'SOK');
    expect(selector.firstToken('8718 ANTALYA KEPEZ'), 'ANTALYA');
  });

  test('returns null when no token can be a name', () {
    expect(selector.nameFor('A.Ş. NO 5'), isNull);
    expect(selector.firstToken('A.Ş. NO 5'), isNull);
  });
}
