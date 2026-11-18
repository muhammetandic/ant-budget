import 'package:ant_budget/core/error/failure.dart';
import 'package:ant_budget/core/error/result.dart';
import 'package:ant_budget/features/debts/domain/entities/debt_entry.dart';
import 'package:ant_budget/features/debts/domain/repositories/debt_repository.dart';

/// Validates invariants and persists a debt or claim.
class SaveDebtUseCase {
  const SaveDebtUseCase(this._repository);

  final DebtRepository _repository;

  Future<Result<int, Failure>> call(DebtEntry entry) async {
    final person = entry.person.trim();
    if (person.isEmpty) {
      return const Result.err(
        ValidationFailure(
          message: 'Enter a person name.',
          issue: ValidationIssue.personEmpty,
          field: 'person',
        ),
      );
    }

    if (!entry.amount.isPositive) {
      return const Result.err(
        ValidationFailure(
          message: 'Enter an amount greater than zero.',
          issue: ValidationIssue.amountNotPositive,
          field: 'amount',
        ),
      );
    }

    return _repository.save(entry.copyWith(person: person));
  }
}
