import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ant_budget/core/data/database/app_database.dart';
import 'package:ant_budget/core/values/currency.dart';

/// The path a device really takes: a v1 database (before category budgets)
/// upgraded in place to v2.
///
/// The v1 schema is written by hand into a fresh in-memory connection before
/// drift opens it, so the upgrade runs exactly as it will on the phone — and
/// the row counts afterwards prove nothing was dropped on the way.
void main() {
  test(
    'upgrades v1 in place and cascades a category delete into budgets',
    () async {
      final database = AppDatabase(
        NativeDatabase.memory(setup: seedV1Database),
      );

      // The rows that existed in v1 are still there after the upgrade.
      final transactions = await database.select(database.transactions).get();
      expect(transactions.single.amountMinorUnits, 12050);
      final limits = await database.select(database.budgets).get();
      expect(limits.single.limitMinorUnits, 200000);

      // The upgraded schema accepts writes into the new table.
      await database
          .into(database.categoryBudgets)
          .insert(
            CategoryBudgetsCompanion.insert(
              year: 2026,
              month: 10,
              categoryId: 2,
              limitMinorUnits: 50000,
              currency: Currency.turkishLira,
            ),
          );
      expect(
        await database.select(database.categoryBudgets).get(),
        hasLength(1),
      );

      // Deleting a category takes its budget with it — the cascade the
      // `PRAGMA foreign_keys` in `beforeOpen` arms.
      await (database.delete(
        database.categories,
      )..where((c) => c.id.equals(2))).go();
      expect(await database.select(database.categoryBudgets).get(), isEmpty);

      // The category still holding a transaction was left alone.
      expect(await database.select(database.categories).get(), hasLength(1));

      await database.close();
    },
  );
}

/// Creates the schema and the rows the app shipped before v2 existed.
///
/// `raw` is the `package:sqlite3` connection drift opens the database with; it
/// is typed loosely so the test needs no dependency beyond drift itself.
void seedV1Database(dynamic raw) {
  raw.execute('''
    CREATE TABLE "categories" (
      "id" INTEGER PRIMARY KEY AUTOINCREMENT,
      "name" TEXT NOT NULL CHECK (length("name") BETWEEN 1 AND 60),
      "icon" TEXT NOT NULL,
      "color_value" INTEGER NOT NULL,
      "is_default" INTEGER NOT NULL DEFAULT 0
    );
  ''');
  raw.execute('''
    CREATE TABLE "budgets" (
      "id" INTEGER PRIMARY KEY AUTOINCREMENT,
      "year" INTEGER NOT NULL,
      "month" INTEGER NOT NULL,
      "limit_minor_units" INTEGER NOT NULL,
      "currency" TEXT NOT NULL,
      UNIQUE ("year", "month")
    );
  ''');
  raw.execute('''
    CREATE TABLE "transactions" (
      "id" INTEGER PRIMARY KEY AUTOINCREMENT,
      "amount_minor_units" INTEGER NOT NULL,
      "currency" TEXT NOT NULL,
      "kind" TEXT NOT NULL,
      "description" TEXT NOT NULL DEFAULT '',
      "occurred_at" INTEGER NOT NULL,
      "category_id" INTEGER NOT NULL REFERENCES "categories" ("id"),
      "source" TEXT NOT NULL,
      "receipt_merchant" TEXT,
      "receipt_image_path" TEXT
    );
  ''');
  raw.execute("PRAGMA user_version = 1");

  raw.execute(
    "INSERT INTO categories (id, name, icon, color_value) VALUES "
    "(1, 'Groceries', 'groceries', 781652312), "
    "(2, 'Shopping', 'shopping', 4436267);",
  );
  raw.execute(
    "INSERT INTO transactions "
    "(amount_minor_units, currency, kind, occurred_at, category_id, source) "
    "VALUES (12050, 'turkishLira', 'expense', 1760000000000, 1, 'manual');",
  );
  raw.execute(
    "INSERT INTO budgets (year, month, limit_minor_units, currency) "
    "VALUES (2026, 10, 200000, 'turkishLira');",
  );
}
