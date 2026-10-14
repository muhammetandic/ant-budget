import 'package:drift/drift.dart';
import 'package:smart_budget_tracker/core/values/category_icon.dart';

/// Drift table storing expense/income categories.
///
/// The generated row class is named `CategoryDto`: the data layer maps it onto
/// the `Category` domain entity through `CategoryMapper`, so schema changes
/// never leak into the domain.
@DataClassName('CategoryDto')
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().withLength(min: 1, max: 60)();

  /// Semantic icon ([CategoryIcon]); the UI resolves it to a `const IconData`.
  TextColumn get icon => textEnum<CategoryIcon>()();

  /// ARGB colour of the category as an int, so no Flutter type is persisted.
  IntColumn get colorValue => integer()();

  /// Whether the category was created by [DatabaseSeeder] rather than the user.
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
}
