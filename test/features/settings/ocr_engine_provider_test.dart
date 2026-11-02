import 'package:ant_budget/features/settings/data/providers/ocr_engine_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The engine choice is a user preference: it must survive a restart and an
/// unknown stored value must never leave the app without a recogniser.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  group('fromStoredValue', () {
    test('reads a stored engine', () {
      expect(
        OcrEngineNotifier.fromStoredValue('paddleOcr'),
        OcrEngine.paddleOcr,
      );
      expect(OcrEngineNotifier.fromStoredValue('mlKit'), OcrEngine.mlKit);
    });

    test('falls back to ML Kit for a missing or unknown value', () {
      expect(OcrEngineNotifier.fromStoredValue(null), OcrEngine.mlKit);
      expect(OcrEngineNotifier.fromStoredValue('tesseract'), OcrEngine.mlKit);
    });
  });

  test('starts with the engine it was built for', () {
    final container = ProviderContainer(
      overrides: [
        ocrEngineProvider.overrideWith(
          () => OcrEngineNotifier(OcrEngine.paddleOcr),
        ),
      ],
    );
    addTearDown(container.dispose);

    expect(container.read(ocrEngineProvider), OcrEngine.paddleOcr);
  });

  test('select updates the state and stores the choice', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(container.read(ocrEngineProvider), OcrEngine.mlKit);

    await container
        .read(ocrEngineProvider.notifier)
        .select(OcrEngine.paddleOcr);

    expect(container.read(ocrEngineProvider), OcrEngine.paddleOcr);
    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getString(ocrEnginePreferenceKey), 'paddleOcr');
  });
}
