import 'package:ant_budget/core/error/failure.dart';
import 'package:ant_budget/core/error/result.dart';
import 'package:ant_budget/features/receipt_scan/domain/values/ocr_raw_text.dart';

/// Port for on-device text recognition.
///
/// The domain depends on this abstraction only; the ML Kit implementation lives
/// in the data layer. Swapping the engine (Vision, Tesseract, ...) is therefore
/// a data-layer change, which is the Open/Closed Principle applied to OCR.
abstract interface class OcrService {
  /// Recognises the text of the image at [imagePath].
  ///
  /// Returns an [OcrFailure] (never throws) when recognition is impossible.
  Future<Result<OcrRawText, Failure>> recognizeText(String imagePath);

  /// Releases the underlying native resources.
  void dispose();
}
