import 'package:ant_budget/core/error/failure.dart';
import 'package:ant_budget/core/error/result.dart';
import 'package:ant_budget/core/values/unit.dart';
import 'package:ant_budget/features/debts/domain/repositories/debt_repository.dart';

/// Deletes a debt or claim by ID.
class DeleteDebtUseCase {
  const DeleteDebtUseCase(this._repository);

  final DebtRepository _repository;

  Future<Result<Unit, Failure>> call(int id) => _repository.deleteById(id);
}
