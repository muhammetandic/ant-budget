import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ant_budget/app/router/app_routes.dart';
import 'package:ant_budget/core/error/failure.dart';
import 'package:ant_budget/core/error/result.dart';
import 'package:ant_budget/core/presentation/failure_message.dart';
import 'package:ant_budget/core/values/unit.dart';
import 'package:ant_budget/core/widgets/failure_view.dart';
import 'package:ant_budget/features/receipt_scan/data/providers/receipt_scan_providers.dart';
import 'package:ant_budget/features/receipt_scan/data/services/camera_service.dart';
import 'package:ant_budget/l10n/l10n.dart';

/// Embedded camera used to photograph a receipt.
///
/// It talks to the [CameraService] abstraction only, so the presentation layer
/// never imports the `camera` plugin; the service owns the controller lifecycle.
class ReceiptCaptureScreen extends ConsumerStatefulWidget {
  const ReceiptCaptureScreen({super.key});

  @override
  ConsumerState<ReceiptCaptureScreen> createState() =>
      _ReceiptCaptureScreenState();
}

class _ReceiptCaptureScreenState extends ConsumerState<ReceiptCaptureScreen>
    with WidgetsBindingObserver {
  CameraService? _camera;
  Future<Result<Unit, Failure>>? _initialisation;
  bool _capturing = false;
  bool _showingReview = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final camera = _camera;
    if (camera == null) return;
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.hidden ||
        state == AppLifecycleState.paused) {
      unawaited(camera.suspend());
    } else if (state == AppLifecycleState.resumed &&
        mounted &&
        !_showingReview) {
      setState(() => _initialisation = camera.initialize());
    }
  }

  Future<void> _capture() async {
    final camera = _camera;
    if (camera == null || _capturing) return;

    setState(() => _capturing = true);
    final result = await camera.takePicture();
    if (!mounted) return;
    setState(() => _capturing = false);

    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(failureMessageOf(context, failure))),
        );
      },
      (path) => unawaited(_openReview(path, camera)),
    );
  }

  Future<void> _openReview(String path, CameraService camera) async {
    _showingReview = true;
    await camera.suspend();
    if (!mounted) return;
    await context.push(AppRoutes.receiptReview, extra: path);
    if (!mounted) return;
    _showingReview = false;
    setState(() => _initialisation = camera.initialize());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _retry() {
    final camera = _camera;
    if (camera != null) {
      setState(() => _initialisation = camera.initialize());
    }
  }

  @override
  Widget build(BuildContext context) {
    final camera = ref.watch(cameraServiceProvider);
    // `watch` above keeps the auto-disposed provider alive for the whole screen;
    // the future is (re)created only when the service instance changes.
    if (!identical(_camera, camera)) {
      _camera = camera;
      _initialisation = camera.initialize();
    }

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.scanTitle)),
      body: FutureBuilder<Result<Unit, Failure>>(
        future: _initialisation,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final result = snapshot.data;
          if (result == null) {
            return FailureView(
              error:
                  snapshot.error ??
                  const CameraFailure(
                    message: 'The camera could not be opened.',
                    code: CameraFailureCode.unavailable,
                  ),
              onRetry: _retry,
            );
          }
          return result.fold(
            (failure) => FailureView(error: failure, onRetry: _retry),
            (_) => _Preview(
              camera: camera,
              capturing: _capturing,
              onCapture: _capture,
            ),
          );
        },
      ),
    );
  }
}

class _Preview extends StatelessWidget {
  const _Preview({
    required this.camera,
    required this.capturing,
    required this.onCapture,
  });

  final CameraService camera;
  final bool capturing;
  final VoidCallback onCapture;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(color: Colors.black, child: camera.buildPreview()),
        Positioned(
          top: 16,
          left: 24,
          right: 24,
          child: Text(
            context.l10n.scanInstruction,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 32,
          child: Center(
            child: FloatingActionButton.large(
              onPressed: capturing ? null : onCapture,
              child: capturing
                  ? const CircularProgressIndicator()
                  : const Icon(Icons.camera_alt),
            ),
          ),
        ),
      ],
    );
  }
}
