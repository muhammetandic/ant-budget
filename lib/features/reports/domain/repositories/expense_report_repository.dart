import 'package:ant_budget/core/values/currency.dart';
import 'package:ant_budget/core/values/year_month.dart';
import 'package:ant_budget/features/reports/domain/values/expense_group.dart';

/// Port describing how the report reads its numbers.
///
/// The implementation (Drift + SQLite) lives in the data layer; the domain only
/// knows this interface, which is what makes the use case unit-testable with a
/// hand written fake and the aggregation replaceable.
abstract interface class ExpenseReportRepository {
  /// Expenses of [period] in [currency], summed per (category, merchant), and
  /// re-emitting whenever a write changes those numbers.
  ///
  /// Income never appears: a report answers "where did the money go?".
  Stream<List<ExpenseGroup>> watchExpenseGroups({
    required YearMonth period,
    required Currency currency,
  });
}
