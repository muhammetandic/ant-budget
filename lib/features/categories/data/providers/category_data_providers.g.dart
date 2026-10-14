// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_data_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Dependency wiring of the categories data layer.

@ProviderFor(categoryDao)
final categoryDaoProvider = CategoryDaoProvider._();

/// Dependency wiring of the categories data layer.

final class CategoryDaoProvider
    extends $FunctionalProvider<CategoryDao, CategoryDao, CategoryDao>
    with $Provider<CategoryDao> {
  /// Dependency wiring of the categories data layer.
  CategoryDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoryDaoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoryDaoHash();

  @$internal
  @override
  $ProviderElement<CategoryDao> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CategoryDao create(Ref ref) {
    return categoryDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CategoryDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CategoryDao>(value),
    );
  }
}

String _$categoryDaoHash() => r'95fc41600613b8ff1335794effd4b71fca511838';

/// The category repository abstraction injected into the domain use cases.

@ProviderFor(categoryRepository)
final categoryRepositoryProvider = CategoryRepositoryProvider._();

/// The category repository abstraction injected into the domain use cases.

final class CategoryRepositoryProvider
    extends
        $FunctionalProvider<
          CategoryRepository,
          CategoryRepository,
          CategoryRepository
        >
    with $Provider<CategoryRepository> {
  /// The category repository abstraction injected into the domain use cases.
  CategoryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoryRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoryRepositoryHash();

  @$internal
  @override
  $ProviderElement<CategoryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CategoryRepository create(Ref ref) {
    return categoryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CategoryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CategoryRepository>(value),
    );
  }
}

String _$categoryRepositoryHash() =>
    r'2d1397deb67b8d69f6179f251f82721b6d43094d';
