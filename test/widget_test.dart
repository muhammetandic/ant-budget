import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ant_budget/app/app.dart';
import 'package:ant_budget/app/app_composition.dart';
import 'package:ant_budget/core/data/database/app_database.dart';
import 'package:ant_budget/core/providers/database_providers.dart';
import 'package:ant_budget/features/categories/data/datasources/default_category_seeder.dart';

void main() {
  /// Boots the production tree against an in-memory, freshly seeded database, so
  /// neither path_provider nor the on-disk file is touched.
  Future<AppDatabase> boot(WidgetTester tester) async {
    final database = AppDatabase(
      NativeDatabase.memory(),
      seeders: const [DefaultCategorySeeder()],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          ...appProviderOverrides,
          appDatabaseProvider.overrideWithValue(database),
        ],
        child: const SmartBudgetApp(),
      ),
    );
    await tester.pump(Duration.zero);
    return database;
  }

  /// Tears the tree down *inside* the test so Riverpod cancels its drift stream
  /// subscriptions here, then elapses the fake clock so drift's zero-duration
  /// "keep the query cache a little longer" timers run. Without this,
  /// `flutter_test` would still see them pending after the test. The database is
  /// closed on the real event loop, because drift's remaining stream bookkeeping
  /// must not run against the fake clock.
  Future<void> shutDown(WidgetTester tester, AppDatabase database) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(Duration.zero);
    await tester.runAsync(database.close);
  }

  testWidgets('boots to the overview screen in English', (tester) async {
    tester.platformDispatcher.localesTestValue = const [Locale('en')];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);

    final database = await boot(tester);

    expect(find.text('Ant Budget'), findsOneWidget);
    expect(find.text('Overview'), findsOneWidget);
    expect(find.text('₺0.00'), findsWidgets);

    await shutDown(tester, database);
  });

  testWidgets('renders Turkish when the device speaks Turkish', (tester) async {
    tester.platformDispatcher.localesTestValue = const [Locale('tr')];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);

    final database = await boot(tester);

    expect(find.text('Genel Bakış'), findsOneWidget);
    expect(find.text('Gider'), findsOneWidget);
    // Amounts and month headers follow the language, not just the labels.
    expect(find.text('₺0,00'), findsWidgets);
    expect(find.text('Ekim 2026'), findsOneWidget);

    await shutDown(tester, database);
  });

  testWidgets('creates a category from the categories tab', (tester) async {
    tester.platformDispatcher.localesTestValue = const [Locale('tr')];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);

    final database = await boot(tester);

    await tester.tap(find.text('Kategoriler'));
    await tester.pumpAndSettle();

    // The seeded categories are translated and carry no transactions yet.
    expect(find.text('Market'), findsOneWidget);
    expect(find.text('İşlem yok'), findsWidgets);

    await tester.tap(find.text('Ekle'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Kira');
    await tester.tap(find.text('Kaydet'));
    await tester.pumpAndSettle();

    expect(find.text('Kira'), findsOneWidget);
    expect(find.text('Kategori kaydedildi.'), findsOneWidget);

    await shutDown(tester, database);
  });

  testWidgets('edits a seeded category without losing its stored name', (
    tester,
  ) async {
    tester.platformDispatcher.localesTestValue = const [Locale('tr')];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);

    final database = await boot(tester);

    await tester.tap(find.text('Kategoriler'));
    await tester.pumpAndSettle();

    // "Market" is the Turkish label of the seeded "Groceries".
    await tester.tap(find.text('Market'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(TextField, 'Market'), findsOneWidget);

    await tester.tap(find.text('Kaydet'));
    await tester.pumpAndSettle();

    // Saving the untouched form must not overwrite the English key the label is
    // translated from, or the category would stop following the language.
    final names = (await database.select(database.categories).get())
        .map((row) => row.name);
    expect(names, contains('Groceries'));
    expect(names, isNot(contains('Market')));

    await shutDown(tester, database);
  });

  testWidgets('falls back to Turkish for a language the app does not ship', (
    tester,
  ) async {
    tester.platformDispatcher.localesTestValue = const [Locale('de')];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);

    final database = await boot(tester);

    expect(find.text('Genel Bakış'), findsOneWidget);

    await shutDown(tester, database);
  });
}
