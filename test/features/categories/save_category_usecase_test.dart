import 'package:flutter_test/flutter_test.dart';
import 'package:ant_budget/core/error/failure.dart';
import 'package:ant_budget/core/values/category_icon.dart';
import 'package:ant_budget/features/categories/domain/entities/category.dart';
import 'package:ant_budget/features/categories/domain/usecases/save_category_usecase.dart';

import 'fake_category_repository.dart';

void main() {
  late FakeCategoryRepository repository;
  late SaveCategoryUseCase useCase;

  setUp(() {
    repository = FakeCategoryRepository();
    useCase = SaveCategoryUseCase(repository);
  });

  Category category({String name = 'Market', int? id, bool isDefault = false}) =>
      Category(
        id: id,
        name: name,
        icon: CategoryIcon.groceries,
        colorValue: 0xFF2E7D32,
        isDefault: isDefault,
      );

  test('stores a valid category and returns its id', () async {
    final result = await useCase(category());

    expect(result.valueOrNull, 7);
    expect(repository.saved.single.name, 'Market');
  });

  test('trims the name before it reaches the repository', () async {
    await useCase(category(name: '  Market  '));

    expect(repository.saved.single.name, 'Market');
  });

  test('rejects a blank name without touching storage', () async {
    final result = await useCase(category(name: '   '));

    expect(
      result.failureOrNull,
      isA<ValidationFailure>().having(
        (failure) => failure.issue,
        'issue',
        ValidationIssue.categoryNameEmpty,
      ),
    );
    expect(repository.saved, isEmpty);
  });

  test('rejects a name longer than the column allows', () async {
    final result = await useCase(
      category(name: 'a' * (SaveCategoryUseCase.maxNameLength + 1)),
    );

    expect(
      result.failureOrNull,
      isA<ValidationFailure>().having(
        (failure) => failure.issue,
        'issue',
        ValidationIssue.categoryNameTooLong,
      ),
    );
    expect(repository.saved, isEmpty);
  });

  test('keeps the id and the default flag when editing', () async {
    await useCase(category(id: 3, name: 'Market', isDefault: true));

    expect(repository.saved.single.id, 3);
    expect(repository.saved.single.isDefault, isTrue);
  });
}
