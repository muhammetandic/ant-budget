import 'package:drift_flutter/drift_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ant_budget/core/config/app_config.dart';
import 'package:ant_budget/core/data/database/app_database.dart';
import 'package:ant_budget/core/data/database/database_seeder.dart';

part 'database_providers.g.dart';

/// Seeders executed once on a freshly created database.
///
/// Defaults to "nothing": the core layer must not know about feature seed data
/// (that would invert the dependency direction). The composition root
/// (`appProviderOverrides`) overrides this with the seeders the app ships with.
@Riverpod(keepAlive: true)
List<DatabaseSeeder> databaseSeeders(Ref ref) => const [];

/// Composition root of the persistence layer.
///
/// The database is opened exactly once and kept alive for the whole app, then
/// closed when the provider container is disposed. Every feature DAO depends on
/// this provider, which is the dependency inversion the domain relies on:
/// nothing above the data layer ever mentions Drift.
@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final database = AppDatabase(
    driftDatabase(name: AppConfig.databaseName),
    seeders: ref.watch(databaseSeedersProvider),
  );
  ref.onDispose(database.close);
  return database;
}
