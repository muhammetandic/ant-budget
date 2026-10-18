// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'suggested_category.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The category to preselect for a receipt whose shop is [merchantName].
///
/// Derived state: the decision itself lives in `SuggestCategoryUseCase`, this
/// provider only feeds it the categories that may be selected and the history
/// them are chosen from. `null` while either is still loading, which is why the
/// review form waits for both before it is built.

@ProviderFor(suggestedCategory)
final suggestedCategoryProvider = SuggestedCategoryFamily._();

/// The category to preselect for a receipt whose shop is [merchantName].
///
/// Derived state: the decision itself lives in `SuggestCategoryUseCase`, this
/// provider only feeds it the categories that may be selected and the history
/// them are chosen from. `null` while either is still loading, which is why the
/// review form waits for both before it is built.

final class SuggestedCategoryProvider
    extends $FunctionalProvider<int?, int?, int?>
    with $Provider<int?> {
  /// The category to preselect for a receipt whose shop is [merchantName].
  ///
  /// Derived state: the decision itself lives in `SuggestCategoryUseCase`, this
  /// provider only feeds it the categories that may be selected and the history
  /// them are chosen from. `null` while either is still loading, which is why the
  /// review form waits for both before it is built.
  SuggestedCategoryProvider._({
    required SuggestedCategoryFamily super.from,
    required String? super.argument,
  }) : super(
         retry: null,
         name: r'suggestedCategoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$suggestedCategoryHash();

  @override
  String toString() {
    return r'suggestedCategoryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<int?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int? create(Ref ref) {
    final argument = this.argument as String?;
    return suggestedCategory(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SuggestedCategoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$suggestedCategoryHash() => r'd867bcd3fdc66146cf177d737e7d1bd158dc3f00';

/// The category to preselect for a receipt whose shop is [merchantName].
///
/// Derived state: the decision itself lives in `SuggestCategoryUseCase`, this
/// provider only feeds it the categories that may be selected and the history
/// them are chosen from. `null` while either is still loading, which is why the
/// review form waits for both before it is built.

final class SuggestedCategoryFamily extends $Family
    with $FunctionalFamilyOverride<int?, String?> {
  SuggestedCategoryFamily._()
    : super(
        retry: null,
        name: r'suggestedCategoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The category to preselect for a receipt whose shop is [merchantName].
  ///
  /// Derived state: the decision itself lives in `SuggestCategoryUseCase`, this
  /// provider only feeds it the categories that may be selected and the history
  /// them are chosen from. `null` while either is still loading, which is why the
  /// review form waits for both before it is built.

  SuggestedCategoryProvider call(String? merchantName) =>
      SuggestedCategoryProvider._(argument: merchantName, from: this);

  @override
  String toString() => r'suggestedCategoryProvider';
}
