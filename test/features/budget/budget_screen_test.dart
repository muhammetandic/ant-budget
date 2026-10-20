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
import 'package:ant_budget/core/values/year_month.dart';
import 'package:ant_budget/features/budget/presentation/screens/budget_screen.dart';
import 'package:ant_budget/features/budget/presentation/widgets/category_budget_delete_button.dart';
import 'package:ant_budget/features/budget/presentation/widgets/category_budget_form.dart';
import 'package:ant_budget/features/budget/presentation/widgets/category_budget_tile.dart';
import 'package:ant_budget/features/categories/data/datasources/default_category_seeder.dart';
import 'package:ant_budget/features/transactions/data/mappers/transaction_mapper.dart';
import 'package:ant_budget/features/transactions/domain/entities/transaction.dart';
import 'package:ant_budget/l10n/l10n.dart';

/// What the user sees: a category budget typed into the sheet appears as a
/// tile with the month's spending against the limit, and can be removed again.
void main() {
  /// Boots the budget screen in Turkish against a freshly seeded database.
  Future<AppDatabase> pumpBudget(
    WidgetTester tester, {
    List<Transaction> rows = const [],
    List<({int categoryId, int limitMinorUnits})> budgets = const [],
  }) async {
    final database = AppDatabase(
      NativeDatabase.memory(),
      seeders: const [DefaultCategorySeeder()],
    );
    final month = YearMonth.current();
    for (final row in rows) {
      await database
          .into(database.transactions)
          .insert(TransactionMapper.toCompanion(row));
    }
    for (final budget in budgets) {
      await database
          .into(database.categoryBudgets)
          .insert(
            CategoryBudgetsCompanion.insert(
              year: month.year,
              month: month.month,
              categoryId: budget.categoryId,
              limitMinorUnits: budget.limitMinorUnits,
              currency: Currency.turkishLira,
            ),
          );
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
          home: const BudgetScreen(),
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

  Transaction expense({required int minorUnits, required int categoryId}) =>
      Transaction(
        amount: Money(minorUnits, Currency.turkishLira),
        categoryId: categoryId,
        occurredAt: DateTime.now(),
        kind: TransactionKind.expense,
      );

  testWidgets('sets a category budget and shows the spending against it', (
    tester,
  ) async {
    final database = await pumpBudget(
      tester,
      rows: [expense(minorUnits: 12050, categoryId: 1)],
    );

    expect(
      find.text('Bu ay için kategori bütçesi belirlenmedi.'),
      findsOneWidget,
    );

    // Pick the first category (Groceries -> "Market" in Turkish) and cap it.
    await tester.tap(find.byTooltip('Kategori bütçesi ekle'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(DropdownButtonFormField<int>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Market').last);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, '500');
    await tester.tap(
      find.descendant(
        of: find.byType(CategoryBudgetForm),
        matching: find.text('Kaydet'),
      ),
    );
    await tester.pumpAndSettle();

    // The sheet closed and the tile reports the month's spending: the seeded
    // category 1 is Groceries, 120,50 spent of a 500,00 limit.
    expect(find.byType(CategoryBudgetForm), findsNothing);
    expect(find.text('₺120,50'), findsOneWidget);
    expect(find.text('₺500,00 limit'), findsOneWidget);
    expect(find.text('₺379,50 kaldı'), findsOneWidget);

    final stored = await database.select(database.categoryBudgets).get();
    expect(stored, hasLength(1));
    expect(stored.single.categoryId, 1);
    expect(stored.single.limitMinorUnits, 50000);

    await shutDown(tester, database);
  });

  testWidgets('reopens a stored budget from its tile, prefilled', (
    tester,
  ) async {
    final database = await pumpBudget(
      tester,
      rows: [expense(minorUnits: 12050, categoryId: 1)],
      budgets: [(categoryId: 1, limitMinorUnits: 50000)],
    );

    // The tile is there with its health line.
    expect(find.text('₺120,50'), findsOneWidget);
    expect(find.text('₺500,00 limit'), findsOneWidget);

    // Tapping it reopens the form with the stored limit in the field.
    await tester.tap(find.byType(CategoryBudgetTile));
    await tester.pumpAndSettle();

    final amountField = tester.widget<TextFormField>(
      find.descendant(
        of: find.byType(CategoryBudgetForm),
        matching: find.byType(TextFormField),
      ),
    );
    expect(amountField.controller?.text, '500,00');

    // The delete affordance is offered for a stored budget.
    expect(find.byType(CategoryBudgetDeleteButton), findsOneWidget);

    await shutDown(tester, database);
  });
}
