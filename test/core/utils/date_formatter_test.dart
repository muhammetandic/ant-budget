import 'package:flutter_test/flutter_test.dart';
import 'package:ant_budget/core/utils/date_formatter.dart';

void main() {
  final date = DateTime(2026, 10, 14);

  group('DateFormatter', () {
    test('renders English by default', () {
      expect(DateFormatter.short(date), '14 Oct 2026');
      expect(DateFormatter.month(date), 'October 2026');
    });

    test('renders Turkish month names for tr', () {
      expect(DateFormatter.short(date, languageCode: 'tr'), '14 Eki 2026');
      expect(DateFormatter.month(date, languageCode: 'tr'), 'Ekim 2026');
    });

    test('falls back to English for an unmodelled language', () {
      expect(DateFormatter.short(date, languageCode: 'de'), '14 Oct 2026');
    });
  });
}
