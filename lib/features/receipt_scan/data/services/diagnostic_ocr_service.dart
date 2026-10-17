import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ant_budget/core/error/failure.dart';
import 'package:ant_budget/core/error/result.dart';
import 'package:ant_budget/features/receipt_scan/domain/services/ocr_service.dart';
import 'package:ant_budget/features/receipt_scan/domain/values/ocr_raw_text.dart';

/// Opt-in [OcrService] decorator that preserves the evidence of every scan.
///
/// Enabled only for builds made with
/// `--dart-define=ANT_SCAN_DIAGNOSTICS=true`, so a normal release never wraps
/// the recogniser and pays nothing. It copies the captured photo and writes
/// ML Kit's raw output into a `diag/` folder inside the app-specific external
/// storage — the evidence needed to tell *bad recognition* apart from *bad
/// parsing* when a receipt comes out wrong.
///
/// Pull it off the device with:
/// `adb pull /sdcard/Android/data/<applicationId>/files/diag`.
final class DiagnosticOcrService implements OcrService {
  DiagnosticOcrService(this._inner);

  /// Whether this build asked for scan diagnostics.
  static const bool enabled = bool.fromEnvironment('ANT_SCAN_DIAGNOSTICS');

  final OcrService _inner;

  @override
  Future<Result<OcrRawText, Failure>> recognizeText(String imagePath) async {
    final result = await _inner.recognizeText(imagePath);
    try {
      await _record(imagePath, result);
    } catch (error) {
      // Diagnostics must never turn a working scan into a failure.
      debugPrint('[scan-diag] could not save evidence: $error');
    }
    return result;
  }

  @override
  void dispose() => _inner.dispose();

  Future<void> _record(
    String imagePath,
    Result<OcrRawText, Failure> result,
  ) async {
    final base = await getExternalStorageDirectory();
    if (base == null) return;

    final directory = Directory('${base.path}/diag');
    await directory.create(recursive: true);
    final stamp = DateTime.now().toIso8601String().replaceAll(
      RegExp(r'[:.]'),
      '-',
    );

    final photo = File(imagePath);
    if (await photo.exists()) {
      await photo.copy('${directory.path}/scan_$stamp.jpg');
    }

    final text = result.fold(
      (failure) => 'RECOGNITION FAILED: ${failure.message}',
      (rawText) => rawText.fullText,
    );
    final evidence = File('${directory.path}/scan_$stamp.txt');
    await evidence.writeAsString(
      'image: $imagePath\n'
      '\n--- ML Kit raw text ---\n'
      '$text\n',
    );
    debugPrint('[scan-diag] evidence saved: ${evidence.path}');
  }
}
