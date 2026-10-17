import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ant_budget/app/app.dart';
import 'package:ant_budget/app/app_composition.dart';
import 'package:ant_budget/features/receipt_scan/data/services/scan_replay_runner.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Diagnostics-only branch: it is dead code in a normal build because
  // `ScanReplayRunner.enabled` is a `const` false unless the app was built with
  // `--dart-define=ANT_SCAN_DIAGNOSTICS=true`.
  if (ScanReplayRunner.enabled) {
    final container = ProviderContainer(overrides: appProviderOverrides);
    runApp(
      UncontrolledProviderScope(
        container: container,
        child: const SmartBudgetApp(),
      ),
    );
    unawaited(ScanReplayRunner(container).runIfRequested());
    return;
  }

  runApp(
    ProviderScope(
      overrides: appProviderOverrides,
      child: const SmartBudgetApp(),
    ),
  );
}
