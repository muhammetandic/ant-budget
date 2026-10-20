import 'package:flutter_test/flutter_test.dart';
import 'package:ant_budget/core/error/failure.dart';
import 'package:ant_budget/core/error/result.dart';
import 'package:ant_budget/core/values/currency.dart';
import 'package:ant_budget/core/values/money.dart';
import 'package:ant_budget/core/values/transaction_kind.dart';
import 'package:ant_budget/core/values/transaction_source.dart';
import 'package:ant_budget/core/values/unit.dart';
import 'package:ant_budget/core/values/year_month.dart';
import 'package:ant_budget/features/transactions/domain/entities/transaction.dart';
import 'package:ant_budget/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:ant_budget/features/transactions/domain/usecases/update_transaction_usecase.dart';
import 'package:ant_budget/features/transactions/domain/values/monthly_totals.dart';
import 'package:ant_budget/features/transactions/domain/values/transaction_filter.dart';

/// Hand written fake: an edit must reach storage as a single update call.
final class _FakeTransactionRepository implements TransactionRepository {
  final List<Transaction> updated = [];

  @override
  Stream<List<Transaction>> watch(TransactionFilter filter) =>
      Stream.value(const []);

  @override
  Stream<MonthlyTotals> watchMonthlyTotals(
    YearMonth period,
    Currency currency,
  ) => Stream.value(MonthlyTotals.empty(period, currency));

  @override
  Stream<Map<int, Money>> watchExpenseTotalsByCategory(
    YearMonth period,
    Currency currency,
  ) => Stream.value(const <int, Money>{});

  @override
  Future<Result<int, Failure>> save(Transaction transaction) async =>
      Result.success(1);

  @override
  Future<Result<int, Failure>> update(Transaction transaction) async {
    updated.add(transaction);
    return Result.success(transaction.id ?? 0);
  }

  @override
  Future<Result<Unit, Failure>> deleteById(int id) async =>
      Result.success(Unit.instance);
}

void main() {
  late _FakeTransactionRepository repository;
  late UpdateTransactionUseCase useCase;

  setUp(() {
    repository = _FakeTransactionRepository();
    useCase = UpdateTransactionUseCase(repository);
  });

  Transaction transaction({
    int? id = 7,
    int minorUnits = 1000,
    int categoryId = 1,
    String description = 'Coffee',
  }) => Transaction(
    id: id,
    amount: Money(minorUnits, Currency.turkishLira),
    categoryId: categoryId,
    occurredAt: DateTime(2026, 10, 14),
    kind: TransactionKind.expense,
    description: description,
    source: TransactionSource.manual,
  );

  test('replaces a stored transaction through the repository', () async {
    final result = await useCase(transaction());

    expect(result.isOk, isTrue);
    expect(repository.updated, hasLength(1));
    expect(repository.updated.single.id, 7);
    expect(repository.updated.single.description, 'Coffee');
  });

  test('trims the description, like storing a new one does', () async {
    await useCase(transaction(description: '  Coffee  '));

    expect(repository.updated.single.description, 'Coffee');
  });

  test('keeps the receipt provenance of a scanned transaction', () async {
    await useCase(
      Transaction(
        id: 7,
        amount: Money(1000, Currency.turkishLira),
        categoryId: 1,
        occurredAt: DateTime(2026, 10, 14),
        kind: TransactionKind.expense,
        source: TransactionSource.receiptScan,
        receiptMerchant: 'Migros',
        receiptImagePath: '/tmp/receipt.jpg',
      ),
    );

    final updated = repository.updated.single;
    expect(updated.source, TransactionSource.receiptScan);
    expect(updated.receiptMerchant, 'Migros');
    expect(updated.receiptImagePath, '/tmp/receipt.jpg');
  });

  test('rejects an entity that was never stored', () async {
    final result = await useCase(transaction(id: null));

    expect(result.failureOrNull, isA<NotFoundFailure>());
    expect(repository.updated, isEmpty);
  });

  test('rejects a non positive amount before touching storage', () async {
    final result = await useCase(transaction(minorUnits: 0));

    expect(result.failureOrNull, isA<ValidationFailure>());
    expect(repository.updated, isEmpty);
  });

  test('rejects a missing category before touching storage', () async {
    final result = await useCase(transaction(categoryId: 0));

    expect(result.failureOrNull, isA<ValidationFailure>());
    expect(repository.updated, isEmpty);
  });

  test('rejects an over long description before touching storage', () async {
    final result = await useCase(transaction(description: 'a' * 161));

    expect(result.failureOrNull, isA<ValidationFailure>());
    expect(repository.updated, isEmpty);
  });
}
