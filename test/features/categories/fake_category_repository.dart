import 'package:ant_budget/core/error/failure.dart';
import 'package:ant_budget/core/error/result.dart';
import 'package:ant_budget/core/values/unit.dart';
import 'package:ant_budget/features/categories/domain/entities/category.dart';
import 'package:ant_budget/features/categories/domain/repositories/category_repository.dart';

/// Hand written [CategoryRepository] proving the category use cases need no
/// database, exactly like `_FakeTransactionRepository` does for transactions.
final class FakeCategoryRepository implements CategoryRepository {
  /// Transactions the fake reports per category id.
  final Map<int, int> usage = {};

  /// Categories handed to [save], in call order.
  final List<Category> saved = [];

  /// Ids handed to [deleteById], in call order.
  final List<int> deleted = [];

  /// Set to make [countTransactions] fail instead of answering.
  Failure? countFailure;

  int saveResult = 7;

  @override
  Stream<List<Category>> watchAll() => Stream.value(const []);

  @override
  Stream<Map<int, int>> watchUsageCounts() => Stream.value(usage);

  @override
  Future<Result<int, Failure>> save(Category category) async {
    saved.add(category);
    return Result.success(saveResult);
  }

  @override
  Future<Result<int, Failure>> countTransactions(int categoryId) async {
    final failure = countFailure;
    if (failure != null) return Result.failure(failure);
    return Result.success(usage[categoryId] ?? 0);
  }

  @override
  Future<Result<Unit, Failure>> deleteById(int id) async {
    deleted.add(id);
    return Result.success(Unit.instance);
  }
}
