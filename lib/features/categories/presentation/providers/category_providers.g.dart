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

/// Number of transactions filed under each category, keyed by category id.
///
/// The management screen renders this so the user can see *why* a category
/// cannot be deleted before they try.

@ProviderFor(categoryUsage)
final categoryUsageProvider = CategoryUsageProvider._();

/// Number of transactions filed under each category, keyed by category id.
///
/// The management screen renders this so the user can see *why* a category
/// cannot be deleted before they try.

final class CategoryUsageProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<int, int>>,
          Map<int, int>,
          Stream<Map<int, int>>
        >
    with $FutureModifier<Map<int, int>>, $StreamProvider<Map<int, int>> {
  /// Number of transactions filed under each category, keyed by category id.
  ///
  /// The management screen renders this so the user can see *why* a category
  /// cannot be deleted before they try.
  CategoryUsageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoryUsageProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoryUsageHash();

  @$internal
  @override
  $StreamProviderElement<Map<int, int>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<Map<int, int>> create(Ref ref) {
    return categoryUsage(ref);
  }
}

String _$categoryUsageHash() => r'5af7ae6160d86b14de3d53df01f19b443e6fbdfb';

@ProviderFor(watchCategoryUsageUseCase)
final watchCategoryUsageUseCaseProvider = WatchCategoryUsageUseCaseProvider._();

final class WatchCategoryUsageUseCaseProvider
    extends
        $FunctionalProvider<
          WatchCategoryUsageUseCase,
          WatchCategoryUsageUseCase,
          WatchCategoryUsageUseCase
        >
    with $Provider<WatchCategoryUsageUseCase> {
  WatchCategoryUsageUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'watchCategoryUsageUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$watchCategoryUsageUseCaseHash();

  @$internal
  @override
  $ProviderElement<WatchCategoryUsageUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WatchCategoryUsageUseCase create(Ref ref) {
    return watchCategoryUsageUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WatchCategoryUsageUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WatchCategoryUsageUseCase>(value),
    );
  }
}

String _$watchCategoryUsageUseCaseHash() =>
    r'36844283cc018098e551100f6c6b0d8dcb978ca3';

@ProviderFor(saveCategoryUseCase)
final saveCategoryUseCaseProvider = SaveCategoryUseCaseProvider._();

final class SaveCategoryUseCaseProvider
    extends
        $FunctionalProvider<
          SaveCategoryUseCase,
          SaveCategoryUseCase,
          SaveCategoryUseCase
        >
    with $Provider<SaveCategoryUseCase> {
  SaveCategoryUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'saveCategoryUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$saveCategoryUseCaseHash();

  @$internal
  @override
  $ProviderElement<SaveCategoryUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SaveCategoryUseCase create(Ref ref) {
    return saveCategoryUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SaveCategoryUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SaveCategoryUseCase>(value),
    );
  }
}

String _$saveCategoryUseCaseHash() =>
    r'c9df54f4aa3bfc8cf852a4007a254d499e0b60b9';

@ProviderFor(deleteCategoryUseCase)
final deleteCategoryUseCaseProvider = DeleteCategoryUseCaseProvider._();

final class DeleteCategoryUseCaseProvider
    extends
        $FunctionalProvider<
          DeleteCategoryUseCase,
          DeleteCategoryUseCase,
          DeleteCategoryUseCase
        >
    with $Provider<DeleteCategoryUseCase> {
  DeleteCategoryUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deleteCategoryUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deleteCategoryUseCaseHash();

  @$internal
  @override
  $ProviderElement<DeleteCategoryUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DeleteCategoryUseCase create(Ref ref) {
    return deleteCategoryUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeleteCategoryUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeleteCategoryUseCase>(value),
    );
  }
}

String _$deleteCategoryUseCaseHash() =>
    r'35134c5968610d737615af311aef0bb6b72cefb8';
