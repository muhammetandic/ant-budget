import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ant_budget/core/providers/database_providers.dart';
import 'package:ant_budget/l10n/generated/app_localizations.dart';
import 'package:ant_budget/features/settings/domain/repositories/backup_repository.dart';
import 'package:ant_budget/features/settings/presentation/providers/settings_providers.dart';
import 'package:ant_budget/features/settings/presentation/widgets/backup_file_list.dart';

/// Backup section with create, list, and restore functionality.
class BackupSection extends ConsumerStatefulWidget {
  const BackupSection({super.key});

  @override
  ConsumerState<BackupSection> createState() => _BackupSectionState();
}

class _BackupSectionState extends ConsumerState<BackupSection> {
  List<BackupFile> _backups = [];
  bool _loadingBackups = false;
  bool _backingUp = false;
  bool _backupListFailed = false;
  String? _accountId;

  @override
  void initState() {
    super.initState();
    ref.listenManual(googleSignInAccountProvider, (_, state) {
      state.whenData(_onAccountChanged);
    }, fireImmediately: true);
  }

  void _onAccountChanged(GoogleSignInAccount? account) {
    final accountId = account?.id;
    if (accountId == _accountId) return;
    _accountId = accountId;
    if (accountId == null) {
      setState(() {
        _backups = [];
        _loadingBackups = false;
        _backupListFailed = false;
      });
      return;
    }
    _loadBackups(accountId);
  }

  Future<void> _loadBackups(String accountId) async {
    setState(() => _loadingBackups = true);
    try {
      final backups = await ref.read(listBackupsUseCaseProvider)();
      if (mounted && _accountId == accountId) {
        setState(() {
          _backups = backups;
          _backupListFailed = false;
        });
      }
    } catch (_) {
      if (mounted && _accountId == accountId) {
        setState(() => _backupListFailed = true);
      }
    } finally {
      if (mounted && _accountId == accountId) {
        setState(() => _loadingBackups = false);
      }
    }
  }

  Future<void> _createBackup() async {
    setState(() => _backingUp = true);
    try {
      final result = await ref.read(createBackupUseCaseProvider)();
      if (mounted) {
        switch (result) {
          case BackupSuccess():
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  AppLocalizations.of(context)
                      .settingsBackupCreated(result.fileName),
                ),
              ),
            );
            final accountId = _accountId;
            if (accountId != null) _loadBackups(accountId);
          case BackupFailure():
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  AppLocalizations.of(context).settingsBackupCreateFailed,
                ),
                backgroundColor: Colors.red,
              ),
            );
        }
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context).settingsBackupCreateFailed,
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _backingUp = false);
    }
  }

  Future<void> _restoreBackup(BackupFile backup) async {
    final l10n = AppLocalizations.of(context);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.settingsBackupRestoreConfirmTitle),
        content: Text(l10n.settingsBackupRestoreConfirmMessage(backup.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.actionCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.orange),
            child: Text(l10n.settingsBackupRestore),
          ),
        ],
      ),
    );

    if (confirm != true || !mounted) return;

    try {
      final result = await ref.read(restoreBackupUseCaseProvider)(backup);
      if (mounted) {
        switch (result) {
          case RestoreSuccess():
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.settingsBackupRestored),
                backgroundColor: Colors.green,
              ),
            );
          case RestoreFailure():
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.settingsBackupRestoreFailed),
                backgroundColor: Colors.red,
              ),
            );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.settingsBackupRestoreFailed),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      ref.invalidate(appDatabaseProvider);
    }
  }

  Future<void> _deleteBackup(BackupFile backup) async {
    final l10n = AppLocalizations.of(context);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.settingsBackupDeleteConfirmTitle),
        content: Text(l10n.settingsBackupDeleteConfirmMessage(backup.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.actionCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.actionDelete),
          ),
        ],
      ),
    );

    if (confirm != true || !mounted) return;

    try {
      final success = await ref.read(deleteBackupUseCaseProvider)(backup.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? l10n.settingsBackupDeleted
                : l10n.settingsBackupDeleteFailed,
          ),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
      final accountId = _accountId;
      if (success && accountId != null) _loadBackups(accountId);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.settingsBackupDeleteFailed),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isSignedIn = ref.watch(googleSignInAccountProvider).value != null;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.settingsBackupSection,
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            if (!isSignedIn) ...[
              Text(l10n.settingsBackupSignInRequired),
              const SizedBox(height: 8),
              FilledButton.icon(
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  try {
                    final success = await ref.read(
                      signInToGoogleUseCaseProvider,
                    )();
                    if (!mounted) return;
                    if (!success) {
                      messenger.showSnackBar(
                        SnackBar(
                          content: Text(l10n.settingsBackupSignInFailed),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  } catch (_) {
                    if (mounted) {
                      messenger.showSnackBar(
                        SnackBar(
                          content: Text(l10n.settingsBackupSignInFailed),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                icon: const Icon(Icons.cloud_upload),
                label: Text(l10n.settingsBackupSignInToBackup),
              ),
            ] else ...[
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _backingUp ? null : _createBackup,
                      icon: _backingUp
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.backup),
                      label: Text(
                        _backingUp
                            ? l10n.settingsBackupCreating
                            : l10n.settingsBackupCreate,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (_loadingBackups)
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              BackupFileList(
                backups: _backups,
                failed: _backupListFailed,
                onRestore: _restoreBackup,
                onDelete: _deleteBackup,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
