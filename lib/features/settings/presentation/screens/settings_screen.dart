import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ant_budget/app/router/app_routes.dart';
import 'package:ant_budget/l10n/generated/app_localizations.dart';
import 'package:ant_budget/features/settings/presentation/widgets/backup_section.dart';
import 'package:ant_budget/features/settings/presentation/widgets/account_section.dart';
import 'package:ant_budget/features/settings/presentation/widgets/about_section.dart';

/// Settings screen with backup, account, and app info sections.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const String routeName = '/settings';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.dashboard);
            }
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const AccountSection(),
          const SizedBox(height: 24),
          const BackupSection(),
          const SizedBox(height: 24),
          const AboutSection(),
        ],
      ),
    );
  }
}