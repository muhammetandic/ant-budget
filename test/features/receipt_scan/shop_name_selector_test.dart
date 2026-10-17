import 'package:ant_budget/features/receipt_scan/domain/parsing/shop_name_selector.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const selector = ShopNameSelector();

  test('keeps the trade name and drops the legal tail', () {
    expect(
      selector.firstToken('TAHTAKALE SPOT Mağazacilik san . Tic.A.5'),
      'TAHTAKALE',
    );
  });

  test('skips the stray logo fragment before the shop word', () {
    expect(selector.firstToken('LS SOK MARKETLER TÍC.A.S'), 'SOK');
  });

  test('skips a bare store number printed in front of the name', () {
    expect(selector.firstToken('8718 ANTALYA KEPEZ'), 'ANTALYA');
  });

  test('returns the only word of a plain name', () {
    expect(selector.firstToken('MIGROS'), 'MIGROS');
  });

  test('returns null when no token can be a name', () {
    expect(selector.firstToken('A.Ş. NO 5'), isNull);
  });
}
