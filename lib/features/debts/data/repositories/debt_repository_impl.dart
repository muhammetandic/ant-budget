import 'package:ant_budget/core/error/failure.dart';
import 'package:ant_budget/core/error/result.dart';
import 'package:ant_budget/core/values/unit.dart';
import 'package:ant_budget/features/debts/data/datasources/debt_dao.dart';
import 'package:ant_budget/features/debts/data/mappers/debt_mapper.dart';
import 'package:ant_budget/features/debts/domain/entities/debt_entry.dart';
import 'package:ant_budget/features/debts/domain/repositories/debt_repository.dart';

/// Drift-backed implementation of [DebtRepository].
final class DebtRepositoryImpl implements DebtRepository {
  DebtRepositoryImpl(this._dao);

  final DebtDao _dao;

  @override
  Stream<List<DebtEntry>> watchAll() => _dao.watchAll().map(
    (rows) => rows.map(DebtMapper.toDomain).toList(growable: false),
  );

  @override
  Future<Result<int, Failure>> save(DebtEntry entry) => Result.attemptAsync(
    () => _dao.save(DebtMapper.toWriteCompanion(entry), id: entry.id),
  );

  @override
  Future<Result<Unit, Failure>> deleteById(int id) =>
      Result.attemptAsync(() async {
        await _dao.deleteById(id);
        return Unit.instance;
      });

  @override
  Future<Result<Unit, Failure>> toggleSettled(int id, bool isSettled) =>
      Result.attemptAsync(() async {
        await _dao.setSettled(id, isSettled);
        return Unit.instance;
      });
}
