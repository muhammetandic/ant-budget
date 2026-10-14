import 'package:drift/drift.dart';
import 'package:ant_budget/core/values/currency.dart';

/// Drift table storing the monthly budget limit.
///
/// One row per civil month: the unique key on `(year, month)` lets the database
/// enforce the invariant instead of the domain having to check for duplicates.
@DataClassName('BudgetDto')
class Budgets extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get year => integer()();

  /// Month of the year, `1..12`.
  IntColumn get month => integer()();

  IntColumn get limitMinorUnits => integer()();

  TextColumn get currency => textEnum<Currency>()();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {year, month},
  ];
}
