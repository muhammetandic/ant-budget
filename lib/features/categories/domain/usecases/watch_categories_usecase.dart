import 'package:smart_budget_tracker/features/categories/domain/entities/category.dart';
import 'package:smart_budget_tracker/features/categories/domain/repositories/category_repository.dart';

/// Streams all categories available for assignment.
final class WatchCategoriesUseCase {
  const WatchCategoriesUseCase(this._repository);

  final CategoryRepository _repository;

  Stream<List<Category>> call() => _repository.watchAll();
}
