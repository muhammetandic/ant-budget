import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:smart_budget_tracker/core/values/money.dart';
import 'package:smart_budget_tracker/core/values/transaction_kind.dart';
import 'package:smart_budget_tracker/core/values/transaction_source.dart';

/// Intent to record a new transaction.
///
/// The presentation layer describes *what the user wants*; the
/// `AddTransactionUseCase` validates the intent and builds the [Transaction]
/// entity from it. Keeping the two apart means form state can never corrupt a
/// domain entity.
@immutable
final class AddTransactionCommand extends Equatable {
  const AddTransactionCommand({
    required this.amount,
    required this.categoryId,
    required this.occurredAt,
    required this.kind,
    this.description = '',
    this.source = TransactionSource.manual,
    this.receiptMerchant,
    this.receiptImagePath,
  });

  final Money amount;
  final int categoryId;
  final DateTime occurredAt;
  final TransactionKind kind;
  final String description;
  final TransactionSource source;
  final String? receiptMerchant;
  final String? receiptImagePath;

  @override
  List<Object?> get props => [
    amount,
    categoryId,
    occurredAt,
    kind,
    description,
    source,
    receiptMerchant,
    receiptImagePath,
  ];
}
