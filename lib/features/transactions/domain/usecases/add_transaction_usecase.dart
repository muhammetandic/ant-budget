import 'package:ant_budget/core/error/failure.dart';
import 'package:ant_budget/core/error/result.dart';
import 'package:ant_budget/features/transactions/domain/entities/transaction.dart';
import 'package:ant_budget/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:ant_budget/features/transactions/domain/usecases/transaction_rules.dart';
import 'package:ant_budget/features/transactions/domain/values/add_transaction_command.dart';

/// Validates an [AddTransactionCommand] and turns it into a stored transaction.
///
/// The form only collects strings; this use case decides whether they describe
/// a valid movement of money (the checks live in [TransactionRules], shared
/// with editing) and stores the trimmed entity.
final class AddTransactionUseCase {
  const AddTransactionUseCase(this._repository);

  final TransactionRepository _repository;

  Future<Result<int, Failure>> call(AddTransactionCommand command) {
    final draft = Transaction(
      amount: command.amount,
      categoryId: command.categoryId,
      occurredAt: command.occurredAt,
      kind: command.kind,
      description: command.description,
      source: command.source,
      receiptMerchant: command.receiptMerchant,
      receiptImagePath: command.receiptImagePath,
    );
    final rejection = TransactionRules.rejectionFor(draft);
    if (rejection != null) return Future.value(Result.failure(rejection));
    return _repository.save(TransactionRules.normalize(draft));
  }
}
