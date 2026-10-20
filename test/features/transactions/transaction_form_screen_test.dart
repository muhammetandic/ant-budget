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
import 'package:ant_budget/core/values/transaction_source.dart';
import 'package:ant_budget/features/categories/data/datasources/default_category_seeder.dart';
import 'package:ant_budget/features/transactions/data/mappers/transaction_mapper.dart';
import 'package:ant_budget/features/transactions/domain/entities/transaction.dart';
import 'package:ant_budget/features/transactions/presentation/screens/transaction_form_screen.dart';
import 'package:ant_budget/l10n/l10n.dart';

/// What the user sees: opening a stored transaction fills the form with its
/// values, and saving overwrites that same row instead of adding a new one.
void main() {
  /// Boots the form against a fresh database holding [rows], returning it.
  Future<AppDatabase> pumpForm(
    WidgetTester tester,
    Transaction? initial, {
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
          home: TransactionFormScreen(initial: initial),
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

  testWidgets('records a new transaction when opened without one', (
    tester,
  ) async {
    final database = await pumpForm(tester, null);

    expect(find.text('İşlem ekle'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).first, '250,75');
    await tester.tap(find.byType(DropdownButtonFormField<int>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Market').last);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).last, 'Kahve');
    await tester.tap(find.text('Kaydet'));
    await tester.pumpAndSettle();

    final stored = await database.select(database.transactions).get();
    expect(stored, hasLength(1));
    expect(stored.single.amountMinorUnits, 25075);
    expect(stored.single.categoryId, 1);
    expect(stored.single.description, 'Kahve');

    await shutDown(tester, database);
  });

  testWidgets('prefills the form and overwrites the stored row', (
    tester,
  ) async {
    final stored = Transaction(
      id: 1,
      amount: Money(12050, Currency.turkishLira),
      categoryId: 2,
      occurredAt: DateTime(2026, 10, 14),
      kind: TransactionKind.expense,
      description: 'Akşam yemeği',
      source: TransactionSource.receiptScan,
      receiptMerchant: 'Migros',
      receiptImagePath: '/tmp/receipt.jpg',
    );
    final database = await pumpForm(tester, stored, rows: [stored]);

    expect(find.text('İşlemi düzenle'), findsOneWidget);
    // The stored amount is shown with Turkish separators and no symbol.
    expect(find.text('120,50'), findsOneWidget);
    expect(find.text('Akşam yemeği'), findsOneWidget);

    // Change the description and the amount, then save.
    await tester.enterText(find.byType(TextFormField).first, '300');
    await tester.enterText(
      find.byType(TextFormField).last,
      'Market alışverişi',
    );
    await tester.tap(find.text('Kaydet'));
    await tester.pumpAndSettle();

    final rows = await database.select(database.transactions).get();
    expect(rows, hasLength(1));
    expect(rows.single.id, 1);
    expect(rows.single.amountMinorUnits, 30000);
    expect(rows.single.description, 'Market alışverişi');
    // Editing a scanned transaction keeps its provenance.
    expect(rows.single.receiptMerchant, 'Migros');
    expect(rows.single.receiptImagePath, '/tmp/receipt.jpg');

    await shutDown(tester, database);
  });
}
