import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ant_budget/core/config/app_config.dart';
import 'package:ant_budget/core/values/year_month.dart';
import 'package:ant_budget/features/reports/data/providers/report_data_providers.dart';
import 'package:ant_budget/features/reports/domain/usecases/watch_expense_breakdown_usecase.dart';
import 'package:ant_budget/features/reports/domain/values/expense_breakdown.dart';

part 'report_providers.g.dart';

/// Use case provider: the UI asks for *behaviour*, never for the repository.
@riverpod
WatchExpenseBreakdownUseCase watchExpenseBreakdownUseCase(Ref ref) =>
    WatchExpenseBreakdownUseCase(
      ref.watch(expenseReportRepositoryProvider),
      AppConfig.reportingCurrency,
    );

/// Category and shop report of [period], reactively and auto-disposed per month.
///
/// The same [YearMonth] moves the overview, the transaction list and the report,
/// so one month switcher drives all three.
@riverpod
Stream<ExpenseBreakdown> expenseBreakdown(Ref ref, YearMonth period) =>
    ref.watch(watchExpenseBreakdownUseCaseProvider)(period);
