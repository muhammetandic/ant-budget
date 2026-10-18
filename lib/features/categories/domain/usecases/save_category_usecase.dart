import 'package:ant_budget/core/error/failure.dart';
import 'package:ant_budget/core/error/result.dart';
import 'package:ant_budget/features/categories/domain/entities/category.dart';
import 'package:ant_budget/features/categories/domain/repositories/category_repository.dart';

/// Validates a category and stores it, creating or updating as needed.
///
/// Whether a category is *allowed* to be created or edited is a business rule,
/// so it lives here rather than in the form that collects the fields.
final class SaveCategoryUseCase {
  const SaveCategoryUseCase(this._repository);

  /// Longest name the `categories` table accepts.
  static const int maxNameLength = 60;

  final CategoryRepository _repository;

  Future<Result<int, Failure>> call(Category category) {
    final name = category.name.trim();
    if (name.isEmpty) {
      return Future.value(
        Result.failure(
          const ValidationFailure(
            message: 'A category needs a name.',
            issue: ValidationIssue.categoryNameEmpty,
            field: 'name',
          ),
        ),
      );
    }
    if (name.length > maxNameLength) {
      return Future.value(
        Result.failure(
          ValidationFailure(
            message: 'The name must be $maxNameLength characters or fewer.',
            issue: ValidationIssue.categoryNameTooLong,
            field: 'name',
          ),
        ),
      );
    }

    // The domain normalises the name, so two spellings of the same input cannot
    // end up stored side by side.
    return _repository.save(
      Category(
        id: category.id,
        name: name,
        icon: category.icon,
        colorValue: category.colorValue,
        isDefault: category.isDefault,
      ),
    );
  }
}
