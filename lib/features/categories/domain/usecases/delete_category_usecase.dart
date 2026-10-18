import 'package:ant_budget/core/error/failure.dart';
import 'package:ant_budget/core/error/result.dart';
import 'package:ant_budget/core/values/unit.dart';
import 'package:ant_budget/features/categories/domain/repositories/category_repository.dart';

/// Deletes a category, as long as no transaction is filed under it.
///
/// Every transaction points at a category, so dropping one that is still in use
/// would leave unreadable history. The user has to move or delete those
/// transactions first, which keeps the ledger consistent without the app having
/// to invent a replacement category.
final class DeleteCategoryUseCase {
  const DeleteCategoryUseCase(this._repository);

  /// Shown when the category is still referenced by transactions.
  static const ValidationFailure _inUse = ValidationFailure(
    message: 'This category still has transactions.',
    issue: ValidationIssue.categoryInUse,
  );

  final CategoryRepository _repository;

  Future<Result<Unit, Failure>> call(int categoryId) async {
    if (categoryId <= 0) {
      return Result.failure(
        NotFoundFailure(
          message: 'That category no longer exists.',
          entityType: 'category',
          entityId: categoryId,
        ),
      );
    }

    final counted = await _repository.countTransactions(categoryId);
    return counted.fold<Future<Result<Unit, Failure>>>(
      (failure) async => Result.failure(failure),
      (count) async => count > 0
          ? Result.failure(_inUse)
          : await _repository.deleteById(categoryId),
    );
  }
}
