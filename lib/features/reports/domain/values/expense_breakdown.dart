import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:ant_budget/core/values/currency.dart';
import 'package:ant_budget/core/values/money.dart';
import 'package:ant_budget/core/values/year_month.dart';
import 'package:ant_budget/features/reports/domain/values/expense_slice.dart';

/// Expenses of one month cut along the two axes a report needs: the category
/// the money was filed under and the shop it was spent at.
///
/// Both lists are ordered by amount, largest first, and are empty for a month
/// without expenses — see [isEmpty].
@immutable
final class ExpenseBreakdown extends Equatable {
  const ExpenseBreakdown({
    required this.period,
    required this.currency,
    required this.total,
    required this.byCategory,
    required this.byMerchant,
  });

  /// A month without a single expense.
  factory ExpenseBreakdown.empty(YearMonth period, Currency currency) =>
      ExpenseBreakdown(
        period: period,
        currency: currency,
        total: Money.zero(currency),
        byCategory: const [],
        byMerchant: const [],
      );

  /// The month these numbers belong to.
  final YearMonth period;

  /// Currency every amount in this report is expressed in.
  final Currency currency;

  /// Sum of every expense of the month.
  final Money total;

  /// One slice per category that carries expenses, ordered by amount.
  final List<ExpenseSlice> byCategory;

  /// One slice per shop that carries expenses, ordered by amount.
  final List<ExpenseSlice> byMerchant;

  /// Whether the month has no expenses at all, i.e. nothing to report.
  bool get isEmpty => total.isZero;

  @override
  List<Object?> get props => [period, currency, total, byCategory, byMerchant];
}
