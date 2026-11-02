import 'package:ant_budget/features/settings/data/providers/ocr_engine_provider.dart';
import 'package:ant_budget/features/settings/presentation/screens/settings_screen.dart';
import 'package:ant_budget/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// What the user sees: both on-device engines are listed, and picking one is
/// reflected in the app state and remembered for the next launch.
void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  /// Boots the screen in Turkish and returns the container it writes to.
  Future<ProviderContainer> pumpSettings(WidgetTester tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          locale: const Locale('tr'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const SettingsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return container;
  }

  testWidgets('lists both engines with their descriptions', (tester) async {
    await pumpSettings(tester);

    expect(find.text('Ayarlar'), findsOneWidget);
    expect(find.text('Fiş tarama'), findsOneWidget);
    expect(find.text('Google ML Kit'), findsOneWidget);
    expect(find.text('PaddleOCR'), findsOneWidget);
    expect(find.text('Google cihaz içi metin tanıma.'), findsOneWidget);
    expect(find.textContaining('29 MB'), findsOneWidget);
  });

  testWidgets('selecting PaddleOCR updates and persists the engine', (
    tester,
  ) async {
    final container = await pumpSettings(tester);
    expect(container.read(ocrEngineProvider), OcrEngine.mlKit);

    await tester.tap(find.text('PaddleOCR'));
    await tester.pumpAndSettle();

    expect(container.read(ocrEngineProvider), OcrEngine.paddleOcr);
    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getString(ocrEnginePreferenceKey), 'paddleOcr');

    // And back again, so neither choice is a one-way door.
    await tester.tap(find.text('Google ML Kit'));
    await tester.pumpAndSettle();

    expect(container.read(ocrEngineProvider), OcrEngine.mlKit);
    expect(preferences.getString(ocrEnginePreferenceKey), 'mlKit');
  });
}
