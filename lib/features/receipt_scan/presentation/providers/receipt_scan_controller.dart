import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_budget_tracker/features/receipt_scan/data/providers/receipt_scan_providers.dart';
import 'package:smart_budget_tracker/features/receipt_scan/domain/entities/scanned_receipt.dart';
import 'package:smart_budget_tracker/features/receipt_scan/domain/values/scan_receipt_request.dart';

part 'receipt_scan_controller.g.dart';

/// Runs OCR + parsing for one captured [imagePath].
///
/// An auto-disposed `AsyncNotifier.family`: the loading/data/error states the
/// review screen needs come for free, and the ML Kit recogniser is only held
/// while the screen is on screen.
///
/// Business logic stays in `ScanReceiptUseCase`; this notifier only adapts a
/// `Result` into an `AsyncValue` (a failure is rethrown so Riverpod surfaces it
/// as `AsyncError`).
@riverpod
class ScanReceiptController extends _$ScanReceiptController {
  @override
  Future<ScannedReceipt> build(String imagePath) async {
    final result = await ref.watch(scanReceiptUseCaseProvider)(
      ScanReceiptRequest(imagePath: imagePath),
    );
    return result.fold(
      (failure) => throw failure,
      (receipt) => receipt,
    );
  }

  /// Re-runs recognition for the same image.
  void retry() => ref.invalidateSelf();
}
