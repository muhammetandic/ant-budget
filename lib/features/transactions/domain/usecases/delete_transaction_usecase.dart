import 'package:ant_budget/core/error/failure.dart';
import 'package:ant_budget/core/error/result.dart';
import 'package:ant_budget/core/values/unit.dart';
import 'package:ant_budget/features/transactions/domain/repositories/transaction_repository.dart';

/// Deletes a stored transaction.
final class DeleteTransactionUseCase {
  const DeleteTransactionUseCase(this._repository);

  final TransactionRepository _repository;

  Future<Result<Unit, Failure>> call(int transactionId) {
    if (transactionId <= 0) {
      return Future.value(
        Result.failure(
          NotFoundFailure(
            message: 'That transaction no longer exists.',
            entityType: 'Transaction',
            entityId: transactionId,
          ),
        ),
      );
    }
    return _repository.deleteById(transactionId);
  }
}
