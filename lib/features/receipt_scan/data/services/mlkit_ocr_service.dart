import 'dart:async';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:smart_budget_tracker/core/error/failure.dart';
import 'package:smart_budget_tracker/core/error/result.dart';
import 'package:smart_budget_tracker/features/receipt_scan/domain/services/ocr_service.dart';
import 'package:smart_budget_tracker/features/receipt_scan/domain/values/ocr_raw_text.dart';

/// [OcrService] backed by Google ML Kit's on-device text recogniser.
///
/// This is the only file in the app that mentions ML Kit. It runs entirely on
/// the device (no image ever leaves the phone) and speaks to the rest of the app
/// exclusively through the [OcrService] port, so the engine can be replaced
/// (Vision, Tesseract, ...) without touching the domain or the UI.
final class MlKitOcrService implements OcrService {
  MlKitOcrService({TextRecognitionScript script = TextRecognitionScript.latin})
    : _recognizer = TextRecognizer(script: script);

  final TextRecognizer _recognizer;
  bool _isDisposed = false;

  @override
  Future<Result<OcrRawText, Failure>> recognizeText(String imagePath) {
    if (_isDisposed) {
      return Future.value(
        const Result.err(
          OcrFailure(
            message: 'The text recogniser is no longer available.',
            code: OcrFailureCode.engineUnavailable,
          ),
        ),
      );
    }

    return Result.attemptAsync(
      () async {
        final recognised = await _recognizer.processImage(
          InputImage.fromFilePath(imagePath),
        );
        if (recognised.text.trim().isEmpty) {
          throw const OcrFailure(
            message: 'No readable text was found on the receipt.',
            code: OcrFailureCode.noTextFound,
          );
        }
        return OcrRawText.fromText(recognised.text);
      },
      onError: (error, stackTrace) => error is Failure
          ? error
          : OcrFailure(
              message: 'The receipt could not be read. Please try again.',
              code: OcrFailureCode.processingFailed,
              cause: error,
              stackTrace: stackTrace,
            ),
    );
  }

  @override
  void dispose() {
    if (_isDisposed) return;
    _isDisposed = true;
    unawaited(_recognizer.close());
  }
}
