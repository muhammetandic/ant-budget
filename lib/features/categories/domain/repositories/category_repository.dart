import 'package:smart_budget_tracker/features/categories/domain/entities/category.dart';

/// Port describing how the domain reads categories.
///
/// Version 1 ships with the seeded default categories, so this interface is
/// read-only on purpose. Adding user managed categories means adding
/// `save`/`delete` here plus the matching use cases and DAO statements — no
/// other layer has to change.
abstract interface class CategoryRepository {
  /// Emits every category, alphabetically ordered, and re-emits on writes.
  Stream<List<Category>> watchAll();
}
