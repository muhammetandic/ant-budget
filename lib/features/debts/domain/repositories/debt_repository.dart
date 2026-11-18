import 'package:ant_budget/core/error/failure.dart';
import 'package:ant_budget/core/error/result.dart';
import 'package:ant_budget/core/values/unit.dart';
import 'package:ant_budget/features/debts/domain/entities/debt_entry.dart';

/// Port describing how the domain reads and writes debts and claims.
abstract interface class DebtRepository {
  /// Emits all debts and claims, ordered by settled status and date.
  Stream<List<DebtEntry>> watchAll();

  /// Inserts [entry], or updates the stored row when it carries an id.
  Future<Result<int, Failure>> save(DebtEntry entry);

  /// Deletes the entry with [id].
  Future<Result<Unit, Failure>> deleteById(int id);

  /// Updates settled state of entry with [id].
  Future<Result<Unit, Failure>> toggleSettled(int id, bool isSettled);
}
