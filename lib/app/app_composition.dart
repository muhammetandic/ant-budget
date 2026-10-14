import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ant_budget/core/providers/database_providers.dart';
import 'package:ant_budget/features/categories/data/datasources/default_category_seeder.dart';

/// Composition root of the application graph.
///
/// This is the one place allowed to import *both* core and feature code: it
/// turns the framework-agnostic core providers into the concrete app graph by
/// plugging feature implementations into core seams.
///
/// `main.dart` boots with [appProviderOverrides]; tests replace the database
/// (`appDatabaseProvider.overrideWithValue(...)`) while reusing the rest of the
/// graph, so nothing in the app has to know whether it runs in production or in
/// a test.
List<Override> get appProviderOverrides => [
  // The default categories belong to a feature, so core cannot reference them
  // directly; the composition root supplies them here instead.
  databaseSeedersProvider.overrideWith(
    (ref) => const [DefaultCategorySeeder()],
  ),
];
