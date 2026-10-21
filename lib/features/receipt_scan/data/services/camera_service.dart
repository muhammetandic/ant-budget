import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ant_budget/core/error/failure.dart';
import 'package:ant_budget/core/error/result.dart';
import 'package:ant_budget/core/values/unit.dart';

/// Port for the embedded receipt camera.
///
/// The abstraction deliberately exposes a [buildPreview] `Widget`, which keeps
/// the `camera` plugin out of the presentation layer: only the data-layer
/// adapter knows which engine takes the photo. Swapping `camera` for
/// `image_picker` or a native channel is therefore a change confined to one
/// file (Open/Closed Principle applied to capture).
abstract interface class CameraService {
  /// Requests permission and opens the back camera. Idempotent and safe to
  /// retry after a failure.
  Future<Result<Unit, Failure>> initialize();

  /// Releases the active camera session while keeping this service reusable.
  Future<void> suspend();

  /// Whether [buildPreview] can currently render a live image.
  bool get isReady;

  /// A live camera preview, ready to be embedded in a screen.
  Widget buildPreview();

  /// Captures a still image, stores it persistently, and returns its path.
  Future<Result<String, Failure>> takePicture();

  /// Releases the camera hardware. Safe to call more than once.
  Future<void> dispose();
}

/// [CameraService] backed by the `camera` plugin and `permission_handler`.
final class DeviceCameraService implements CameraService {
  DeviceCameraService({this.resolution = ResolutionPreset.high});

  /// Requested capture resolution.
  final ResolutionPreset resolution;

  CameraController? _controller;
  bool _isDisposed = false;
  Future<Result<Unit, Failure>>? _initializing;
  int? _initializingSession;
  int _session = 0;

  @override
  bool get isReady => _controller?.value.isInitialized ?? false;

  @override
  Future<Result<Unit, Failure>> initialize() {
    if (_isDisposed) {
      return Future.value(
        const Result.err(
          CameraFailure(
            message: 'The camera service is no longer available.',
            code: CameraFailureCode.unavailable,
          ),
        ),
      );
    }
    if (isReady) return Future.value(const Result.ok(Unit.instance));
    final pending = _initializing;
    if (pending != null) {
      if (_initializingSession == _session) return pending;
      return pending.then((_) => initialize());
    }
    final session = _session;
    final future = Result.attemptAsync(
      () async {
        final permission = await Permission.camera.request();
        if (!permission.isGranted) {
          throw const CameraFailure(
            message: 'Camera access is required to scan a receipt.',
            code: CameraFailureCode.permissionDenied,
          );
        }

        final cameras = await availableCameras();
        if (cameras.isEmpty) {
          throw const CameraFailure(
            message: 'No camera is available on this device.',
            code: CameraFailureCode.unavailable,
          );
        }

        final controller = CameraController(
          _backCameraOf(cameras),
          resolution,
          enableAudio: false,
          imageFormatGroup: ImageFormatGroup.jpeg,
        );
        await controller.initialize();

        // The screen may have been left while the camera was opening.
        if (_isDisposed || session != _session) {
          await controller.dispose();
          throw const CameraFailure(
            message: 'The camera session ended before it was ready.',
            code: CameraFailureCode.unavailable,
          );
        }

        _controller = controller;
        return Unit.instance;
      },
      onError: (error, stackTrace) => error is Failure
          ? error
          : CameraFailure(
              message: 'The camera could not be opened.',
              code: CameraFailureCode.unavailable,
              cause: error,
              stackTrace: stackTrace,
            ),
    );
    _initializing = future;
    _initializingSession = session;
    return future.whenComplete(() {
      if (identical(_initializing, future)) {
        _initializing = null;
        _initializingSession = null;
      }
    });
  }

  @override
  Widget buildPreview() {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return const SizedBox.shrink();
    }
    return CameraPreview(controller);
  }

  @override
  Future<Result<String, Failure>> takePicture() {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return Future.value(
        const Result.err(
          CameraFailure(
            message: 'The camera is not ready yet.',
            code: CameraFailureCode.unavailable,
          ),
        ),
      );
    }
    return Result.attemptAsync(
      () async {
        final captured = await controller.takePicture();
        final documents = await getApplicationDocumentsDirectory();
        final receiptDirectory = Directory(
          '${documents.path}${Platform.pathSeparator}receipt_images',
        );
        await receiptDirectory.create(recursive: true);
        final extension = captured.path.toLowerCase().endsWith('.png')
            ? '.png'
            : '.jpg';
        final destination =
            '${receiptDirectory.path}${Platform.pathSeparator}'
            'receipt_${DateTime.now().microsecondsSinceEpoch}$extension';
        return (await File(captured.path).copy(destination)).path;
      },
      onError: (error, stackTrace) => CameraFailure(
        message: 'The photo could not be captured. Please try again.',
        code: CameraFailureCode.captureFailed,
        cause: error,
        stackTrace: stackTrace,
      ),
    );
  }

  @override
  Future<void> dispose() async {
    _isDisposed = true;
    await suspend();
  }

  @override
  Future<void> suspend() async {
    _session++;
    final controller = _controller;
    _controller = null;
    await controller?.dispose();
  }

  CameraDescription _backCameraOf(List<CameraDescription> cameras) =>
      cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );
}
