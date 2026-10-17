import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ant_budget/core/widgets/failure_view.dart';
import 'package:ant_budget/features/receipt_scan/presentation/providers/receipt_scan_controller.dart';
import 'package:ant_budget/features/receipt_scan/presentation/widgets/receipt_review_form.dart';
import 'package:ant_budget/l10n/l10n.dart';

/// Runs OCR + parsing for the captured image and shows the review form.
///
/// The asynchronous work lives in [scanReceiptControllerProvider]; this screen
/// only maps its `AsyncValue` onto UI.
class ReceiptReviewScreen extends ConsumerWidget {
  const ReceiptReviewScreen({super.key, required this.imagePath});

  /// Path of the photo taken by the capture screen.
  final String imagePath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(scanReceiptControllerProvider(imagePath));

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.scanReviewTitle)),
      body: state.when(
        loading: () => const _ReadingIndicator(),
        error: (error, _) => FailureView(
          error: error,
          onRetry: () =>
              ref.invalidate(scanReceiptControllerProvider(imagePath)),
        ),
        data: (receipt) =>
            ReceiptReviewForm(receipt: receipt, imagePath: imagePath),
      ),
    );
  }
}

class _ReadingIndicator extends StatelessWidget {
  const _ReadingIndicator();

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: 16),
        Text(context.l10n.scanReading),
      ],
    ),
  );
}
