import 'package:smart_budget_tracker/core/error/failure.dart';
import 'package:smart_budget_tracker/core/error/result.dart';
import 'package:smart_budget_tracker/core/values/money.dart';
import 'package:smart_budget_tracker/core/values/unit.dart';
import 'package:smart_budget_tracker/core/values/year_month.dart';
import 'package:smart_budget_tracker/features/budget/domain/entities/budget.dart';

/// Port describing how the domain stores monthly budgets.
abstract interface class BudgetRepository {
  /// Emits the budget of [period], or `null` when the user has not set one.
  Stream<Budget?> watchFor(YearMonth period);

  /// Creates or replaces the limit of [period].
  Future<Result<Unit, Failure>> setLimit({
    required YearMonth period,
    required Money limit,
  });
}
