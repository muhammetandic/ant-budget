import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ant_budget/core/data/database/app_database.dart';
import 'package:ant_budget/core/providers/database_providers.dart';
import 'package:ant_budget/features/debts/presentation/screens/debts_screen.dart';
import 'package:ant_budget/features/debts/presentation/widgets/debt_form_sheet.dart';
import 'package:ant_budget/features/debts/presentation/widgets/debt_list_tile.dart';
import 'package:ant_budget/l10n/l10n.dart';

void main() {
  Future<AppDatabase> pumpDebts(WidgetTester tester) async {
    final database = AppDatabase(NativeDatabase.memory());
    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(database)],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: DebtsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return database;
  }

  Future<void> shutDown(WidgetTester tester, AppDatabase database) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(Duration.zero);
    await tester.runAsync(database.close);
  }

  testWidgets('displays empty state initially', (tester) async {
    final db = await pumpDebts(tester);

    expect(find.byIcon(Icons.handshake_outlined), findsOneWidget);
    expect(find.byType(DebtListTile), findsNothing);

    await shutDown(tester, db);
  });

  testWidgets('adds a new claim and marks it settled', (tester) async {
    final db = await pumpDebts(tester);

    // Tap FAB
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    expect(find.byType(DebtFormSheet), findsOneWidget);

    // Fill Person and Amount
    final textFields = find.byType(TextField);
    await tester.enterText(textFields.at(0), 'John Doe');
    await tester.enterText(textFields.at(1), '150');
    await tester.pumpAndSettle();

    // Tap Save
    final saveButton = find.widgetWithText(FilledButton, 'Save');
    await tester.ensureVisible(saveButton);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    expect(find.byType(DebtFormSheet), findsNothing);

    // Verify tile appears
    expect(find.byType(DebtListTile), findsOneWidget);
    expect(find.widgetWithText(DebtListTile, 'John Doe'), findsOneWidget);

    // Toggle settled
    final checkButton = find.widgetWithIcon(
      IconButton,
      Icons.radio_button_unchecked,
    );
    expect(checkButton, findsOneWidget);

    await tester.tap(checkButton);
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.check_circle), findsOneWidget);

    await shutDown(tester, db);
  });
}
