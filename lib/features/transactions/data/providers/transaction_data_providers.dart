import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_budget_tracker/core/providers/database_providers.dart';
import 'package:smart_budget_tracker/features/transactions/data/datasources/transaction_dao.dart';
import 'package:smart_budget_tracker/features/transactions/data/repositories/transaction_repository_impl.dart';
import 'package:smart_budget_tracker/features/transactions/domain/repositories/transaction_repository.dart';

part 'transaction_data_providers.g.dart';

/// Dependency wiring of the transactions *data* layer.
///
/// Both providers are auto-disposing and stateless: the DAO only holds the
/// shared `AppDatabase`, the repository only holds the DAO, so re-creating them
/// is free. State lives in the database, not in these objects.
@riverpod
TransactionDao transactionDao(Ref ref) =>
    TransactionDao(ref.watch(appDatabaseProvider));

/// The repository the domain depends on: an abstraction, never the Drift DAO.
@riverpod
TransactionRepository transactionRepository(Ref ref) =>
    TransactionRepositoryImpl(ref.watch(transactionDaoProvider));
