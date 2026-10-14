import 'package:smart_budget_tracker/features/transactions/domain/entities/transaction.dart';
import 'package:smart_budget_tracker/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:smart_budget_tracker/features/transactions/domain/values/transaction_filter.dart';

/// Streams the transactions matching a [TransactionFilter].
///
/// One use case = one reason to change. Screens depend on the use case, never
/// on the repository, so query behaviour can evolve without touching the UI.
final class WatchTransactionsUseCase {
  const WatchTransactionsUseCase(this._repository);

  final TransactionRepository _repository;

  Stream<List<Transaction>> call(TransactionFilter filter) =>
      _repository.watch(filter);
}
