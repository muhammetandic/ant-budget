import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:smart_budget_tracker/core/values/currency.dart';
import 'package:smart_budget_tracker/core/values/money.dart';
import 'package:smart_budget_tracker/core/values/year_month.dart';

/// Aggregated income and expenses of one month, in a single [currency].
///
/// Produced by the database with a `SUM` aggregate, so the domain never has to
/// iterate over a list of transactions to compute a report.
@immutable
final class MonthlyTotals extends Equatable {
  const MonthlyTotals({
    required this.period,
    required this.currency,
    required this.expenses,
    required this.income,
  });

  /// A month without any transaction.
  factory MonthlyTotals.empty(YearMonth period, Currency currency) =>
      MonthlyTotals(
        period: period,
        currency: currency,
        expenses: Money.zero(currency),
        income: Money.zero(currency),
      );

  final YearMonth period;
  final Currency currency;
  final Money expenses;
  final Money income;

  /// Net result of the month (`income - expenses`, can be negative).
  Money get balance => income - expenses;

  @override
  List<Object?> get props => [period, currency, expenses, income];
}
