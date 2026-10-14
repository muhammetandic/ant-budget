import 'package:ant_budget/core/error/failure.dart';
import 'package:ant_budget/core/error/result.dart';
import 'package:ant_budget/features/transactions/domain/entities/transaction.dart';
import 'package:ant_budget/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:ant_budget/features/transactions/domain/values/add_transaction_command.dart';

/// Validates an [AddTransactionCommand] and turns it into a stored transaction.
///
/// All business rules of *creating* a transaction live here (and nowhere else):
/// the form only collects strings, this use case decides whether they describe
/// a valid movement of money.
final class AddTransactionUseCase {
  const AddTransactionUseCase(this._repository);

  /// Descriptions longer than this are rejected instead of silently truncated.
  static const int maxDescriptionLength = 160;

  /// Transactions older than this are assumed to be a data entry mistake.
  static final DateTime earliestDate = DateTime(2000);

  final TransactionRepository _repository;

  Future<Result<int, Failure>> call(AddTransactionCommand command) {
    final validation = _validate(command);
    if (validation != null) return Future.value(Result.failure(validation));

    final transaction = Transaction(
      amount: command.amount,
      categoryId: command.categoryId,
      occurredAt: command.occurredAt,
      kind: command.kind,
      description: command.description.trim(),
      source: command.source,
      receiptMerchant: command.receiptMerchant?.trim(),
      receiptImagePath: command.receiptImagePath,
    );
    return _repository.save(transaction);
  }

  ValidationFailure? _validate(AddTransactionCommand command) {
    if (!command.amount.isPositive) {
      return const ValidationFailure(
        message: 'Enter an amount greater than zero.',
        field: 'amount',
      );
    }
    if (command.categoryId <= 0) {
      return const ValidationFailure(
        message: 'Choose a category for this transaction.',
        field: 'categoryId',
      );
    }
    if (command.description.trim().length > maxDescriptionLength) {
      return ValidationFailure(
        message: 'The description must be $maxDescriptionLength characters or fewer.',
        field: 'description',
      );
    }
    if (command.occurredAt.isBefore(earliestDate)) {
      return const ValidationFailure(
        message: 'Pick a date within this century.',
        field: 'occurredAt',
      );
    }
    return null;
  }
}
