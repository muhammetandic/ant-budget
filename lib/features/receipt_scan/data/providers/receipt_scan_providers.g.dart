// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipt_scan_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Dependency wiring of the receipt scanning data layer.
///
/// Both services own native resources, so they are disposed with the provider
/// container; the abstractions (not the ML Kit/camera classes) are what the
/// domain and the UI receive.

@ProviderFor(ocrService)
final ocrServiceProvider = OcrServiceProvider._();

/// Dependency wiring of the receipt scanning data layer.
///
/// Both services own native resources, so they are disposed with the provider
/// container; the abstractions (not the ML Kit/camera classes) are what the
/// domain and the UI receive.

final class OcrServiceProvider
    extends $FunctionalProvider<OcrService, OcrService, OcrService>
    with $Provider<OcrService> {
  /// Dependency wiring of the receipt scanning data layer.
  ///
  /// Both services own native resources, so they are disposed with the provider
  /// container; the abstractions (not the ML Kit/camera classes) are what the
  /// domain and the UI receive.
  OcrServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ocrServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ocrServiceHash();

  @$internal
  @override
  $ProviderElement<OcrService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  OcrService create(Ref ref) {
    return ocrService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OcrService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OcrService>(value),
    );
  }
}

String _$ocrServiceHash() => r'e8f951fe9ef9460ec5a56cd791494e4594020ab9';

@ProviderFor(cameraService)
final cameraServiceProvider = CameraServiceProvider._();

final class CameraServiceProvider
    extends $FunctionalProvider<CameraService, CameraService, CameraService>
    with $Provider<CameraService> {
  CameraServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cameraServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cameraServiceHash();

  @$internal
  @override
  $ProviderElement<CameraService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CameraService create(Ref ref) {
    return cameraService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CameraService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CameraService>(value),
    );
  }
}

String _$cameraServiceHash() => r'e4b78a76612ad20f33d8e30b3726bef598ec7200';

/// The extraction pipeline: a composition of swappable strategies.
///
/// Naming the strategies in the composition root is the whole point of the
/// Strategy pattern here: replacing the amount heuristic with an ML model means
/// changing this one line.

@ProviderFor(receiptParserPipeline)
final receiptParserPipelineProvider = ReceiptParserPipelineProvider._();

/// The extraction pipeline: a composition of swappable strategies.
///
/// Naming the strategies in the composition root is the whole point of the
/// Strategy pattern here: replacing the amount heuristic with an ML model means
/// changing this one line.

final class ReceiptParserPipelineProvider
    extends
        $FunctionalProvider<
          ReceiptParserPipeline,
          ReceiptParserPipeline,
          ReceiptParserPipeline
        >
    with $Provider<ReceiptParserPipeline> {
  /// The extraction pipeline: a composition of swappable strategies.
  ///
  /// Naming the strategies in the composition root is the whole point of the
  /// Strategy pattern here: replacing the amount heuristic with an ML model means
  /// changing this one line.
  ReceiptParserPipelineProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'receiptParserPipelineProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$receiptParserPipelineHash();

  @$internal
  @override
  $ProviderElement<ReceiptParserPipeline> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ReceiptParserPipeline create(Ref ref) {
    return receiptParserPipeline(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReceiptParserPipeline value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReceiptParserPipeline>(value),
    );
  }
}

String _$receiptParserPipelineHash() =>
    r'd9f0b272adb8c4ab3ba718587a96ecda8c496f05';

/// The OCR use case: recognises text and parses it into a reviewable receipt.

@ProviderFor(scanReceiptUseCase)
final scanReceiptUseCaseProvider = ScanReceiptUseCaseProvider._();

/// The OCR use case: recognises text and parses it into a reviewable receipt.

final class ScanReceiptUseCaseProvider
    extends
        $FunctionalProvider<
          ScanReceiptUseCase,
          ScanReceiptUseCase,
          ScanReceiptUseCase
        >
    with $Provider<ScanReceiptUseCase> {
  /// The OCR use case: recognises text and parses it into a reviewable receipt.
  ScanReceiptUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'scanReceiptUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$scanReceiptUseCaseHash();

  @$internal
  @override
  $ProviderElement<ScanReceiptUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ScanReceiptUseCase create(Ref ref) {
    return scanReceiptUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ScanReceiptUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ScanReceiptUseCase>(value),
    );
  }
}

String _$scanReceiptUseCaseHash() =>
    r'3c6ed6e8cb22fc17ae26f8b4d9b72dd824b52384';

/// The suggestion use case: a category for the merchant the parser found.

@ProviderFor(suggestCategoryUseCase)
final suggestCategoryUseCaseProvider = SuggestCategoryUseCaseProvider._();

/// The suggestion use case: a category for the merchant the parser found.

final class SuggestCategoryUseCaseProvider
    extends
        $FunctionalProvider<
          SuggestCategoryUseCase,
          SuggestCategoryUseCase,
          SuggestCategoryUseCase
        >
    with $Provider<SuggestCategoryUseCase> {
  /// The suggestion use case: a category for the merchant the parser found.
  SuggestCategoryUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'suggestCategoryUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$suggestCategoryUseCaseHash();

  @$internal
  @override
  $ProviderElement<SuggestCategoryUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SuggestCategoryUseCase create(Ref ref) {
    return suggestCategoryUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SuggestCategoryUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SuggestCategoryUseCase>(value),
    );
  }
}

String _$suggestCategoryUseCaseHash() =>
    r'af5341543cd36969537581f17b688c2869eb07f4';
