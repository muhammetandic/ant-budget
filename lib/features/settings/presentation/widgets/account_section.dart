import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ant_budget/l10n/generated/app_localizations.dart';
import 'package:ant_budget/features/settings/presentation/providers/settings_providers.dart';

/// Account section showing Google sign-in status.
class AccountSection extends ConsumerWidget {
  const AccountSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final account = ref.watch(googleSignInAccountProvider).value;
    final isSignedIn = account != null;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.settingsAccountSection,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  isSignedIn ? Icons.check_circle : Icons.cancel,
                  color: isSignedIn ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    account != null
                        ? l10n.settingsAccountSignedIn(account.email)
                        : l10n.settingsAccountNotSignedIn,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (isSignedIn)
              OutlinedButton.icon(
                onPressed: () async {
                  await ref.read(signOutFromGoogleUseCaseProvider)();
                },
                icon: const Icon(Icons.logout),
                label: Text(l10n.settingsAccountSignOut),
              )
            else
              FilledButton.icon(
                onPressed: () async {
                  final success = await ref.read(signInToGoogleUseCaseProvider)();
                  if (success && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.settingsAccountSignedInSuccess)),
                    );
                  } else if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.settingsAccountSignInFailed)),
                    );
                  }
                },
                icon: const Icon(Icons.login),
                label: Text(l10n.settingsAccountSignIn),
              ),
          ],
        ),
      ),
    );
  }
}