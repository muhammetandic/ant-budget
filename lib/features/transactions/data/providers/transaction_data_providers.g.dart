// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_data_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Dependency wiring of the transactions *data* layer.
///
/// Both providers are auto-disposing and stateless: the DAO only holds the
/// shared `AppDatabase`, the repository only holds the DAO, so re-creating them
/// is free. State lives in the database, not in these objects.

@ProviderFor(transactionDao)
final transactionDaoProvider = TransactionDaoProvider._();

/// Dependency wiring of the transactions *data* layer.
///
/// Both providers are auto-disposing and stateless: the DAO only holds the
/// shared `AppDatabase`, the repository only holds the DAO, so re-creating them
/// is free. State lives in the database, not in these objects.

final class TransactionDaoProvider
    extends $FunctionalProvider<TransactionDao, TransactionDao, TransactionDao>
    with $Provider<TransactionDao> {
  /// Dependency wiring of the transactions *data* layer.
  ///
  /// Both providers are auto-disposing and stateless: the DAO only holds the
  /// shared `AppDatabase`, the repository only holds the DAO, so re-creating them
  /// is free. State lives in the database, not in these objects.
  TransactionDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transactionDaoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transactionDaoHash();

  @$internal
  @override
  $ProviderElement<TransactionDao> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TransactionDao create(Ref ref) {
    return transactionDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TransactionDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TransactionDao>(value),
    );
  }
}

String _$transactionDaoHash() => r'6dd75d3118f0e2e23be1b05fe5ebcee148e69f7f';

/// The repository the domain depends on: an abstraction, never the Drift DAO.

@ProviderFor(transactionRepository)
final transactionRepositoryProvider = TransactionRepositoryProvider._();

/// The repository the domain depends on: an abstraction, never the Drift DAO.

final class TransactionRepositoryProvider
    extends
        $FunctionalProvider<
          TransactionRepository,
          TransactionRepository,
          TransactionRepository
        >
    with $Provider<TransactionRepository> {
  /// The repository the domain depends on: an abstraction, never the Drift DAO.
  TransactionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transactionRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transactionRepositoryHash();

  @$internal
  @override
  $ProviderElement<TransactionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TransactionRepository create(Ref ref) {
    return transactionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TransactionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TransactionRepository>(value),
    );
  }
}

String _$transactionRepositoryHash() =>
    r'2732b86252a99dd4d74209ed7cdadd8c8ae7c87b';
