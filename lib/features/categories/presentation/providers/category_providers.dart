import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ant_budget/features/categories/data/providers/category_data_providers.dart';
import 'package:ant_budget/features/categories/domain/entities/category.dart';
import 'package:ant_budget/features/categories/domain/usecases/watch_categories_usecase.dart';

part 'category_providers.g.dart';

/// Use case provider: the presentation asks for *behaviour*, never for the
/// repository directly.
@riverpod
WatchCategoriesUseCase watchCategoriesUseCase(Ref ref) =>
    WatchCategoriesUseCase(ref.watch(categoryRepositoryProvider));

/// All categories, reactively.
///
/// Auto-disposing: the stream is only subscribed while a screen listens to it,
/// so leaving every category-consuming screen releases the query.
@riverpod
Stream<List<Category>> categories(Ref ref) =>
    ref.watch(watchCategoriesUseCaseProvider)();

/// Categories indexed by id for O(1) lookups while building lists.
///
/// Derived state: it recomputes whenever [categoriesProvider] emits, so screens
/// only render and never join collections themselves.
@riverpod
Map<int, Category> categoryIndex(Ref ref) {
  final categories = ref.watch(categoriesProvider).value ?? const [];
  final index = <int, Category>{};
  for (final category in categories) {
    final id = category.id;
    if (id != null) index[id] = category;
  }
  return index;
}
