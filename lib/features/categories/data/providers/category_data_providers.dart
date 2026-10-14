import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ant_budget/core/providers/database_providers.dart';
import 'package:ant_budget/features/categories/data/datasources/category_dao.dart';
import 'package:ant_budget/features/categories/data/repositories/category_repository_impl.dart';
import 'package:ant_budget/features/categories/domain/repositories/category_repository.dart';

part 'category_data_providers.g.dart';

/// Dependency wiring of the categories data layer.
@riverpod
CategoryDao categoryDao(Ref ref) => CategoryDao(ref.watch(appDatabaseProvider));

/// The category repository abstraction injected into the domain use cases.
@riverpod
CategoryRepository categoryRepository(Ref ref) =>
    CategoryRepositoryImpl(ref.watch(categoryDaoProvider));
