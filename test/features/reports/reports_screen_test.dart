import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ant_budget/app/app_composition.dart';
import 'package:ant_budget/core/data/database/app_database.dart';
import 'package:ant_budget/core/providers/database_providers.dart';
import 'package:ant_budget/core/values/currency.dart';
import 'package:ant_budget/core/values/money.dart';
import 'package:ant_budget/core/values/transaction_kind.dart';
import 'package:ant_budget/features/categories/data/datasources/default_category_seeder.dart';
import 'package:ant_budget/features/reports/presentation/screens/reports_screen.dart';
import 'package:ant_budget/features/transactions/data/mappers/transaction_mapper.dart';
import 'package:ant_budget/features/transactions/domain/entities/transaction.dart';
import 'package:ant_budget/l10n/l10n.dart';

/// What the user sees: the report of the selected month, split by category and
/// by shop, with income and other months left out of the numbers.
void main() {
  /// Boots the screen in Turkish against a freshly seeded, in-memory database.
  Future<AppDatabase> pumpReport(
    WidgetTester tester, {
    List<Transaction> rows = const [],
  }) async {
    final database = AppDatabase(
      NativeDatabase.memory(),
      seeders: const [DefaultCategorySeeder()],
    );
    for (final row in rows) {
      await database
          .into(database.transactions)
          .insert(TransactionMapper.toCompanion(row));
    }

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          ...appProviderOverrides,
          appDatabaseProvider.overrideWithValue(database),
        ],
        child: MaterialApp(
          locale: const Locale('tr'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: ReportsScreen()),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return database;
  }

  /// Closes the tree inside the test so Riverpod cancels its drift streams
  /// before the fake clock stops (see `widget_test.dart`).
  Future<void> shutDown(WidgetTester tester, AppDatabase database) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(Duration.zero);
    await tester.runAsync(database.close);
  }

  Transaction expense({
    required int minorUnits,
    required int categoryId,
    DateTime? occurredAt,
    String? merchant,
    TransactionKind kind = TransactionKind.expense,
  }) => Transaction(
    amount: Money(minorUnits, Currency.turkishLira),
    categoryId: categoryId,
    occurredAt: occurredAt ?? DateTime.now(),
    kind: kind,
    receiptMerchant: merchant,
  );

  testWidgets('shows expenses by category and by shop for the current month', (
    tester,
  ) async {
    final database = await pumpReport(
      tester,
      rows: [
        expense(minorUnits: 12000, categoryId: 1, merchant: 'ŞOK'),
        expense(
          minorUnits: 4000,
          categoryId: 1,
          merchant: 'sok market',
          occurredAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        // A hand written entry without a shop: counted, but not attributed.
        expense(minorUnits: 4000, categoryId: 2),
        // Income never reaches the report.
        expense(
          minorUnits: 50000,
          categoryId: 8,
          merchant: 'ACME',
          kind: TransactionKind.income,
        ),
        // Another month is another report.
        expense(
          minorUnits: 9999,
          categoryId: 1,
          merchant: 'OLD',
          occurredAt: DateTime(2000, 1, 1),
        ),
      ],
    );

    expect(find.text('Toplam gider'), findsOneWidget);
    // Total of the summary row and of the donut's hole.
    expect(find.text('₺200,00'), findsWidgets);
    expect(find.text('Kategoriye göre giderler'), findsOneWidget);
    expect(find.text('İşyerine göre giderler'), findsOneWidget);

    // Groceries: 12.000 + 4.000 = 16.000 of 20.000, two transactions.
    expect(find.text('Market'), findsOneWidget);
    expect(find.text('Yemek'), findsOneWidget);
    expect(find.text('2 işlem'), findsWidgets);
    expect(find.text('%80'), findsWidgets);
    expect(find.text('%20'), findsWidgets);

    // Both spellings of the chain landed in one row, labelled with the one the
    // user saw most recently; the income's shop never appears.
    expect(find.text('ŞOK'), findsOneWidget);
    expect(find.text('ACME'), findsNothing);
    expect(find.text('₺500,00'), findsNothing);
    expect(find.text('₺99,99'), findsNothing);

    await shutDown(tester, database);
  });

  testWidgets('reports a month without expenses as empty', (tester) async {
    final database = await pumpReport(
      tester,
      rows: [
        expense(
          minorUnits: 50000,
          categoryId: 8,
          merchant: 'ACME',
          kind: TransactionKind.income,
        ),
      ],
    );

    expect(find.text('Bu ay için gider kaydı yok.'), findsOneWidget);
    expect(find.text('Kategoriye göre giderler'), findsNothing);

    await shutDown(tester, database);
  });

  testWidgets('says so when no expense carries a shop', (tester) async {
    final database = await pumpReport(
      tester,
      rows: [expense(minorUnits: 4000, categoryId: 2)],
    );

    expect(find.text('Toplam gider'), findsOneWidget);
    expect(find.text('İşyeri bilgisi olan gider kaydı yok.'), findsOneWidget);

    await shutDown(tester, database);
  });
}
