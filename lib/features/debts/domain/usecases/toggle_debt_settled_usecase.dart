import 'package:ant_budget/core/error/failure.dart';
import 'package:ant_budget/core/error/result.dart';
import 'package:ant_budget/core/values/unit.dart';
import 'package:ant_budget/features/debts/domain/repositories/debt_repository.dart';

/// Marks a debt or claim as settled or pending.
class ToggleDebtSettledUseCase {
  const ToggleDebtSettledUseCase(this._repository);

  final DebtRepository _repository;

  Future<Result<Unit, Failure>> call(int id, bool isSettled) =>
      _repository.toggleSettled(id, isSettled);
}
