import 'package:flutter_test/flutter_test.dart';
import 'package:ant_budget/core/values/currency.dart';
import 'package:ant_budget/core/values/money.dart';
import 'package:ant_budget/core/values/year_month.dart';
import 'package:ant_budget/features/reports/domain/repositories/expense_report_repository.dart';
import 'package:ant_budget/features/reports/domain/usecases/watch_expense_breakdown_usecase.dart';
import 'package:ant_budget/features/reports/domain/values/expense_group.dart';

/// Hand written fake: proves the report is shaped by this use case alone, with
/// no database behind it — the same trick the other use case tests use.
final class _FakeReportRepository implements ExpenseReportRepository {
  _FakeReportRepository(this.groups);

  /// Buckets the next emission hands back.
  List<ExpenseGroup> groups;

  /// Arguments of the last subscription, so the wiring itself is asserted.
  YearMonth? lastPeriod;
  Currency? lastCurrency;

  @override
  Stream<List<ExpenseGroup>> watchExpenseGroups({
    required YearMonth period,
    required Currency currency,
  }) {
    lastPeriod = period;
    lastCurrency = currency;
    return Stream.value(groups);
  }
}

void main() {
  const currency = Currency.turkishLira;
  final period = YearMonth(2026, 10);

  late _FakeReportRepository repository;
  late WatchExpenseBreakdownUseCase useCase;

  setUp(() {
    repository = _FakeReportRepository(const []);
    useCase = WatchExpenseBreakdownUseCase(repository, currency);
  });

  /// One bucket of the shape the DAO produces.
  ExpenseGroup bucket({
    required int categoryId,
    required int minorUnits,
    String? merchant,
    int transactions = 1,
    DateTime? lastOccurredAt,
  }) => ExpenseGroup(
    categoryId: categoryId,
    merchant: merchant,
    amount: Money(minorUnits, currency),
    transactions: transactions,
    lastOccurredAt: lastOccurredAt ?? DateTime(2026, 10, 5),
  );

  test(
    'subscribes to the expenses of the month and reporting currency',
    () async {
      repository.groups = [bucket(categoryId: 1, minorUnits: 100)];

      await useCase(period).first;

      expect(repository.lastPeriod, period);
      expect(repository.lastCurrency, currency);
    },
  );

  test('sums the month and orders both dimensions by amount', () async {
    repository.groups = [
      bucket(categoryId: 1, minorUnits: 2500, transactions: 2),
      bucket(categoryId: 1, minorUnits: 1000, transactions: 1),
      bucket(categoryId: 2, minorUnits: 6500, merchant: 'Migros'),
    ];

    final report = await useCase(period).first;

    expect(report.period, period);
    expect(report.total, const Money(10000, currency));

    // The two Groceries buckets collapse into one slice, biggest first.
    expect(report.byCategory, hasLength(2));
    expect(report.byCategory.first.categoryId, 2);
    expect(report.byCategory.first.amount, const Money(6500, currency));
    expect(report.byCategory.first.share, closeTo(0.65, 1e-9));
    expect(report.byCategory.last.categoryId, 1);
    expect(report.byCategory.last.transactions, 3);
    expect(report.byCategory.last.share, closeTo(0.35, 1e-9));
  });

  test('leaves entries without a shop out of the merchant dimension', () async {
    repository.groups = [
      bucket(categoryId: 1, minorUnits: 2500),
      bucket(categoryId: 2, minorUnits: 6500, merchant: 'Migros'),
    ];

    final report = await useCase(period).first;

    expect(report.byMerchant, hasLength(1));
    expect(report.byMerchant.single.merchant, 'Migros');
    expect(report.byMerchant.single.share, closeTo(0.7222, 1e-3));
  });

  test(
    'merges the spellings of one shop and labels it with the newest',
    () async {
      repository.groups = [
        bucket(
          categoryId: 1,
          minorUnits: 3000,
          merchant: 'ŞOK',
          lastOccurredAt: DateTime(2026, 10, 6),
        ),
        bucket(
          categoryId: 1,
          minorUnits: 2000,
          merchant: 'sok market',
          lastOccurredAt: DateTime(2026, 10, 12),
        ),
        bucket(categoryId: 2, minorUnits: 5000, merchant: 'BİM'),
      ];

      final report = await useCase(period).first;

      // 'ŞOK' and 'sok market' are one shop, so the chain keeps both receipts in
      // one row, while the supermarket stays its own row.
      expect(report.byMerchant, hasLength(2));
      expect(report.byMerchant.first.merchant, 'BİM');
      expect(report.byMerchant.first.amount, const Money(5000, currency));

      final chain = report.byMerchant.last;
      expect(chain.merchant, 'sok market');
      expect(chain.amount, const Money(5000, currency));
      expect(chain.transactions, 2);
      expect(chain.share, closeTo(0.5, 1e-9));
    },
  );

  test(
    'breaks amount ties by category id so the report never reshuffles',
    () async {
      repository.groups = [
        bucket(categoryId: 3, minorUnits: 1000),
        bucket(categoryId: 1, minorUnits: 1000),
      ];

      final report = await useCase(period).first;

      expect([for (final slice in report.byCategory) slice.categoryId], [1, 3]);
    },
  );

  test('reports a month without expenses as empty', () async {
    final report = await useCase(period).first;

    expect(report.isEmpty, isTrue);
    expect(report.total, const Money(0, currency));
    expect(report.byCategory, isEmpty);
    expect(report.byMerchant, isEmpty);
  });
}
