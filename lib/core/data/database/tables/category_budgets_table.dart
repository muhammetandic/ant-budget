import 'package:drift/drift.dart';
import 'package:ant_budget/core/data/database/tables/categories_table.dart';
import 'package:ant_budget/core/values/currency.dart';

/// Drift table storing one category's spending limit for one civil month.
///
/// The unique key on `(year, month, categoryId)` is the domain rule "one budget
/// per category per month" enforced by the database rather than by code, and it
/// is also the conflict target every write upserts against.
@DataClassName('CategoryBudgetDto')
class CategoryBudgets extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get year => integer()();

  /// Month of the year, `1..12`.
  IntColumn get month => integer()();

  /// The category this limit belongs to.
  ///
  /// The cascade keeps the invariant "a budget describes an existing category"
  /// when the categories screen removes one; SQLite only applies it while
  /// `PRAGMA foreign_keys` is on (see `AppDatabase.migration`).
  IntColumn get categoryId =>
      integer().references(Categories, #id, onDelete: KeyAction.cascade)();

  IntColumn get limitMinorUnits => integer()();

  TextColumn get currency => textEnum<Currency>()();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {year, month, categoryId},
  ];
}
