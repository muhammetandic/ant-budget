import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ant_budget/core/data/database/app_database.dart';
import 'package:ant_budget/core/providers/database_providers.dart';
import 'package:ant_budget/core/values/currency.dart';
import 'package:ant_budget/core/values/money.dart';
import 'package:ant_budget/core/values/transaction_kind.dart';
import 'package:ant_budget/core/values/year_month.dart';
import 'package:ant_budget/features/categories/data/datasources/default_category_seeder.dart';
import 'package:ant_budget/features/transactions/data/mappers/transaction_mapper.dart';
import 'package:ant_budget/features/transactions/domain/entities/transaction.dart';
import 'package:ant_budget/features/transactions/presentation/widgets/transaction_list.dart';
import 'package:ant_budget/l10n/l10n.dart';

/// What the user sees: swiping a transaction away asks first, and only a
/// confirmation actually deletes it.
void main() {
  /// Boots the list over a database holding one transaction of this month.
  Future<AppDatabase> pumpList(WidgetTester tester) async {
    final database = AppDatabase(
      NativeDatabase.memory(),
      seeders: const [DefaultCategorySeeder()],
    );
    await database
        .into(database.transactions)
        .insert(
          TransactionMapper.toCompanion(
            Transaction(
              amount: Money(12050, Currency.turkishLira),
              categoryId: 1,
              occurredAt: DateTime.now(),
              kind: TransactionKind.expense,
              description: 'Kahve',
            ),
          ),
        );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(database)],
        child: MaterialApp(
          locale: const Locale('tr'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: TransactionList(period: YearMonth.current())),
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

  testWidgets('keeps the transaction when the deletion is cancelled', (
    tester,
  ) async {
    final database = await pumpList(tester);

    await tester.drag(find.text('Kahve'), const Offset(-500, 0));
    await tester.pumpAndSettle();

    expect(find.text('İşlem silinsin mi?'), findsOneWidget);
    expect(
      find.text('Kahve silinsin mi? Bu işlem geri alınamaz.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Vazgeç'));
    await tester.pumpAndSettle();

    // The row sprang back and is still there.
    expect(find.text('Kahve'), findsOneWidget);
    expect(await database.select(database.transactions).get(), hasLength(1));

    await shutDown(tester, database);
  });

  testWidgets('deletes the transaction once the deletion is confirmed', (
    tester,
  ) async {
    final database = await pumpList(tester);

    await tester.drag(find.text('Kahve'), const Offset(-500, 0));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sil'));
    await tester.pumpAndSettle();

    expect(await database.select(database.transactions).get(), isEmpty);
    expect(find.text('İşlem silindi.'), findsOneWidget);

    await shutDown(tester, database);
  });
}
