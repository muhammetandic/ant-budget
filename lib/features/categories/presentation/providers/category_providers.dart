import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ant_budget/features/categories/data/providers/category_data_providers.dart';
import 'package:ant_budget/features/categories/domain/entities/category.dart';
import 'package:ant_budget/features/categories/domain/usecases/delete_category_usecase.dart';
import 'package:ant_budget/features/categories/domain/usecases/save_category_usecase.dart';
import 'package:ant_budget/features/categories/domain/usecases/watch_categories_usecase.dart';
import 'package:ant_budget/features/categories/domain/usecases/watch_category_usage_usecase.dart';

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

/// Number of transactions filed under each category, keyed by category id.
///
/// The management screen renders this so the user can see *why* a category
/// cannot be deleted before they try.
@riverpod
Stream<Map<int, int>> categoryUsage(Ref ref) =>
    ref.watch(watchCategoryUsageUseCaseProvider)();

@riverpod
WatchCategoryUsageUseCase watchCategoryUsageUseCase(Ref ref) =>
    WatchCategoryUsageUseCase(ref.watch(categoryRepositoryProvider));

@riverpod
SaveCategoryUseCase saveCategoryUseCase(Ref ref) =>
    SaveCategoryUseCase(ref.watch(categoryRepositoryProvider));

@riverpod
DeleteCategoryUseCase deleteCategoryUseCase(Ref ref) =>
    DeleteCategoryUseCase(ref.watch(categoryRepositoryProvider));
