import 'package:drift/drift.dart';
import 'package:ant_budget/core/data/database/app_database.dart';
import 'package:ant_budget/core/values/money.dart';
import 'package:ant_budget/features/debts/domain/entities/debt_entry.dart';

/// Translates between database rows and domain [DebtEntry]s.
abstract final class DebtMapper {
  static DebtEntry toDomain(DebtDto row) => DebtEntry(
    id: row.id,
    person: row.person,
    amount: Money(row.amountMinorUnits, row.currency),
    type: row.type,
    dueDate: row.dueDate,
    isSettled: row.isSettled,
    createdAt: row.createdAt,
  );

  static DebtsCompanion toWriteCompanion(DebtEntry entity) => DebtsCompanion(
    id: entity.id == null ? const Value.absent() : Value(entity.id!),
    person: Value(entity.person.trim()),
    amountMinorUnits: Value(entity.amount.minorUnits),
    currency: Value(entity.amount.currency),
    type: Value(entity.type),
    dueDate: Value(entity.dueDate),
    isSettled: Value(entity.isSettled),
    createdAt: Value(entity.createdAt),
  );
}
