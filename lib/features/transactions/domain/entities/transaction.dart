import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:ant_budget/core/values/money.dart';
import 'package:ant_budget/core/values/transaction_kind.dart';
import 'package:ant_budget/core/values/transaction_source.dart';

/// A single recorded movement of money.
///
/// Pure domain object: it knows nothing about Drift, Riverpod or Flutter. The
/// data layer maps its `TransactionDto` row onto this entity through
/// `TransactionMapper`.
@immutable
final class Transaction extends Equatable {
  const Transaction({
    this.id,
    required this.amount,
    required this.categoryId,
    required this.occurredAt,
    required this.kind,
    this.description = '',
    this.source = TransactionSource.manual,
    this.receiptMerchant,
    this.receiptImagePath,
  });

  /// Database identity; `null` for a transaction that was not saved yet.
  final int? id;

  /// Signed by intent (see [kind]), always a positive amount.
  final Money amount;

  /// Identifier of the owning category.
  final int categoryId;

  /// When the money moved (not when the row was created).
  final DateTime occurredAt;

  final TransactionKind kind;

  /// Free text entered by the user.
  final String description;

  /// Where the transaction came from (manual entry vs. receipt scan).
  final TransactionSource source;

  /// Merchant parsed from the receipt, when [source] is a scan.
  final String? receiptMerchant;

  /// Path of the captured receipt image, when [source] is a scan.
  final String? receiptImagePath;

  /// Whether the entity already has a database identity.
  bool get isPersisted => id != null;

  /// Text to show in a list: the user's description, falling back to the
  /// merchant of the scanned receipt.
  ///
  /// Empty when neither is present; the placeholder shown in that case depends
  /// on the language, so it is supplied by the presentation layer.
  String get displayTitle {
    final trimmedDescription = description.trim();
    if (trimmedDescription.isNotEmpty) return trimmedDescription;
    final merchant = receiptMerchant?.trim();
    if (merchant != null && merchant.isNotEmpty) return merchant;
    return '';
  }

  @override
  List<Object?> get props => [
    id,
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
