import 'package:ant_budget/core/error/failure.dart';
import 'package:ant_budget/core/error/result.dart';
import 'package:ant_budget/core/values/unit.dart';
import 'package:ant_budget/features/categories/data/datasources/category_dao.dart';
import 'package:ant_budget/features/categories/data/mappers/category_mapper.dart';
import 'package:ant_budget/features/categories/domain/entities/category.dart';
import 'package:ant_budget/features/categories/domain/repositories/category_repository.dart';

/// Drift backed implementation of [CategoryRepository].
///
/// Its only job is orchestration: delegate to the DAO, map rows to entities and
/// turn thrown driver errors into [Failure]s. No business rule lives here.
final class CategoryRepositoryImpl implements CategoryRepository {
  CategoryRepositoryImpl(this._dao);

  final CategoryDao _dao;

  @override
  Stream<List<Category>> watchAll() => _dao.watchAll().map(
    (rows) => rows.map(CategoryMapper.toDomain).toList(growable: false),
  );

  @override
  Stream<Map<int, int>> watchUsageCounts() => _dao.watchUsageCounts();

  @override
  Future<Result<int, Failure>> save(Category category) => Result.attemptAsync(
    () => _dao.save(
      CategoryMapper.toWriteCompanion(category),
      id: category.id,
    ),
  );

  @override
  Future<Result<int, Failure>> countTransactions(int categoryId) =>
      Result.attemptAsync(() => _dao.countTransactions(categoryId));

  @override
  Future<Result<Unit, Failure>> deleteById(int id) => Result.attemptAsync(
    () async {
      await _dao.deleteById(id);
      return Unit.instance;
    },
  );

  @override
  Future<Result<bool, Failure>> deleteIfUnused(int id) =>
      Result.attemptAsync(() => _dao.deleteIfUnused(id));
}
