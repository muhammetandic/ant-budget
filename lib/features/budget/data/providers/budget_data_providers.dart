import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ant_budget/core/providers/database_providers.dart';
import 'package:ant_budget/features/budget/data/datasources/budget_dao.dart';
import 'package:ant_budget/features/budget/data/repositories/budget_repository_impl.dart';
import 'package:ant_budget/features/budget/domain/repositories/budget_repository.dart';

part 'budget_data_providers.g.dart';

/// Dependency wiring of the budget data layer.
@riverpod
BudgetDao budgetDao(Ref ref) => BudgetDao(ref.watch(appDatabaseProvider));

/// The budget repository abstraction injected into the domain use cases.
@riverpod
BudgetRepository budgetRepository(Ref ref) =>
    BudgetRepositoryImpl(ref.watch(budgetDaoProvider));
