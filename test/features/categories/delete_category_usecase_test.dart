import 'package:flutter_test/flutter_test.dart';
import 'package:ant_budget/core/error/failure.dart';
import 'package:ant_budget/features/categories/domain/usecases/delete_category_usecase.dart';

import 'fake_category_repository.dart';

void main() {
  late FakeCategoryRepository repository;
  late DeleteCategoryUseCase useCase;

  setUp(() {
    repository = FakeCategoryRepository();
    useCase = DeleteCategoryUseCase(repository);
  });

  test('deletes a category nothing points at', () async {
    final result = await useCase(4);

    expect(result.isOk, isTrue);
    expect(repository.deleted, [4]);
  });

  test('refuses to delete a category transactions still use', () async {
    repository.usage[4] = 3;

    final result = await useCase(4);

    expect(
      result.failureOrNull,
      isA<ValidationFailure>().having(
        (failure) => failure.issue,
        'issue',
        ValidationIssue.categoryInUse,
      ),
    );
    expect(repository.deleted, isEmpty);
  });

  test('rejects an id that cannot be stored', () async {
    final result = await useCase(0);

    expect(result.failureOrNull, isA<NotFoundFailure>());
    expect(repository.deleted, isEmpty);
  });

  test('propagates a failure from counting the usages', () async {
    repository.countFailure = const StorageFailure(message: 'disk');

    final result = await useCase(4);

    expect(result.failureOrNull, isA<StorageFailure>());
    expect(repository.deleted, isEmpty);
  });
}
