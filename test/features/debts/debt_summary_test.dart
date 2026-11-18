import 'package:flutter_test/flutter_test.dart';
import 'package:ant_budget/core/config/app_config.dart';
import 'package:ant_budget/core/values/debt_type.dart';
import 'package:ant_budget/core/values/money.dart';
import 'package:ant_budget/features/debts/domain/entities/debt_entry.dart';
import 'package:ant_budget/features/debts/domain/values/debt_summary.dart';

void main() {
  final currency = AppConfig.reportingCurrency;

  test('calculates correct totals and ignores settled items', () {
    final entries = [
      DebtEntry(
        id: 1,
        person: 'Alice',
        amount: Money(10000, currency), // 100.00 claim
        type: DebtType.claim,
        dueDate: DateTime(2026, 11, 14),
      ),
      DebtEntry(
        id: 2,
        person: 'Bob',
        amount: Money(3000, currency), // 30.00 debt
        type: DebtType.debt,
        dueDate: DateTime(2026, 11, 14),
      ),
      DebtEntry(
        id: 3,
        person: 'Charlie',
        amount: Money(5000, currency), // 50.00 claim settled
        type: DebtType.claim,
        dueDate: DateTime(2026, 11, 14),
        isSettled: true,
      ),
    ];

    final summary = DebtSummary.fromEntries(entries);

    expect(summary.totalClaims, Money(10000, currency));
    expect(summary.totalDebts, Money(3000, currency));
    expect(summary.netBalance, Money(7000, currency));
  });

  test('empty entries produce zero summary', () {
    final summary = DebtSummary.empty();

    expect(summary.totalClaims.isZero, isTrue);
    expect(summary.totalDebts.isZero, isTrue);
    expect(summary.netBalance.isZero, isTrue);
  });
}
