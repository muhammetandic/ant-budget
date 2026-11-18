import 'package:flutter_test/flutter_test.dart';
import 'package:ant_budget/core/config/app_config.dart';
import 'package:ant_budget/core/error/failure.dart';
import 'package:ant_budget/core/values/debt_type.dart';
import 'package:ant_budget/core/values/money.dart';
import 'package:ant_budget/features/debts/domain/entities/debt_entry.dart';
import 'package:ant_budget/features/debts/domain/usecases/save_debt_usecase.dart';

import 'fake_debt_repository.dart';

void main() {
  late FakeDebtRepository repository;
  late SaveDebtUseCase useCase;

  setUp(() {
    repository = FakeDebtRepository();
    useCase = SaveDebtUseCase(repository);
  });

  DebtEntry entry({
    String person = 'Alice',
    int minorUnits = 50000,
    DebtType type = DebtType.claim,
  }) => DebtEntry(
    person: person,
    amount: Money(minorUnits, AppConfig.reportingCurrency),
    type: type,
    dueDate: DateTime(2026, 11, 14),
  );

  test('saves valid debt entry and returns its id', () async {
    final result = await useCase(entry());

    expect(result.valueOrNull, 1);
    expect(repository.saved.single.person, 'Alice');
    expect(repository.saved.single.amount.minorUnits, 50000);
  });

  test('trims whitespace from person name', () async {
    await useCase(entry(person: '   Bob Smith   '));

    expect(repository.saved.single.person, 'Bob Smith');
  });

  test('rejects empty person name', () async {
    final result = await useCase(entry(person: '   '));

    expect(
      result.failureOrNull,
      isA<ValidationFailure>().having(
        (f) => f.issue,
        'issue',
        ValidationIssue.personEmpty,
      ),
    );
    expect(repository.saved, isEmpty);
  });

  test('rejects zero or negative amount', () async {
    final zeroResult = await useCase(entry(minorUnits: 0));
    final negativeResult = await useCase(entry(minorUnits: -100));

    expect(
      zeroResult.failureOrNull,
      isA<ValidationFailure>().having(
        (f) => f.issue,
        'issue',
        ValidationIssue.amountNotPositive,
      ),
    );
    expect(
      negativeResult.failureOrNull,
      isA<ValidationFailure>().having(
        (f) => f.issue,
        'issue',
        ValidationIssue.amountNotPositive,
      ),
    );
    expect(repository.saved, isEmpty);
  });
}
