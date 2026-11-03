import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ant_budget/app/app.dart';
import 'package:ant_budget/app/app_composition.dart';
import 'package:ant_budget/app/router/app_router.dart';
import 'package:ant_budget/app/router/app_routes.dart';
import 'package:ant_budget/core/data/database/app_database.dart';
import 'package:ant_budget/core/providers/database_providers.dart';
import 'package:ant_budget/features/categories/data/datasources/default_category_seeder.dart';

void main() {
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

  Future<void> shutDown(WidgetTester tester, AppDatabase database) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(Duration.zero);
    await tester.runAsync(database.close);
  }

  testWidgets(
    'redirects editTransaction to transactions when extra is missing',
    (tester) async {
      final database = await boot(tester);
      final router = ProviderScope.containerOf(
        tester.element(find.byType(SmartBudgetApp)),
      ).read(appRouterProvider);

      router.go(AppRoutes.editTransaction);
      await tester.pumpAndSettle();

      expect(
        router.routerDelegate.currentConfiguration.uri.path,
        AppRoutes.transactions,
      );

      await shutDown(tester, database);
    },
  );

  testWidgets(
    'redirects receiptReview to scan when extra is missing or empty',
    (tester) async {
      final database = await boot(tester);
      final router = ProviderScope.containerOf(
        tester.element(find.byType(SmartBudgetApp)),
      ).read(appRouterProvider);

      router.go(AppRoutes.receiptReview);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(
        router.routerDelegate.currentConfiguration.uri.path,
        AppRoutes.scan,
      );

      await shutDown(tester, database);
    },
  );
}
