import 'package:ant_budget/features/debts/domain/entities/debt_entry.dart';
import 'package:ant_budget/features/debts/domain/repositories/debt_repository.dart';

/// Streams every recorded debt and claim.
class WatchDebtsUseCase {
  const WatchDebtsUseCase(this._repository);

  final DebtRepository _repository;

  Stream<List<DebtEntry>> call() => _repository.watchAll();
}
