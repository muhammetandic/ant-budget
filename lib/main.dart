import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_budget_tracker/app/app.dart';
import 'package:smart_budget_tracker/app/app_composition.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ProviderScope(
      overrides: appProviderOverrides,
      child: const SmartBudgetApp(),
    ),
  );
}
