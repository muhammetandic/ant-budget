import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:ant_budget/core/values/money.dart';

/// One row of a report: an amount, how many transactions it is made of, and
/// which part of the month's expenses it covers.
///
/// A slice belongs to exactly one dimension, which the named constructors
/// enforce: [ExpenseSlice.category] for the category report,
/// [ExpenseSlice.merchant] for the shop report.
@immutable
final class ExpenseSlice extends Equatable {
  /// A slice of the category dimension.
  const ExpenseSlice.category({
    required int this.categoryId,
    required this.amount,
    required this.transactions,
    required this.share,
  }) : merchant = null;

  /// A slice of the merchant dimension.
  const ExpenseSlice.merchant({
    required String this.merchant,
    required this.amount,
    required this.transactions,
    required this.share,
  }) : categoryId = null;

  /// Category the slice stands for; `null` on the merchant dimension.
  final int? categoryId;

  /// Shop the slice stands for; `null` on the category dimension.
  final String? merchant;

  /// Sum of the slice, positive and in the reporting currency.
  final Money amount;

  /// Number of transactions in the slice.
  final int transactions;

  /// Share of the month's *expenses*, `0..1`.
  ///
  /// Both dimensions divide by the same month total, so a category slice and a
  /// shop slice of the same size mean the same amount of money. Shares of the
  /// shop dimension therefore add up to at most `1`: hand written entries
  /// without a shop are not attributed to anyone.
  final double share;

  /// [share] rounded to whole percent, for labels only.
  int get sharePercent => (share * 100).round();

  @override
  List<Object?> get props => [
    categoryId,
    merchant,
    amount,
    transactions,
    share,
  ];
}
