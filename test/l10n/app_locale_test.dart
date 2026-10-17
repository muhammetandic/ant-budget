import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ant_budget/l10n/app_locale.dart';

void main() {
  const supported = [Locale('en'), Locale('tr')];

  group('AppLocale.resolve', () {
    test('renders English for an English device', () {
      expect(
        AppLocale.resolve(const Locale('en', 'US'), supported),
        const Locale('en'),
      );
    });

    test('renders Turkish for a Turkish device', () {
      expect(
        AppLocale.resolve(const Locale('tr', 'TR'), supported),
        const Locale('tr'),
      );
    });

    test('falls back to Turkish for an unsupported language', () {
      expect(AppLocale.resolve(const Locale('de'), supported), AppLocale.turkish);
    });

    test('falls back to Turkish when the device reports no language', () {
      expect(AppLocale.resolve(null, supported), AppLocale.turkish);
    });
  });
}
