import 'package:ant_budget/core/error/failure.dart';
import 'package:ant_budget/features/transactions/domain/entities/transaction.dart';

/// The rules every stored transaction must pass, whatever created it.
///
/// Creating (`AddTransactionUseCase`) and editing (`UpdateTransactionUseCase`)
/// describe different intents but end up storing the same entity, so the checks
/// they share live here instead of being written twice.
abstract final class TransactionRules {
  /// Descriptions longer than this are rejected instead of silently truncated.
  static const int maxDescriptionLength = 160;

  /// Transactions older than this are assumed to be a data entry mistake.
  static final DateTime earliestDate = DateTime(2000);

  /// The failure [transaction] would cause, or `null` when it may be stored.
  static ValidationFailure? rejectionFor(Transaction transaction) {
    if (!transaction.amount.isPositive) {
      return const ValidationFailure(
        message: 'Enter an amount greater than zero.',
        issue: ValidationIssue.amountNotPositive,
        field: 'amount',
      );
    }
    if (transaction.categoryId <= 0) {
      return const ValidationFailure(
        message: 'Choose a category for this transaction.',
        issue: ValidationIssue.categoryMissing,
        field: 'categoryId',
      );
    }
    if (transaction.description.trim().length > maxDescriptionLength) {
      return ValidationFailure(
        message:
            'The description must be $maxDescriptionLength characters or fewer.',
        issue: ValidationIssue.descriptionTooLong,
        field: 'description',
      );
    }
    if (transaction.occurredAt.isBefore(earliestDate)) {
      return const ValidationFailure(
        message: 'Pick a date within this century.',
        issue: ValidationIssue.dateOutOfRange,
        field: 'occurredAt',
      );
    }
    return null;
  }

  /// Copy of [transaction] with its text fields trimmed, as it gets stored.
  static Transaction normalize(Transaction transaction) => Transaction(
    id: transaction.id,
    amount: transaction.amount,
    categoryId: transaction.categoryId,
    occurredAt: transaction.occurredAt,
    kind: transaction.kind,
    description: transaction.description.trim(),
    source: transaction.source,
    receiptMerchant: transaction.receiptMerchant?.trim(),
    receiptImagePath: transaction.receiptImagePath,
  );
}
