import 'package:drift/drift.dart';
import 'package:smart_budget_tracker/core/data/database/tables/categories_table.dart';
import 'package:smart_budget_tracker/core/values/currency.dart';
import 'package:smart_budget_tracker/core/values/transaction_kind.dart';
import 'package:smart_budget_tracker/core/values/transaction_source.dart';

/// Drift table storing every recorded transaction.
@DataClassName('TransactionDto')
class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Amount in minor units (kuruş/cents), matching the `Money` value object.
  IntColumn get amountMinorUnits => integer()();

  TextColumn get currency => textEnum<Currency>()();

  TextColumn get kind => textEnum<TransactionKind>()();

  TextColumn get description =>
      text().withLength(min: 0, max: 160).withDefault(const Constant(''))();

  DateTimeColumn get occurredAt => dateTime()();

  IntColumn get categoryId => integer().references(Categories, #id)();

  TextColumn get source => textEnum<TransactionSource>()();

  /// Merchant name extracted from a scanned receipt, when applicable.
  TextColumn get receiptMerchant => text().nullable()();

  /// Path of the captured receipt image, kept for later review/audit.
  TextColumn get receiptImagePath => text().nullable()();
}
