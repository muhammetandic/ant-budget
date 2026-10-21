import 'package:ant_budget/features/receipt_scan/domain/parsing/date_parser_strategy.dart';
import 'package:ant_budget/features/receipt_scan/domain/parsing/ocr_parse_input.dart';
import 'package:ant_budget/features/receipt_scan/domain/values/ocr_raw_text.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const strategy = DateParserStrategy();

  DateTime? dateOf(String text) =>
      strategy.parse(OcrParseInput.from(OcrRawText.fromText(text))).valueOrNull;

  test('reads a compact Turkish date', () {
    expect(dateOf('16.10.2026'), DateTime(2026, 10, 16));
  });

  test('reads uppercase Turkish named dates with dotted and dotless letters', () {
    expect(dateOf('15 KASIM 2026'), DateTime(2026, 11, 15));
    expect(dateOf('10 MAYIS 2026'), DateTime(2026, 5, 10));
    expect(dateOf('20 ARALIK 2026'), DateTime(2026, 12, 20));
    expect(dateOf('12 NİSAN 2026'), DateTime(2026, 4, 12));
    expect(dateOf('5 AĞUSTOS 2026'), DateTime(2026, 8, 5));
    expect(dateOf('14 EKİ. 26'), DateTime(2026, 10, 14));
  });

  test('reads English and mixed-case named dates', () {
    expect(dateOf('14 Oct 2026'), DateTime(2026, 10, 14));
    expect(dateOf('14 OCTOBER 2026'), DateTime(2026, 10, 14));
    expect(dateOf('14 Ekim 2026'), DateTime(2026, 10, 14));
  });

  test('reads a date whose dots the recogniser split apart', () {
    expect(dateOf('16.10. 2026'), DateTime(2026, 10, 16));
  });

  test('reads the first date line of a receipt', () {
    expect(
      dateOf('''
KASAP
Tar ih
:
:
16.10. 2026
103
'''),
      DateTime(2026, 10, 16),
    );
  });

  test('does not mistake a spaced number list for a date', () {
    expect(dateOf('1. 2. 3'), isNull);
  });

  test('rejects a day that the calendar does not have', () {
    expect(dateOf('31.02.2026'), isNull);
  });
}
