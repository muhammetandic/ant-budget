import 'package:flutter/material.dart';
import 'package:ant_budget/features/settings/domain/repositories/backup_repository.dart';
import 'package:ant_budget/l10n/generated/app_localizations.dart';

class BackupFileList extends StatelessWidget {
  const BackupFileList({
    super.key,
    required this.backups,
    required this.failed,
    required this.onRestore,
    required this.onDelete,
  });

  final List<BackupFile> backups;
  final bool failed;
  final ValueChanged<BackupFile> onRestore;
  final ValueChanged<BackupFile> onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (failed) return Text(l10n.settingsBackupListFailed);
    if (backups.isEmpty) {
      return Text(
        l10n.settingsBackupNoBackups,
        style: Theme.of(context).textTheme.bodyMedium
            ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
      );
    }

    return Column(
      children: [
        for (final backup in backups)
          _BackupTile(
            backup: backup,
            onRestore: () => onRestore(backup),
            onDelete: () => onDelete(backup),
          ),
      ],
    );
  }
}

class _BackupTile extends StatelessWidget {
  const _BackupTile({
    required this.backup,
    required this.onRestore,
    required this.onDelete,
  });

  final BackupFile backup;
  final VoidCallback onRestore;
  final VoidCallback onDelete;

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _formatSize(int? size) {
    if (size == null) return '';
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
        title: Text(backup.name),
        subtitle: Text(
          '${_formatDate(backup.createdAt?.toLocal())}  •  ${_formatSize(backup.sizeBytes)}',
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'restore') onRestore();
            if (value == 'delete') onDelete();
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'restore',
              child: Row(
                children: [
                  const Icon(Icons.restore),
                  const SizedBox(width: 8),
                  Text(l10n.settingsBackupRestore),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  const Icon(Icons.delete, color: Colors.red),
                  const SizedBox(width: 8),
                  Text(
                    l10n.actionDelete,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
          ],
        ),
        onTap: onRestore,
      ),
    );
  }
}
