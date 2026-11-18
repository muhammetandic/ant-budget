import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ant_budget/core/providers/database_providers.dart';
import 'package:ant_budget/features/debts/data/datasources/debt_dao.dart';
import 'package:ant_budget/features/debts/data/repositories/debt_repository_impl.dart';
import 'package:ant_budget/features/debts/domain/repositories/debt_repository.dart';

part 'debt_data_providers.g.dart';

@riverpod
DebtDao debtDao(Ref ref) => DebtDao(ref.watch(appDatabaseProvider));

@riverpod
DebtRepository debtRepository(Ref ref) =>
    DebtRepositoryImpl(ref.watch(debtDaoProvider));
