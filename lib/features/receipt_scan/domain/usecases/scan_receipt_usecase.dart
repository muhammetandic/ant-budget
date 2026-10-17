import 'package:ant_budget/core/error/failure.dart';
import 'package:ant_budget/core/error/result.dart';
import 'package:ant_budget/features/receipt_scan/domain/entities/scanned_receipt.dart';
import 'package:ant_budget/features/receipt_scan/domain/parsing/receipt_parser_pipeline.dart';
import 'package:ant_budget/features/receipt_scan/domain/services/ocr_service.dart';
import 'package:ant_budget/features/receipt_scan/domain/values/scan_receipt_request.dart';

/// Turns an image of a receipt into a reviewable [ScannedReceipt].
///
/// Two independent capabilities are composed here: recognising text (the
/// [OcrService] port, implemented by ML Kit) and understanding it (the parser
/// pipeline). Both are injected, so this use case is unit-testable without a
/// camera, a device or ML Kit.
final class ScanReceiptUseCase {
  const ScanReceiptUseCase(this._ocrService, this._pipeline);

  final OcrService _ocrService;
  final ReceiptParserPipeline _pipeline;

  Future<Result<ScannedReceipt, Failure>> call(
    ScanReceiptRequest request,
  ) async {
    final recognised = await _ocrService.recognizeText(request.imagePath);
    return recognised.flatMap(_pipeline.parse);
  }
}
