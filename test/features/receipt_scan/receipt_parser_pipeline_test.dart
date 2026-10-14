import 'package:flutter_test/flutter_test.dart';
import 'package:smart_budget_tracker/core/values/currency.dart';
import 'package:smart_budget_tracker/features/receipt_scan/domain/parsing/amount_parser_strategy.dart';
import 'package:smart_budget_tracker/features/receipt_scan/domain/parsing/date_parser_strategy.dart';
import 'package:smart_budget_tracker/features/receipt_scan/domain/parsing/merchant_parser_strategy.dart';
import 'package:smart_budget_tracker/features/receipt_scan/domain/parsing/receipt_parser_pipeline.dart';
import 'package:smart_budget_tracker/features/receipt_scan/domain/values/ocr_raw_text.dart';

ReceiptParserPipeline buildPipeline() => ReceiptParserPipeline(
  amountParser: const AmountParserStrategy(),
  dateParser: const DateParserStrategy(),
  merchantParser: const MerchantParserStrategy(),
);

void main() {
  group('ReceiptParserPipeline', () {
    test('extracts the grand total, ignoring subtotal and tax', () {
      final text = OcrRawText.fromText('''
MIGROS
14/10/2026
Subtotal 100,00
KDV 20,00
TOTAL 120,00
''');

      final receipt = buildPipeline().parse(text).valueOrNull;

      expect(receipt, isNotNull);
      expect(receipt!.total.minorUnits, 12000);
      expect(receipt.total.currency, Currency.turkishLira);
      expect(receipt.merchantName, 'MIGROS');
      expect(receipt.purchasedAt, DateTime(2026, 10, 14));
    });

    test('fails when the OCR text is empty', () {
      final result = buildPipeline().parse(
        const OcrRawText(fullText: '', lines: []),
      );
      expect(result.isErr, isTrue);
    });

    test('falls back to the current date when none is readable', () {
      final receipt = buildPipeline()
          .parse(OcrRawText.fromText('TOTAL 15,00'))
          .valueOrNull;

      expect(receipt, isNotNull);
      expect(receipt!.purchasedAt.year, DateTime.now().year);
    });
  });
}
