import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:ant_budget/core/config/app_config.dart';
import 'package:ant_budget/core/values/debt_type.dart';
import 'package:ant_budget/core/values/money.dart';
import 'package:ant_budget/features/debts/domain/entities/debt_entry.dart';

/// Aggregated totals for debts and claims.
@immutable
class DebtSummary extends Equatable {
  const DebtSummary({
    required this.totalClaims,
    required this.totalDebts,
    required this.netBalance,
  });

  factory DebtSummary.empty() {
    final zero = Money.zero(AppConfig.reportingCurrency);
    return DebtSummary(totalClaims: zero, totalDebts: zero, netBalance: zero);
  }

  factory DebtSummary.fromEntries(List<DebtEntry> entries) {
    final currency = AppConfig.reportingCurrency;
    var claims = 0;
    var debts = 0;

    for (final entry in entries) {
      if (entry.isSettled) continue;
      if (entry.type == DebtType.claim) {
        claims += entry.amount.minorUnits;
      } else {
        debts += entry.amount.minorUnits;
      }
    }

    return DebtSummary(
      totalClaims: Money(claims, currency),
      totalDebts: Money(debts, currency),
      netBalance: Money(claims - debts, currency),
    );
  }

  final Money totalClaims;
  final Money totalDebts;
  final Money netBalance;

  @override
  List<Object?> get props => [totalClaims, totalDebts, netBalance];
}
