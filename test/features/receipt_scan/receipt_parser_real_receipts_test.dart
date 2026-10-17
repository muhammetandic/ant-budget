import 'package:flutter_test/flutter_test.dart';
import 'package:ant_budget/core/values/currency.dart';
import 'package:ant_budget/core/values/money.dart';
import 'package:ant_budget/features/receipt_scan/domain/entities/scanned_receipt.dart';
import 'package:ant_budget/features/receipt_scan/domain/parsing/amount_parser_strategy.dart';
import 'package:ant_budget/features/receipt_scan/domain/parsing/date_parser_strategy.dart';
import 'package:ant_budget/features/receipt_scan/domain/parsing/merchant_parser_strategy.dart';
import 'package:ant_budget/features/receipt_scan/domain/parsing/receipt_parser_pipeline.dart';
import 'package:ant_budget/features/receipt_scan/domain/values/ocr_raw_text.dart';
import 'turkish_receipt_fixtures.dart';

/// Regression tests built from three real receipts that used to be read wrong.
///
/// Each one pins the fields the ML Kit output actually contains, so the traps
/// the recogniser produces — a total label followed by an item count, a street
/// number, a store number, a per-kilo unit price, a header stack before the shop
/// name — can never come back.
void main() {
  const pipeline = ReceiptParserPipeline(
    amountParser: AmountParserStrategy(),
    dateParser: DateParserStrategy(),
    merchantParser: MerchantParserStrategy(),
  );

  ScannedReceipt parse(String text) => pipeline
      .parse(OcrRawText.fromText(text))
      .getOrElse(() => fail('expected a receipt to be parsed'));

  test('reads the TAHTAKALE invoice total, not the item count after "Toplam"', () {
    final receipt = parse(tahtakaleReceipt);

    expect(receipt.total, const Money(35030, Currency.turkishLira));
    expect(receipt.purchasedAt, DateTime(2026, 10, 16));
    expect(receipt.merchantName, 'TAHTAKALE SPOT Mağazacilik san . Tic.A.5');
  });

  test('reads the BİM invoice total, not the street number', () {
    final receipt = parse(bimReceipt);

    expect(receipt.total, const Money(7550, Currency.turkishLira));
    expect(receipt.purchasedAt, DateTime(2026, 10, 12));
    expect(receipt.merchantName, 'BIM BIRLESIK MAGAZALAR A.5.');
  });

  test('reads the ŞOK receipt total, not the store number', () {
    final receipt = parse(sokReceipt);

    expect(receipt.total, const Money(29390, Currency.turkishLira));
    expect(receipt.purchasedAt, DateTime(2026, 10, 16));
    expect(receipt.merchantName, 'LS SOK MARKETLER TÍC.A.S');
  });
}
