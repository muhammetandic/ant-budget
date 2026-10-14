import 'package:flutter_test/flutter_test.dart';
import 'package:ant_budget/core/utils/numeric_parsing.dart';

void main() {
  group('parseAmountToMinorUnits', () {
    test('parses dot decimals', () {
      expect(parseAmountToMinorUnits('1234.56'), 123456);
    });

    test('parses comma decimals', () {
      expect(parseAmountToMinorUnits('45,50'), 4550);
    });

    test('treats dot as grouping and comma as decimal', () {
      expect(parseAmountToMinorUnits('1.234,56'), 123456);
    });

    test('treats comma as grouping and dot as decimal', () {
      expect(parseAmountToMinorUnits('1,234.56'), 123456);
    });

    test('returns null for non numeric text', () {
      expect(parseAmountToMinorUnits('Total'), isNull);
    });
  });
}
