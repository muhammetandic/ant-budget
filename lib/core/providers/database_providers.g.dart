// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Seeders executed once on a freshly created database.
///
/// Defaults to "nothing": the core layer must not know about feature seed data
/// (that would invert the dependency direction). The composition root
/// (`appProviderOverrides`) overrides this with the seeders the app ships with.

@ProviderFor(databaseSeeders)
final databaseSeedersProvider = DatabaseSeedersProvider._();

/// Seeders executed once on a freshly created database.
///
/// Defaults to "nothing": the core layer must not know about feature seed data
/// (that would invert the dependency direction). The composition root
/// (`appProviderOverrides`) overrides this with the seeders the app ships with.

final class DatabaseSeedersProvider
    extends
        $FunctionalProvider<
          List<DatabaseSeeder>,
          List<DatabaseSeeder>,
          List<DatabaseSeeder>
        >
    with $Provider<List<DatabaseSeeder>> {
  /// Seeders executed once on a freshly created database.
  ///
  /// Defaults to "nothing": the core layer must not know about feature seed data
  /// (that would invert the dependency direction). The composition root
  /// (`appProviderOverrides`) overrides this with the seeders the app ships with.
  DatabaseSeedersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'databaseSeedersProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$databaseSeedersHash();

  @$internal
  @override
  $ProviderElement<List<DatabaseSeeder>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<DatabaseSeeder> create(Ref ref) {
    return databaseSeeders(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<DatabaseSeeder> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<DatabaseSeeder>>(value),
    );
  }
}

String _$databaseSeedersHash() => r'95bc7b887d9b9d6cce1c80ea79ddd68ad3ae9855';

/// Composition root of the persistence layer.
///
/// The database is opened exactly once and kept alive for the whole app, then
/// closed when the provider container is disposed. Every feature DAO depends on
/// this provider, which is the dependency inversion the domain relies on:
/// nothing above the data layer ever mentions Drift.

@ProviderFor(appDatabase)
final appDatabaseProvider = AppDatabaseProvider._();

/// Composition root of the persistence layer.
///
/// The database is opened exactly once and kept alive for the whole app, then
/// closed when the provider container is disposed. Every feature DAO depends on
/// this provider, which is the dependency inversion the domain relies on:
/// nothing above the data layer ever mentions Drift.

final class AppDatabaseProvider
    extends $FunctionalProvider<AppDatabase, AppDatabase, AppDatabase>
    with $Provider<AppDatabase> {
  /// Composition root of the persistence layer.
  ///
  /// The database is opened exactly once and kept alive for the whole app, then
  /// closed when the provider container is disposed. Every feature DAO depends on
  /// this provider, which is the dependency inversion the domain relies on:
  /// nothing above the data layer ever mentions Drift.
  AppDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appDatabaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appDatabaseHash();

  @$internal
  @override
  $ProviderElement<AppDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppDatabase create(Ref ref) {
    return appDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppDatabase>(value),
    );
  }
}

String _$appDatabaseHash() => r'fa7d923ea2e96c7a9d8d33d091d0ee65d030227e';
