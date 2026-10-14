import 'package:drift/drift.dart';
import 'package:smart_budget_tracker/core/data/database/app_database.dart';
import 'package:smart_budget_tracker/features/categories/domain/entities/category.dart';

/// Translates between the `categories` table row and the [Category] entity.
abstract final class CategoryMapper {
  /// Builds a domain entity from a database row.
  static Category toDomain(CategoryDto dto) => Category(
    id: dto.id,
    name: dto.name,
    icon: dto.icon,
    colorValue: dto.colorValue,
    isDefault: dto.isDefault,
  );

  /// Builds an insert companion from a domain entity.
  static CategoriesCompanion toCompanion(Category category) =>
      CategoriesCompanion.insert(
        name: category.name,
        icon: category.icon,
        colorValue: category.colorValue,
        isDefault: Value(category.isDefault),
      );
}
