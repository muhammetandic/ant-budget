import 'package:drift/drift.dart';
import 'package:ant_budget/core/data/database/app_database.dart';
import 'package:ant_budget/features/categories/domain/entities/category.dart';

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

  /// Builds a companion for insert *or* update.
  ///
  /// The id stays absent so the same companion can be written to an existing
  /// row; [CategoryDao] decides which statement to run from the entity's id.
  static CategoriesCompanion toWriteCompanion(Category category) =>
      CategoriesCompanion(
        name: Value(category.name),
        icon: Value(category.icon),
        colorValue: Value(category.colorValue),
        isDefault: Value(category.isDefault),
      );
}
