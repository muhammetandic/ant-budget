import 'package:ant_budget/core/error/failure.dart';
import 'package:ant_budget/core/error/result.dart';
import 'package:ant_budget/features/transactions/domain/entities/transaction.dart';
import 'package:ant_budget/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:ant_budget/features/transactions/domain/usecases/transaction_rules.dart';

/// Replaces a stored transaction with the user's edited copy.
///
/// The rules are the same as when creating one ([TransactionRules]); the only
/// added requirement is that the entity already has a database identity, since
/// there is nothing to overwrite without one.
final class UpdateTransactionUseCase {
  const UpdateTransactionUseCase(this._repository);

  final TransactionRepository _repository;

  Future<Result<int, Failure>> call(Transaction transaction) {
    final id = transaction.id;
    if (id == null || id <= 0) {
      return Future.value(
        Result.failure(
          NotFoundFailure(
            message: 'That transaction no longer exists.',
            entityType: 'Transaction',
            entityId: id,
          ),
        ),
      );
    }
    final rejection = TransactionRules.rejectionFor(transaction);
    if (rejection != null) return Future.value(Result.failure(rejection));
    return _repository.update(TransactionRules.normalize(transaction));
  }
}
