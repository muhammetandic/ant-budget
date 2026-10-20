import 'package:drift/drift.dart';
import 'package:ant_budget/core/data/database/app_database.dart';
import 'package:ant_budget/core/values/money.dart';
import 'package:ant_budget/features/transactions/domain/entities/transaction.dart';

/// Translates between the Drift row ([TransactionDto]) and the domain entity.
///
/// Keeping the conversion explicit means the schema can evolve (renamed column,
/// split field, ...) without a single change in the domain.
abstract final class TransactionMapper {
  /// Builds a domain entity from a database row.
  static Transaction toDomain(TransactionDto dto) => Transaction(
    id: dto.id,
    amount: Money(dto.amountMinorUnits, dto.currency),
    categoryId: dto.categoryId,
    occurredAt: dto.occurredAt,
    kind: dto.kind,
    description: dto.description,
    source: dto.source,
    receiptMerchant: dto.receiptMerchant,
    receiptImagePath: dto.receiptImagePath,
  );

  /// Builds an insert/update companion from a domain entity.
  static TransactionsCompanion toCompanion(Transaction transaction) =>
      TransactionsCompanion.insert(
        amountMinorUnits: transaction.amount.minorUnits,
        currency: transaction.amount.currency,
        kind: transaction.kind,
        occurredAt: transaction.occurredAt,
        categoryId: transaction.categoryId,
        source: transaction.source,
        description: Value(transaction.description),
        receiptMerchant: Value.absentIfNull(transaction.receiptMerchant),
        receiptImagePath: Value.absentIfNull(transaction.receiptImagePath),
      );

  /// Builds a companion that overwrites the whole stored row.
  ///
  /// Unlike [toCompanion], nullable columns are written explicitly (`null`
  /// included) instead of being skipped: an update replaces the row, so it
  /// must not leave stale receipt fields behind.
  static TransactionsCompanion toUpdateCompanion(
    Transaction transaction,
  ) => TransactionsCompanion(
    amountMinorUnits: Value(transaction.amount.minorUnits),
    currency: Value(transaction.amount.currency),
    kind: Value(transaction.kind),
    occurredAt: Value(transaction.occurredAt),
    categoryId: Value(transaction.categoryId),
    source: Value(transaction.source),
    description: Value(transaction.description),
    receiptMerchant: Value(transaction.receiptMerchant),
    receiptImagePath: Value(transaction.receiptImagePath),
  );
}
