import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:ant_budget/l10n/generated/app_localizations.dart';
import 'package:ant_budget/features/settings/data/services/google_drive_backup_service.dart';
import 'package:ant_budget/features/settings/presentation/providers/settings_providers.dart';

/// Backup section with create, list, and restore functionality.
class BackupSection extends ConsumerStatefulWidget {
  const BackupSection({super.key});

  @override
  ConsumerState<BackupSection> createState() => _BackupSectionState();
}

class _BackupSectionState extends ConsumerState<BackupSection> {
  List<drive.File> _backups = [];
  bool _loadingBackups = false;
  bool _backingUp = false;

  @override
  void initState() {
    super.initState();
    _loadBackups();
  }

  Future<void> _loadBackups() async {
    final isSignedIn = ref.read(checkGoogleSignInStatusUseCaseProvider)();
    if (!isSignedIn) return;

    setState(() => _loadingBackups = true);
    try {
      final backups = await ref.read(listBackupsUseCaseProvider)();
      if (mounted) setState(() => _backups = backups);
    } finally {
      if (mounted) setState(() => _loadingBackups = false);
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
              SnackBar(content: Text(AppLocalizations.of(context).settingsBackupCreated(result.fileName))),
            );
            _loadBackups();
          case BackupFailure():
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(result.message), backgroundColor: Colors.red),
            );
        }
      }
    } finally {
      if (mounted) setState(() => _backingUp = false);
    }
  }

  Future<void> _restoreBackup(drive.File backup) async {
    final l10n = AppLocalizations.of(context);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.settingsBackupRestoreConfirmTitle),
        content: Text(l10n.settingsBackupRestoreConfirmMessage(backup.name!)),
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
              SnackBar(content: Text(l10n.settingsBackupRestored), backgroundColor: Colors.green),
            );
          case RestoreFailure():
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(result.message), backgroundColor: Colors.red),
            );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.settingsBackupRestoreFailed}: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _deleteBackup(drive.File backup) async {
    final l10n = AppLocalizations.of(context);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.settingsBackupDeleteConfirmTitle),
        content: Text(l10n.settingsBackupDeleteConfirmMessage(backup.name!)),
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

    final success = await ref.read(deleteBackupUseCaseProvider)(backup.id!);
    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.settingsBackupDeleted), backgroundColor: Colors.green),
        );
        _loadBackups();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.settingsBackupDeleteFailed), backgroundColor: Colors.red),
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
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            if (!isSignedIn) ...[
              Text(l10n.settingsBackupSignInRequired),
              const SizedBox(height: 8),
              FilledButton.icon(
                onPressed: () async {
                  final success = await ref.read(signInToGoogleUseCaseProvider)();
                  if (success) {
                    _loadBackups();
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
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(Icons.backup),
                      label: Text(_backingUp ? l10n.settingsBackupCreating : l10n.settingsBackupCreate),
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
              if (_backups.isEmpty)
                Text(l10n.settingsBackupNoBackups, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant))
              else
                Column(
                  children: _backups.map((backup) => _BackupTile(
                        backup: backup,
                        onRestore: () => _restoreBackup(backup),
                        onDelete: () => _deleteBackup(backup),
                      )).toList(),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _BackupTile extends StatelessWidget {
  final drive.File backup;
  final VoidCallback onRestore;
  final VoidCallback onDelete;

  const _BackupTile({
    required this.backup,
    required this.onRestore,
    required this.onDelete,
  });

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _formatSize(String? sizeStr) {
    if (sizeStr == null) return '';
    final size = int.tryParse(sizeStr) ?? 0;
    if (size < 1024) return '$size B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)} KB';
    return '${(size / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const Icon(Icons.backup_table),
        title: Text(backup.name ?? 'Unknown backup'),
        subtitle: Text(
          '${_formatDate(backup.createdTime?.toLocal())}  •  ${_formatSize(backup.size)}',
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'restore') onRestore();
            if (value == 'delete') onDelete();
          },
          itemBuilder: (context) => [
            PopupMenuItem(value: 'restore', child: Row(children: [const Icon(Icons.restore), const SizedBox(width: 8), Text(l10n.settingsBackupRestore)])),
            PopupMenuItem(value: 'delete', child: Row(children: [const Icon(Icons.delete, color: Colors.red), const SizedBox(width: 8), Text(l10n.actionDelete, style: const TextStyle(color: Colors.red))])),
          ],
        ),
        onTap: onRestore,
      ),
    );
  }
}