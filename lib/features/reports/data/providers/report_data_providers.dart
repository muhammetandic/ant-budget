import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ant_budget/core/providers/database_providers.dart';
import 'package:ant_budget/features/reports/data/datasources/report_dao.dart';
import 'package:ant_budget/features/reports/data/repositories/expense_report_repository_impl.dart';
import 'package:ant_budget/features/reports/domain/repositories/expense_report_repository.dart';

part 'report_data_providers.g.dart';

/// Dependency wiring of the reports data layer.
@riverpod
ReportDao reportDao(Ref ref) => ReportDao(ref.watch(appDatabaseProvider));

/// The report repository abstraction injected into the domain use cases.
@riverpod
ExpenseReportRepository expenseReportRepository(Ref ref) =>
    ExpenseReportRepositoryImpl(ref.watch(reportDaoProvider));
