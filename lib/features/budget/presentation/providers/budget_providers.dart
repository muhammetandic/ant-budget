import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_budget_tracker/core/config/app_config.dart';
import 'package:smart_budget_tracker/core/values/year_month.dart';
import 'package:smart_budget_tracker/features/budget/data/providers/budget_data_providers.dart';
import 'package:smart_budget_tracker/features/budget/domain/usecases/set_budget_limit_usecase.dart';
import 'package:smart_budget_tracker/features/budget/domain/usecases/watch_budget_summary_usecase.dart';
import 'package:smart_budget_tracker/features/budget/domain/values/budget_summary.dart';
import 'package:smart_budget_tracker/features/transactions/data/providers/transaction_data_providers.dart';

part 'budget_providers.g.dart';

/// Use case providers of the budget feature.
@riverpod
SetBudgetLimitUseCase setBudgetLimitUseCase(Ref ref) =>
    SetBudgetLimitUseCase(ref.watch(budgetRepositoryProvider));

@riverpod
WatchBudgetSummaryUseCase watchBudgetSummaryUseCase(Ref ref) =>
    WatchBudgetSummaryUseCase(
      ref.watch(budgetRepositoryProvider),
      ref.watch(transactionRepositoryProvider),
      AppConfig.reportingCurrency,
    );

/// The budget health of [period], reactively and auto-disposed per month.
///
/// The read model is assembled by the use case from two reactive sources
/// (budget + transaction totals), so a new expense updates this stream without
/// any manual invalidation.
@riverpod
Stream<BudgetSummary> budgetSummary(Ref ref, YearMonth period) =>
    ref.watch(watchBudgetSummaryUseCaseProvider)(period);
