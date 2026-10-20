import 'package:ant_budget/core/values/currency.dart';
import 'package:ant_budget/core/values/year_month.dart';
import 'package:ant_budget/features/reports/data/datasources/report_dao.dart';
import 'package:ant_budget/features/reports/domain/repositories/expense_report_repository.dart';
import 'package:ant_budget/features/reports/domain/values/expense_group.dart';

/// Drift backed implementation of [ExpenseReportRepository].
///
/// Its only job is orchestration: delegate to the DAO and hand the grouped rows
/// to the domain. No report rule lives here.
final class ExpenseReportRepositoryImpl implements ExpenseReportRepository {
  ExpenseReportRepositoryImpl(this._dao);

  final ReportDao _dao;

  @override
  Stream<List<ExpenseGroup>> watchExpenseGroups({
    required YearMonth period,
    required Currency currency,
  }) => _dao.watchExpenseGroups(period: period, currency: currency);
}
