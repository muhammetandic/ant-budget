import 'package:ant_budget/core/data/database/app_database.dart';
import 'package:ant_budget/core/values/money.dart';
import 'package:ant_budget/core/values/year_month.dart';
import 'package:ant_budget/features/budget/domain/entities/category_budget.dart';

/// Translates between a `category_budgets` row and [CategoryBudget].
abstract final class CategoryBudgetMapper {
  /// Builds a domain entity from a database row.
  ///
  /// The row stores `year` and `month` as two columns; the domain collapses them
  /// into the [YearMonth] value object, exactly like the month's own budget.
  static CategoryBudget toDomain(CategoryBudgetDto dto) => CategoryBudget(
    id: dto.id,
    period: YearMonth(dto.year, dto.month),
    categoryId: dto.categoryId,
    limit: Money(dto.limitMinorUnits, dto.currency),
  );
}
