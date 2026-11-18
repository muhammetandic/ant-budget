// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debt_data_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(debtDao)
final debtDaoProvider = DebtDaoProvider._();

final class DebtDaoProvider
    extends $FunctionalProvider<DebtDao, DebtDao, DebtDao>
    with $Provider<DebtDao> {
  DebtDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'debtDaoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$debtDaoHash();

  @$internal
  @override
  $ProviderElement<DebtDao> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DebtDao create(Ref ref) {
    return debtDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DebtDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DebtDao>(value),
    );
  }
}

String _$debtDaoHash() => r'81dbf11c5c687bad07cd2fcff2e1f49aeb65da8f';

@ProviderFor(debtRepository)
final debtRepositoryProvider = DebtRepositoryProvider._();

final class DebtRepositoryProvider
    extends $FunctionalProvider<DebtRepository, DebtRepository, DebtRepository>
    with $Provider<DebtRepository> {
  DebtRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'debtRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$debtRepositoryHash();

  @$internal
  @override
  $ProviderElement<DebtRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DebtRepository create(Ref ref) {
    return debtRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DebtRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DebtRepository>(value),
    );
  }
}

String _$debtRepositoryHash() => r'90d1bb29ce75fc0fbd2e7649c0492421010e3dbe';
