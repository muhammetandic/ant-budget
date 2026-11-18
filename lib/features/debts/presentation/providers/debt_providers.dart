import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ant_budget/core/values/debt_type.dart';
import 'package:ant_budget/features/debts/data/providers/debt_data_providers.dart';
import 'package:ant_budget/features/debts/domain/entities/debt_entry.dart';
import 'package:ant_budget/features/debts/domain/usecases/delete_debt_usecase.dart';
import 'package:ant_budget/features/debts/domain/usecases/save_debt_usecase.dart';
import 'package:ant_budget/features/debts/domain/usecases/toggle_debt_settled_usecase.dart';
import 'package:ant_budget/features/debts/domain/usecases/watch_debts_usecase.dart';
import 'package:ant_budget/features/debts/domain/values/debt_summary.dart';

part 'debt_providers.g.dart';

enum DebtFilter { all, claims, debts }

@riverpod
WatchDebtsUseCase watchDebtsUseCase(Ref ref) =>
    WatchDebtsUseCase(ref.watch(debtRepositoryProvider));

@riverpod
SaveDebtUseCase saveDebtUseCase(Ref ref) =>
    SaveDebtUseCase(ref.watch(debtRepositoryProvider));

@riverpod
DeleteDebtUseCase deleteDebtUseCase(Ref ref) =>
    DeleteDebtUseCase(ref.watch(debtRepositoryProvider));

@riverpod
ToggleDebtSettledUseCase toggleDebtSettledUseCase(Ref ref) =>
    ToggleDebtSettledUseCase(ref.watch(debtRepositoryProvider));

@riverpod
Stream<List<DebtEntry>> debtsList(Ref ref) =>
    ref.watch(watchDebtsUseCaseProvider)();

@riverpod
class ActiveDebtFilter extends _$ActiveDebtFilter {
  @override
  DebtFilter build() => DebtFilter.all;

  void select(DebtFilter filter) => state = filter;
}

@riverpod
DebtSummary debtSummary(Ref ref) {
  final entries = ref.watch(debtsListProvider).value ?? const [];
  return DebtSummary.fromEntries(entries);
}

@riverpod
List<DebtEntry> filteredDebts(Ref ref) {
  final entries = ref.watch(debtsListProvider).value ?? const [];
  final filter = ref.watch(activeDebtFilterProvider);

  return switch (filter) {
    DebtFilter.all => entries,
    DebtFilter.claims =>
      entries.where((e) => e.type == DebtType.claim).toList(),
    DebtFilter.debts => entries.where((e) => e.type == DebtType.debt).toList(),
  };
}
