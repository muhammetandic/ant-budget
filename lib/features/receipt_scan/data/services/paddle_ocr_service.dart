import 'dart:async';

import 'package:ant_budget/core/error/failure.dart';
import 'package:ant_budget/core/error/result.dart';
import 'package:ant_budget/features/receipt_scan/domain/services/ocr_service.dart';
import 'package:ant_budget/features/receipt_scan/domain/values/ocr_raw_text.dart';
import 'package:paddle_ocr_native/paddle_ocr_native.dart';

/// [OcrService] backed by PaddleOCR's on-device PP-OCRv6 models.
final class PaddleOcrService implements OcrService {
  PaddleOcrService() : _ready = _engine.init();

  static final PaddleOcr _engine = PaddleOcr();
  final Future<void> _ready;
  bool _isDisposed = false;

  @override
  Future<Result<OcrRawText, Failure>> recognizeText(String imagePath) async {
    if (_isDisposed) {
      return const Result.err(
        OcrFailure(
          message: 'The text recogniser is no longer available.',
          code: OcrFailureCode.engineUnavailable,
        ),
      );
    }

    return Result.attemptAsync(
      () async {
        await _ready;
        final run = await _engine.recognize(imagePath);
        final text = run.results.map((region) => region.text).join('\n');
        if (text.trim().isEmpty) {
          throw const OcrFailure(
            message: 'No readable text was found on the receipt.',
            code: OcrFailureCode.noTextFound,
          );
        }
        return OcrRawText.fromText(text);
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
    unawaited(
      _ready.then(
        (_) => _engine.dispose(),
        onError: (Object _, StackTrace _) {},
      ),
    );
  }
}
