// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipt_scan_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Runs OCR + parsing for one captured [imagePath].
///
/// An auto-disposed `AsyncNotifier.family`: the loading/data/error states the
/// review screen needs come for free, and the ML Kit recogniser is only held
/// while the screen is on screen.
///
/// Business logic stays in `ScanReceiptUseCase`; this notifier only adapts a
/// `Result` into an `AsyncValue` (a failure is rethrown so Riverpod surfaces it
/// as `AsyncError`).

@ProviderFor(ScanReceiptController)
final scanReceiptControllerProvider = ScanReceiptControllerFamily._();

/// Runs OCR + parsing for one captured [imagePath].
///
/// An auto-disposed `AsyncNotifier.family`: the loading/data/error states the
/// review screen needs come for free, and the ML Kit recogniser is only held
/// while the screen is on screen.
///
/// Business logic stays in `ScanReceiptUseCase`; this notifier only adapts a
/// `Result` into an `AsyncValue` (a failure is rethrown so Riverpod surfaces it
/// as `AsyncError`).
final class ScanReceiptControllerProvider
    extends $AsyncNotifierProvider<ScanReceiptController, ScannedReceipt> {
  /// Runs OCR + parsing for one captured [imagePath].
  ///
  /// An auto-disposed `AsyncNotifier.family`: the loading/data/error states the
  /// review screen needs come for free, and the ML Kit recogniser is only held
  /// while the screen is on screen.
  ///
  /// Business logic stays in `ScanReceiptUseCase`; this notifier only adapts a
  /// `Result` into an `AsyncValue` (a failure is rethrown so Riverpod surfaces it
  /// as `AsyncError`).
  ScanReceiptControllerProvider._({
    required ScanReceiptControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'scanReceiptControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$scanReceiptControllerHash();

  @override
  String toString() {
    return r'scanReceiptControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ScanReceiptController create() => ScanReceiptController();

  @override
  bool operator ==(Object other) {
    return other is ScanReceiptControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$scanReceiptControllerHash() =>
    r'99e40e2b69b34f9c2aaa11e2bc6124e72e2c0538';

/// Runs OCR + parsing for one captured [imagePath].
///
/// An auto-disposed `AsyncNotifier.family`: the loading/data/error states the
/// review screen needs come for free, and the ML Kit recogniser is only held
/// while the screen is on screen.
///
/// Business logic stays in `ScanReceiptUseCase`; this notifier only adapts a
/// `Result` into an `AsyncValue` (a failure is rethrown so Riverpod surfaces it
/// as `AsyncError`).

final class ScanReceiptControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          ScanReceiptController,
          AsyncValue<ScannedReceipt>,
          ScannedReceipt,
          FutureOr<ScannedReceipt>,
          String
        > {
  ScanReceiptControllerFamily._()
    : super(
        retry: null,
        name: r'scanReceiptControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Runs OCR + parsing for one captured [imagePath].
  ///
  /// An auto-disposed `AsyncNotifier.family`: the loading/data/error states the
  /// review screen needs come for free, and the ML Kit recogniser is only held
  /// while the screen is on screen.
  ///
  /// Business logic stays in `ScanReceiptUseCase`; this notifier only adapts a
  /// `Result` into an `AsyncValue` (a failure is rethrown so Riverpod surfaces it
  /// as `AsyncError`).

  ScanReceiptControllerProvider call(String imagePath) =>
      ScanReceiptControllerProvider._(argument: imagePath, from: this);

  @override
  String toString() => r'scanReceiptControllerProvider';
}

/// Runs OCR + parsing for one captured [imagePath].
///
/// An auto-disposed `AsyncNotifier.family`: the loading/data/error states the
/// review screen needs come for free, and the ML Kit recogniser is only held
/// while the screen is on screen.
///
/// Business logic stays in `ScanReceiptUseCase`; this notifier only adapts a
/// `Result` into an `AsyncValue` (a failure is rethrown so Riverpod surfaces it
/// as `AsyncError`).

abstract class _$ScanReceiptController extends $AsyncNotifier<ScannedReceipt> {
  late final _$args = ref.$arg as String;
  String get imagePath => _$args;

  FutureOr<ScannedReceipt> build(String imagePath);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<ScannedReceipt>, ScannedReceipt>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ScannedReceipt>, ScannedReceipt>,
              AsyncValue<ScannedReceipt>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
