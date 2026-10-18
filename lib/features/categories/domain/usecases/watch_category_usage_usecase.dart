import 'package:ant_budget/features/categories/domain/repositories/category_repository.dart';

/// Streams how many transactions each category is used by.
///
/// The list screen shows this next to every category so the reason a category
/// cannot be deleted is visible *before* the user tries.
final class WatchCategoryUsageUseCase {
  const WatchCategoryUsageUseCase(this._repository);

  final CategoryRepository _repository;

  Stream<Map<int, int>> call() => _repository.watchUsageCounts();
}
