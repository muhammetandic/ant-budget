import 'package:ant_budget/core/values/currency.dart';
import 'package:ant_budget/core/values/year_month.dart';
import 'package:ant_budget/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:ant_budget/features/transactions/domain/values/monthly_totals.dart';

/// Streams the aggregated totals of a month in the reporting currency.
final class WatchMonthlyTotalsUseCase {
  const WatchMonthlyTotalsUseCase(this._repository, this._currency);

  final TransactionRepository _repository;
  final Currency _currency;

  /// The currency every aggregate is expressed in. Injected instead of read
  /// globally so tests can exercise a different reporting currency.
  Currency get currency => _currency;

  Stream<MonthlyTotals> call(YearMonth period) =>
      _repository.watchMonthlyTotals(period, _currency);
}
