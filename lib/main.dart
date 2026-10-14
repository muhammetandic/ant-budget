import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ant_budget/app/app.dart';
import 'package:ant_budget/app/app_composition.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ProviderScope(
      overrides: appProviderOverrides,
      child: const SmartBudgetApp(),
    ),
  );
}
