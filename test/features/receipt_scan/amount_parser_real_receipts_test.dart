import 'package:flutter_test/flutter_test.dart';
import 'package:ant_budget/core/values/currency.dart';
import 'package:ant_budget/core/values/money.dart';
import 'package:ant_budget/features/receipt_scan/domain/parsing/amount_parser_strategy.dart';
import 'package:ant_budget/features/receipt_scan/domain/parsing/date_parser_strategy.dart';
import 'package:ant_budget/features/receipt_scan/domain/parsing/merchant_parser_strategy.dart';
import 'package:ant_budget/features/receipt_scan/domain/parsing/receipt_parser_pipeline.dart';
import 'package:ant_budget/features/receipt_scan/domain/values/ocr_raw_text.dart';
import 'turkish_receipt_fixtures.dart';

/// Regression tests built from three real receipts that used to be read wrong.
///
/// Each one pins the payable total that the ML Kit output actually contains, so
/// the traps the recogniser produces — a total label followed by an item count,
/// a street number, a store number, a per-kilo unit price — can never come back.
void main() {
  const pipeline = ReceiptParserPipeline(
    amountParser: AmountParserStrategy(),
    dateParser: DateParserStrategy(),
    merchantParser: MerchantParserStrategy(),
  );

  ScannedReceiptFields parse(String text) {
    final receipt = pipeline
        .parse(OcrRawText.fromText(text))
        .getOrElse(() => fail('expected a receipt to be parsed'));
    return (
      total: receipt.total,
      date: receipt.purchasedAt,
    );
  }

  test('reads the TAHTAKALE invoice total, not the item count after "Toplam"', () {
    final result = parse(tahtakaleReceipt);

    expect(result.total, const Money(35030, Currency.turkishLira));
    expect(result.date, DateTime(2026, 10, 16));
  });

  test('reads the BİM invoice total, not the street number', () {
    final result = parse(bimReceipt);

    expect(result.total, const Money(7550, Currency.turkishLira));
    expect(result.date, DateTime(2026, 10, 12));
  });

  test('reads the ŞOK receipt total, not the store number', () {
    final result = parse(sokReceipt);

    expect(result.total, const Money(29390, Currency.turkishLira));
    expect(result.date, DateTime(2026, 10, 16));
  });
}

typedef ScannedReceiptFields = ({Money total, DateTime date});
