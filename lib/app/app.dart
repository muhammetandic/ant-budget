import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ant_budget/app/router/app_router.dart';
import 'package:ant_budget/core/config/app_config.dart';
import 'package:ant_budget/core/theme/app_theme.dart';
import 'package:ant_budget/l10n/app_locale.dart';
import 'package:ant_budget/l10n/l10n.dart';

/// Root widget: theme, languages + router.
///
/// It is a [ConsumerWidget] only so the router can be injected; all state lives
/// in providers, which keeps this widget free of logic.
class SmartBudgetApp extends ConsumerWidget {
  const SmartBudgetApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      localeResolutionCallback: AppLocale.resolve,
      routerConfig: ref.watch(appRouterProvider),
    );
  }
}
