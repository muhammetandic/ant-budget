// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Use case provider: the presentation asks for *behaviour*, never for the
/// repository directly.

@ProviderFor(watchCategoriesUseCase)
final watchCategoriesUseCaseProvider = WatchCategoriesUseCaseProvider._();

/// Use case provider: the presentation asks for *behaviour*, never for the
/// repository directly.

final class WatchCategoriesUseCaseProvider
    extends
        $FunctionalProvider<
          WatchCategoriesUseCase,
          WatchCategoriesUseCase,
          WatchCategoriesUseCase
        >
    with $Provider<WatchCategoriesUseCase> {
  /// Use case provider: the presentation asks for *behaviour*, never for the
  /// repository directly.
  WatchCategoriesUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'watchCategoriesUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$watchCategoriesUseCaseHash();

  @$internal
  @override
  $ProviderElement<WatchCategoriesUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WatchCategoriesUseCase create(Ref ref) {
    return watchCategoriesUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WatchCategoriesUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WatchCategoriesUseCase>(value),
    );
  }
}

String _$watchCategoriesUseCaseHash() =>
    r'7c9eb17397205192710a3b230480b5b450fd2a1f';

/// All categories, reactively.
///
/// Auto-disposing: the stream is only subscribed while a screen listens to it,
/// so leaving every category-consuming screen releases the query.

@ProviderFor(categories)
final categoriesProvider = CategoriesProvider._();

/// All categories, reactively.
///
/// Auto-disposing: the stream is only subscribed while a screen listens to it,
/// so leaving every category-consuming screen releases the query.

final class CategoriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Category>>,
          List<Category>,
          Stream<List<Category>>
        >
    with $FutureModifier<List<Category>>, $StreamProvider<List<Category>> {
  /// All categories, reactively.
  ///
  /// Auto-disposing: the stream is only subscribed while a screen listens to it,
  /// so leaving every category-consuming screen releases the query.
  CategoriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoriesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoriesHash();

  @$internal
  @override
  $StreamProviderElement<List<Category>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Category>> create(Ref ref) {
    return categories(ref);
  }
}

String _$categoriesHash() => r'719c34b473569c028439663394a044889fe3f961';

/// Categories indexed by id for O(1) lookups while building lists.
///
/// Derived state: it recomputes whenever [categoriesProvider] emits, so screens
/// only render and never join collections themselves.

@ProviderFor(categoryIndex)
final categoryIndexProvider = CategoryIndexProvider._();

/// Categories indexed by id for O(1) lookups while building lists.
///
/// Derived state: it recomputes whenever [categoriesProvider] emits, so screens
/// only render and never join collections themselves.

final class CategoryIndexProvider
    extends
        $FunctionalProvider<
          Map<int, Category>,
          Map<int, Category>,
          Map<int, Category>
        >
    with $Provider<Map<int, Category>> {
  /// Categories indexed by id for O(1) lookups while building lists.
  ///
  /// Derived state: it recomputes whenever [categoriesProvider] emits, so screens
  /// only render and never join collections themselves.
  CategoryIndexProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoryIndexProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoryIndexHash();

  @$internal
  @override
  $ProviderElement<Map<int, Category>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Map<int, Category> create(Ref ref) {
    return categoryIndex(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<int, Category> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<int, Category>>(value),
    );
  }
}

String _$categoryIndexHash() => r'c04d187d8c15fe795b8d253c4a65726a4a5349ec';
