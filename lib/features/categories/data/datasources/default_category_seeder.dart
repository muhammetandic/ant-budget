import 'package:smart_budget_tracker/core/data/database/app_database.dart';
import 'package:smart_budget_tracker/core/data/database/database_seeder.dart';
import 'package:smart_budget_tracker/core/values/category_icon.dart';
import 'package:smart_budget_tracker/features/categories/data/mappers/category_mapper.dart';
import 'package:smart_budget_tracker/features/categories/domain/entities/category.dart';

/// Populates the database with the categories the app ships with.
///
/// Registered by the composition root (`appProviderOverrides`) and executed once
/// by `AppDatabase.beforeOpen` for a freshly created database.
final class DefaultCategorySeeder implements DatabaseSeeder {
  const DefaultCategorySeeder();

  @override
  Future<void> seed(AppDatabase database) => database.batch((batch) {
    batch.insertAll(
      database.categories,
      defaultCategories.map(CategoryMapper.toCompanion).toList(growable: false),
    );
  });
}

/// Categories available out of the box.
///
/// Colours are plain ARGB ints; the icon is the semantic [CategoryIcon] so the
/// presentation layer keeps a `const` `IconData` mapping (icon tree shaking).
const List<Category> defaultCategories = [
  Category(
    name: 'Groceries',
    icon: CategoryIcon.groceries,
    colorValue: 0xFF2E7D32,
    isDefault: true,
  ),
  Category(
    name: 'Dining out',
    icon: CategoryIcon.dining,
    colorValue: 0xFFEF6C00,
    isDefault: true,
  ),
  Category(
    name: 'Transport',
    icon: CategoryIcon.transport,
    colorValue: 0xFF1565C0,
    isDefault: true,
  ),
  Category(
    name: 'Shopping',
    icon: CategoryIcon.shopping,
    colorValue: 0xFF6A1B9A,
    isDefault: true,
  ),
  Category(
    name: 'Bills & utilities',
    icon: CategoryIcon.bills,
    colorValue: 0xFF00838F,
    isDefault: true,
  ),
  Category(
    name: 'Health',
    icon: CategoryIcon.health,
    colorValue: 0xFFC62828,
    isDefault: true,
  ),
  Category(
    name: 'Entertainment',
    icon: CategoryIcon.entertainment,
    colorValue: 0xFF4527A0,
    isDefault: true,
  ),
  Category(
    name: 'Salary',
    icon: CategoryIcon.salary,
    colorValue: 0xFF00796B,
    isDefault: true,
  ),
  Category(
    name: 'Other',
    icon: CategoryIcon.other,
    colorValue: 0xFF455A64,
    isDefault: true,
  ),
];
