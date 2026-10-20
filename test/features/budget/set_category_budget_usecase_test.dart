import 'package:flutter_test/flutter_test.dart';
import 'package:ant_budget/core/error/failure.dart';
import 'package:ant_budget/core/values/currency.dart';
import 'package:ant_budget/core/values/money.dart';
import 'package:ant_budget/core/values/unit.dart';
import 'package:ant_budget/core/values/year_month.dart';
import 'package:ant_budget/features/budget/domain/usecases/set_category_budget_usecase.dart';

import 'fake_budget_repository.dart';

void main() {
  late FakeBudgetRepository repository;
  late SetCategoryBudgetUseCase useCase;

  final month = YearMonth(2026, 10);
  Money money(int minorUnits) => Money(minorUnits, Currency.turkishLira);

  setUp(() {
    repository = FakeBudgetRepository();
    useCase = SetCategoryBudgetUseCase(repository);
  });

  test('stores a valid limit for the category of the month', () async {
    final result = await useCase(
      period: month,
      categoryId: 3,
      limit: money(50_000),
    );

    expect(result.valueOrNull, Unit.instance);
    expect(repository.categoryLimits, [(3, money(50_000))]);
  });

  test('rejects a limit that is zero without touching storage', () async {
    final result = await useCase(period: month, categoryId: 3, limit: money(0));

    expect(
      result.failureOrNull,
      isA<ValidationFailure>().having(
        (failure) => failure.issue,
        'issue',
        ValidationIssue.budgetNotPositive,
      ),
    );
    expect(repository.categoryLimits, isEmpty);
  });

  test('rejects a limit in a currency the report does not use', () async {
    final result = await useCase(
      period: month,
      categoryId: 3,
      limit: const Money(100, Currency.usDollar),
    );

    expect(
      result.failureOrNull,
      isA<ValidationFailure>().having(
        (failure) => failure.issue,
        'issue',
        ValidationIssue.budgetCurrencyMismatch,
      ),
    );
    expect(repository.categoryLimits, isEmpty);
  });
}
