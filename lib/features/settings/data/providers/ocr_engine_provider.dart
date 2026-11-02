import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum OcrEngine { mlKit, paddleOcr }

/// Key under which the chosen engine is stored across launches.
const ocrEnginePreferenceKey = 'receipt_ocr_engine';

final ocrEngineProvider = NotifierProvider<OcrEngineNotifier, OcrEngine>(
  OcrEngineNotifier.new,
);

class OcrEngineNotifier extends Notifier<OcrEngine> {
  OcrEngineNotifier([this.initialEngine = OcrEngine.mlKit]);

  final OcrEngine initialEngine;

  @override
  OcrEngine build() => initialEngine;

  Future<void> select(OcrEngine engine) async {
    state = engine;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(ocrEnginePreferenceKey, engine.name);
  }

  static OcrEngine fromStoredValue(String? value) =>
      OcrEngine.values.firstWhere(
        (engine) => engine.name == value,
        orElse: () => OcrEngine.mlKit,
      );
}
