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
import 'package:ant_budget/features/receipt_scan/domain/entities/scanned_receipt.dart';
import 'package:ant_budget/features/receipt_scan/presentation/widgets/receipt_review_form.dart';
import 'package:ant_budget/features/transactions/data/mappers/transaction_mapper.dart';
import 'package:ant_budget/features/transactions/domain/entities/transaction.dart';
import 'package:ant_budget/l10n/l10n.dart';

/// What the user actually sees: the review form opens with the category of the
/// scanned shop already selected.
void main() {
  /// Pumps the review form for a receipt from [merchantName] against an
  /// in-memory database, optionally already holding [past] transactions.
  Future<AppDatabase> pumpForm(
    WidgetTester tester,
    String? merchantName, {
    List<Transaction> past = const [],
  }) async {
    final database = AppDatabase(
      NativeDatabase.memory(),
      seeders: const [DefaultCategorySeeder()],
    );
    for (final transaction in past) {
      await database
          .into(database.transactions)
          .insert(TransactionMapper.toCompanion(transaction));
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
          home: Scaffold(
            body: ReceiptReviewForm(
              receipt: ScannedReceipt(
                total: const Money(29390, Currency.turkishLira),
                purchasedAt: DateTime(2026, 10, 16),
                merchantName: merchantName,
              ),
              imagePath: '/no/such/receipt.jpg',
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return database;
  }

  /// The database id the category dropdown is currently showing.
  int? selectedCategory(WidgetTester tester) => tester
      .state<FormFieldState<int>>(find.byType(DropdownButtonFormField<int>))
      .value;

  /// Closes the tree inside the test so Riverpod cancels its drift streams
  /// before the fake clock stops (see `widget_test.dart`).
  Future<void> shutDown(WidgetTester tester, AppDatabase database) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(Duration.zero);
    await tester.runAsync(database.close);
  }

  Transaction filed(String merchant, int categoryId) => Transaction(
    amount: const Money(1000, Currency.turkishLira),
    categoryId: categoryId,
    occurredAt: DateTime(2026, 10, 14),
    kind: TransactionKind.expense,
    receiptMerchant: merchant,
  );

  testWidgets('preselects the category of the scanned shop', (tester) async {
    final database = await pumpForm(tester, 'ŞOK');

    // ŞOK is a grocery shop, and the seeded "Groceries" is id 1.
    expect(selectedCategory(tester), 1);

    await shutDown(tester, database);
  });

  testWidgets('preselects the category the shop was filed under', (
    tester,
  ) async {
    // "Shopping" is id 4 of the seeded categories.
    final database = await pumpForm(
      tester,
      'Yıldız Bakkal',
      past: [filed('Yıldız Bakkal', 4)],
    );

    expect(selectedCategory(tester), 4);

    await shutDown(tester, database);
  });

  testWidgets('leaves the dropdown empty for an unknown shop', (tester) async {
    final database = await pumpForm(tester, 'Yıldız Bakkal');

    expect(selectedCategory(tester), isNull);

    await shutDown(tester, database);
  });
}
