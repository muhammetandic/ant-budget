import 'package:flutter/material.dart';
import 'package:ant_budget/core/presentation/failure_message.dart';

/// Full-screen presentation of a [Failure] with an optional retry action.
///
/// Every screen routes its `AsyncError` branch through this widget, so error
/// handling looks and behaves the same everywhere.
class FailureView extends StatelessWidget {
  const FailureView({super.key, required this.error, this.onRetry});

  /// The error to render; usually a `Failure`.
  final Object error;

  /// Invoked when the user asks to try again.
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 40, color: scheme.error),
            const SizedBox(height: 12),
            Text(
              failureMessageOf(error),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Try again'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
