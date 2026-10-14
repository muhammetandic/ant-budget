import 'package:ant_budget/core/error/failure.dart';
import 'package:ant_budget/core/error/result.dart';
import 'package:ant_budget/core/values/money.dart';
import 'package:ant_budget/core/values/unit.dart';
import 'package:ant_budget/core/values/year_month.dart';
import 'package:ant_budget/features/budget/data/datasources/budget_dao.dart';
import 'package:ant_budget/features/budget/data/mappers/budget_mapper.dart';
import 'package:ant_budget/features/budget/domain/entities/budget.dart';
import 'package:ant_budget/features/budget/domain/repositories/budget_repository.dart';

/// Drift backed implementation of [BudgetRepository].
final class BudgetRepositoryImpl implements BudgetRepository {
  BudgetRepositoryImpl(this._dao);

  final BudgetDao _dao;

  @override
  Stream<Budget?> watchFor(YearMonth period) =>
      _dao.watchFor(period).map((dto) => dto == null ? null : BudgetMapper.toDomain(dto));

  @override
  Future<Result<Unit, Failure>> setLimit({
    required YearMonth period,
    required Money limit,
  }) => Result.attemptAsync(() async {
    await _dao.upsertLimit(period: period, limit: limit);
    return Unit.instance;
  });
}
