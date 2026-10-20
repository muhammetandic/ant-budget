import 'package:flutter_test/flutter_test.dart';
import 'package:ant_budget/core/values/unit.dart';
import 'package:ant_budget/core/values/year_month.dart';
import 'package:ant_budget/features/budget/domain/usecases/delete_category_budget_usecase.dart';

import 'fake_budget_repository.dart';

void main() {
  late FakeBudgetRepository repository;
  late DeleteCategoryBudgetUseCase useCase;

  final month = YearMonth(2026, 10);

  setUp(() {
    repository = FakeBudgetRepository();
    useCase = DeleteCategoryBudgetUseCase(repository);
  });

  test('removes the budget of that category and month', () async {
    final result = await useCase(period: month, categoryId: 4);

    expect(result.valueOrNull, Unit.instance);
    expect(repository.deleted, [(month, 4)]);
  });

  test('succeeds when nothing was stored in the first place', () async {
    final result = await useCase(period: month, categoryId: 4);

    expect(result.failureOrNull, isNull);
  });
}
