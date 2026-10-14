import 'package:smart_budget_tracker/core/data/database/app_database.dart';

/// Port for objects that pre-populate a freshly created database.
///
/// Implemented by features (e.g. the default categories of the categories
/// feature) and injected into [AppDatabase] by the composition root, which
/// keeps the core schema free of feature dependencies while still allowing
/// first-run content.
abstract interface class DatabaseSeeder {
  /// Inserts the seed data into [database].
  ///
  /// Called exactly once, inside `beforeOpen`, right after the schema was
  /// created.
  Future<void> seed(AppDatabase database);
}
