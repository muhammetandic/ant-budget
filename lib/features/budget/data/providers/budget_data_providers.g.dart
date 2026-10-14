// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_data_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Dependency wiring of the budget data layer.

@ProviderFor(budgetDao)
final budgetDaoProvider = BudgetDaoProvider._();

/// Dependency wiring of the budget data layer.

final class BudgetDaoProvider
    extends $FunctionalProvider<BudgetDao, BudgetDao, BudgetDao>
    with $Provider<BudgetDao> {
  /// Dependency wiring of the budget data layer.
  BudgetDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'budgetDaoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$budgetDaoHash();

  @$internal
  @override
  $ProviderElement<BudgetDao> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BudgetDao create(Ref ref) {
    return budgetDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BudgetDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BudgetDao>(value),
    );
  }
}

String _$budgetDaoHash() => r'6d271f84e0c1c8337fc10b0be34145e244e5d8d5';

/// The budget repository abstraction injected into the domain use cases.

@ProviderFor(budgetRepository)
final budgetRepositoryProvider = BudgetRepositoryProvider._();

/// The budget repository abstraction injected into the domain use cases.

final class BudgetRepositoryProvider
    extends
        $FunctionalProvider<
          BudgetRepository,
          BudgetRepository,
          BudgetRepository
        >
    with $Provider<BudgetRepository> {
  /// The budget repository abstraction injected into the domain use cases.
  BudgetRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'budgetRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$budgetRepositoryHash();

  @$internal
  @override
  $ProviderElement<BudgetRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BudgetRepository create(Ref ref) {
    return budgetRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BudgetRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BudgetRepository>(value),
    );
  }
}

String _$budgetRepositoryHash() => r'3ba877c24f741f7c4e4a853e15408952c0b2eaf2';
