import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_budget_tracker/features/receipt_scan/data/services/camera_service.dart';
import 'package:smart_budget_tracker/features/receipt_scan/data/services/mlkit_ocr_service.dart';
import 'package:smart_budget_tracker/features/receipt_scan/domain/parsing/amount_parser_strategy.dart';
import 'package:smart_budget_tracker/features/receipt_scan/domain/parsing/date_parser_strategy.dart';
import 'package:smart_budget_tracker/features/receipt_scan/domain/parsing/merchant_parser_strategy.dart';
import 'package:smart_budget_tracker/features/receipt_scan/domain/parsing/receipt_parser_pipeline.dart';
import 'package:smart_budget_tracker/features/receipt_scan/domain/services/ocr_service.dart';
import 'package:smart_budget_tracker/features/receipt_scan/domain/usecases/scan_receipt_usecase.dart';

part 'receipt_scan_providers.g.dart';

/// Dependency wiring of the receipt scanning data layer.
///
/// Both services own native resources, so they are disposed with the provider
/// container; the abstractions (not the ML Kit/camera classes) are what the
/// domain and the UI receive.
@riverpod
OcrService ocrService(Ref ref) {
  final service = MlKitOcrService();
  ref.onDispose(service.dispose);
  return service;
}

@riverpod
CameraService cameraService(Ref ref) {
  final service = DeviceCameraService();
  ref.onDispose(service.dispose);
  return service;
}

/// The extraction pipeline: a composition of swappable strategies.
///
/// Naming the strategies in the composition root is the whole point of the
/// Strategy pattern here: replacing the amount heuristic with an ML model means
/// changing this one line.
@riverpod
ReceiptParserPipeline receiptParserPipeline(Ref ref) => ReceiptParserPipeline(
  amountParser: const AmountParserStrategy(),
  dateParser: const DateParserStrategy(),
  merchantParser: const MerchantParserStrategy(),
);

/// The OCR use case: recognises text and parses it into a reviewable receipt.
@riverpod
ScanReceiptUseCase scanReceiptUseCase(Ref ref) => ScanReceiptUseCase(
  ref.watch(ocrServiceProvider),
  ref.watch(receiptParserPipelineProvider),
);
