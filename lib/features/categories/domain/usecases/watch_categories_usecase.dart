import 'package:ant_budget/features/categories/domain/entities/category.dart';
import 'package:ant_budget/features/categories/domain/repositories/category_repository.dart';

/// Streams all categories available for assignment.
final class WatchCategoriesUseCase {
  const WatchCategoriesUseCase(this._repository);

  final CategoryRepository _repository;

  Stream<List<Category>> call() => _repository.watchAll();
}
