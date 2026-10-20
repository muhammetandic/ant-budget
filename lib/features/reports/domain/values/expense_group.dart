import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:ant_budget/core/values/money.dart';

/// One bucket of a month's expenses, exactly as SQLite grouped it: by the
/// category the money was filed under *and* the shop it was spent at.
///
/// The database sums and counts; the domain only decides how these buckets are
/// assembled into the two dimensions a report shows.
@immutable
final class ExpenseGroup extends Equatable {
  const ExpenseGroup({
    required this.categoryId,
    required this.merchant,
    required this.amount,
    required this.transactions,
    required this.lastOccurredAt,
  });

  /// Category the money was filed under (a non-null foreign key).
  final int categoryId;

  /// Shop name stored on the receipts of the bucket, `null` when the
  /// transactions were entered by hand without one.
  final String? merchant;

  /// Sum of the bucket, positive and in the reporting currency.
  final Money amount;

  /// Number of transactions in the bucket.
  final int transactions;

  /// When the newest transaction of the bucket happened.
  ///
  /// A shop can reach the app in more than one spelling; this is what lets the
  /// report keep the one the user has seen most recently as its label.
  final DateTime lastOccurredAt;

  @override
  List<Object?> get props => [
    categoryId,
    merchant,
    amount,
    transactions,
    lastOccurredAt,
  ];
}
