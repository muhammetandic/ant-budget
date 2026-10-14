import 'package:drift/native.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_budget_tracker/app/app.dart';
import 'package:smart_budget_tracker/app/app_composition.dart';
import 'package:smart_budget_tracker/core/data/database/app_database.dart';
import 'package:smart_budget_tracker/core/providers/database_providers.dart';

void main() {
  testWidgets('boots to the overview screen', (tester) async {
    final database = AppDatabase(NativeDatabase.memory());

    await tester.pumpWidget(
      ProviderScope(
        // Production wiring, plus an in-memory database so the test never
        // touches path_provider or the on-disk file.
        overrides: [
          ...appProviderOverrides,
          appDatabaseProvider.overrideWithValue(database),
        ],
        child: const SmartBudgetApp(),
      ),
    );
    await tester.pump(Duration.zero);

    expect(find.text('Smart Budget Tracker'), findsOneWidget);

    // Tear the tree down *inside* the test so Riverpod cancels its drift stream
    // subscriptions here, then elapse the fake clock so drift's zero-duration
    // "keep the query cache a little longer" timers run. Without this,
    // `flutter_test` would still see them pending after the test.
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(Duration.zero);

    // Close the in-memory database on the real event loop: drift's remaining
    // stream bookkeeping must not run against the fake clock.
    await tester.runAsync(database.close);
  });
}
