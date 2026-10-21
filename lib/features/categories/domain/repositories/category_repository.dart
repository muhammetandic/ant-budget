import 'package:ant_budget/core/error/failure.dart';
import 'package:ant_budget/core/error/result.dart';
import 'package:ant_budget/core/values/unit.dart';
import 'package:ant_budget/features/categories/domain/entities/category.dart';

/// Port describing how the domain reads and writes categories.
abstract interface class CategoryRepository {
  /// Emits every category, alphabetically ordered, and re-emits on writes.
  Stream<List<Category>> watchAll();

  /// Emits how many transactions reference each category, keyed by category id,
  /// and re-emits whenever the categories or the transactions change.
  Stream<Map<int, int>> watchUsageCounts();

  /// Inserts [category], or updates the stored one when it already carries an
  /// id, and returns the row id.
  Future<Result<int, Failure>> save(Category category);

  /// Deletes the category with [id].
  Future<Result<Unit, Failure>> deleteById(int id);

  /// Deletes [id] only when no transaction references it, atomically.
  ///
  /// Returns `false` when the category is still in use.
  Future<Result<bool, Failure>> deleteIfUnused(int id);

  /// How many transactions currently reference the category with [categoryId].
  Future<Result<int, Failure>> countTransactions(int categoryId);
}
