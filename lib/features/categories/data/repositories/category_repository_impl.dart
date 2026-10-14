import 'package:smart_budget_tracker/features/categories/data/datasources/category_dao.dart';
import 'package:smart_budget_tracker/features/categories/data/mappers/category_mapper.dart';
import 'package:smart_budget_tracker/features/categories/domain/entities/category.dart';
import 'package:smart_budget_tracker/features/categories/domain/repositories/category_repository.dart';

/// Drift backed implementation of [CategoryRepository].
final class CategoryRepositoryImpl implements CategoryRepository {
  CategoryRepositoryImpl(this._dao);

  final CategoryDao _dao;

  @override
  Stream<List<Category>> watchAll() => _dao.watchAll().map(
    (rows) => rows.map(CategoryMapper.toDomain).toList(growable: false),
  );
}
