import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ant_budget/features/receipt_scan/data/providers/receipt_scan_providers.dart';
import 'package:ant_budget/features/receipt_scan/domain/values/scan_receipt_request.dart';

/// Diagnostics-only: replays the scan pipeline over images staged on device.
///
/// Enabled with `--dart-define=ANT_SCAN_DIAGNOSTICS=true`. Copy images into the
/// `receiptscan/` folder of the app's external storage, launch the app, and
/// each image is recognised and parsed through the *production* wiring; the
/// result is printed to logcat and the raw evidence is written next to it by
/// [DiagnosticOcrService]. This lets a bad scan be reproduced from a photo
/// without the camera, which is how the parser gets tuned against real
/// receipts.
final class ScanReplayRunner {
  const ScanReplayRunner(this._container);

  final ProviderContainer _container;

  /// Whether this build asked for scan diagnostics.
  static const bool enabled = bool.fromEnvironment('ANT_SCAN_DIAGNOSTICS');

  Future<void> runIfRequested() async {
    if (!enabled) return;
    final base = await getExternalStorageDirectory();
    if (base == null) return;
    final inbox = Directory('${base.path}/receiptscan');
    if (!await inbox.exists()) return;

    final images = await inbox
        .list()
        .where((entity) => entity is File && _isImage(entity.path))
        .cast<File>()
        .toList();
    if (images.isEmpty) return;

    // Keep the provider graph alive for the whole replay.
    final subscription = _container.listen(
      scanReceiptUseCaseProvider,
      (previous, next) {},
    );
    final useCase = _container.read(scanReceiptUseCaseProvider);

    for (final image in images) {
      final result = await useCase(ScanReceiptRequest(imagePath: image.path));
      final report = result.fold(
        (failure) => 'FAILURE: ${failure.message}',
        (receipt) =>
            'total=${receipt.total.minorUnits} ${receipt.total.currency.code} '
            'merchant="${receipt.merchantName}" '
            'date=${receipt.purchasedAt.toIso8601String().split('T').first} '
            'lines=${receipt.rawText?.lines.length ?? 0}',
      );
      debugPrint('[scan-replay] ${image.path.split('/').last} -> $report');
    }
    subscription.close();
  }

  bool _isImage(String path) {
    final lower = path.toLowerCase();
    return lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.png');
  }
}
