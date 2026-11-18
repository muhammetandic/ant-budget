import 'package:drift/drift.dart';
import 'package:ant_budget/core/values/currency.dart';
import 'package:ant_budget/core/values/debt_type.dart';

/// Drift table storing debts and claims.
@DataClassName('DebtDto')
class Debts extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Person associated with the debt or claim.
  TextColumn get person => text().withLength(min: 1, max: 120)();

  /// Amount in minor units (kuruş/cents), matching the [Money] value object.
  IntColumn get amountMinorUnits => integer()();

  TextColumn get currency => textEnum<Currency>()();

  /// Whether this is a debt (user owes) or claim (user is owed).
  TextColumn get type => textEnum<DebtType>()();

  /// Date of the debt/claim.
  DateTimeColumn get dueDate => dateTime()();

  /// Whether the debt or claim has been settled/cleared.
  BoolColumn get isSettled => boolean().withDefault(const Constant(false))();

  /// Creation timestamp.
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
