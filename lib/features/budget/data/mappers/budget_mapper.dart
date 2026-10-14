import 'package:smart_budget_tracker/core/data/database/app_database.dart';
import 'package:smart_budget_tracker/core/values/money.dart';
import 'package:smart_budget_tracker/core/values/year_month.dart';
import 'package:smart_budget_tracker/features/budget/domain/entities/budget.dart';

/// Translates between the `budgets` table row and the [Budget] entity.
abstract final class BudgetMapper {
  /// Builds a domain entity from a database row.
  ///
  /// The row stores `year` and `month` as two columns; the domain collapses them
  /// into the [YearMonth] value object.
  static Budget toDomain(BudgetDto dto) => Budget(
    id: dto.id,
    period: YearMonth(dto.year, dto.month),
    limit: Money(dto.limitMinorUnits, dto.currency),
  );
}
