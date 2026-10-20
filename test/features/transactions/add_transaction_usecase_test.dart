import 'package:flutter_test/flutter_test.dart';
import 'package:ant_budget/core/error/failure.dart';
import 'package:ant_budget/core/error/result.dart';
import 'package:ant_budget/core/values/currency.dart';
import 'package:ant_budget/core/values/money.dart';
import 'package:ant_budget/core/values/transaction_kind.dart';
import 'package:ant_budget/core/values/unit.dart';
import 'package:ant_budget/core/values/year_month.dart';
import 'package:ant_budget/features/transactions/domain/entities/transaction.dart';
import 'package:ant_budget/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:ant_budget/features/transactions/domain/usecases/add_transaction_usecase.dart';
import 'package:ant_budget/features/transactions/domain/values/add_transaction_command.dart';
import 'package:ant_budget/features/transactions/domain/values/monthly_totals.dart';
import 'package:ant_budget/features/transactions/domain/values/transaction_filter.dart';

/// Hand written fake: proves the use case is testable without a database.
final class _FakeTransactionRepository implements TransactionRepository {
  final List<Transaction> saved = [];
  final List<Transaction> updated = [];

  @override
  Stream<List<Transaction>> watch(TransactionFilter filter) =>
      Stream.value(const []);

  @override
  Stream<MonthlyTotals> watchMonthlyTotals(YearMonth period, Currency currency) =>
      Stream.value(MonthlyTotals.empty(period, currency));

  @override
  Stream<Map<int, Money>> watchExpenseTotalsByCategory(
    YearMonth period,
    Currency currency,
  ) => Stream.value(const <int, Money>{});

  @override
  Future<Result<int, Failure>> save(Transaction transaction) async {
    saved.add(transaction);
    return Result.success(saved.length);
  }

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
  late AddTransactionUseCase useCase;

  setUp(() {
    repository = _FakeTransactionRepository();
    useCase = AddTransactionUseCase(repository);
  });

  AddTransactionCommand command({int minorUnits = 1000, int categoryId = 1}) =>
      AddTransactionCommand(
        amount: Money(minorUnits, Currency.turkishLira),
        categoryId: categoryId,
        occurredAt: DateTime(2026, 10, 14),
        kind: TransactionKind.expense,
      );

  test('saves a valid command through the repository', () async {
    final result = await useCase(command());

    expect(result.isOk, isTrue);
    expect(repository.saved, hasLength(1));
    expect(repository.saved.single.kind, TransactionKind.expense);
  });

  test('rejects a non positive amount before touching storage', () async {
    final result = await useCase(command(minorUnits: 0));

    expect(result.failureOrNull, isA<ValidationFailure>());
    expect(repository.saved, isEmpty);
  });

  test('rejects a missing category before touching storage', () async {
    final result = await useCase(command(categoryId: 0));

    expect(result.failureOrNull, isA<ValidationFailure>());
    expect(repository.saved, isEmpty);
  });
}
