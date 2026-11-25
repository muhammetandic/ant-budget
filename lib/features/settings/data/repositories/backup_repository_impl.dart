import 'package:ant_budget/features/settings/data/services/google_drive_backup_service.dart';
import 'package:ant_budget/features/settings/domain/repositories/backup_repository.dart';

/// Implementation of [BackupRepository] using Google Drive.
class BackupRepositoryImpl implements BackupRepository {
  final GoogleDriveBackupService _service;

  BackupRepositoryImpl(this._service);

  @override
  Future<BackupResult> backup() => _service.backup();

  @override
  Future<List<BackupFile>> listBackups() => _service.listBackups();

  @override
  Future<RestoreResult> restore(BackupFile backupFile) =>
      _service.restore(backupFile);

  @override
  Future<bool> deleteBackup(String fileId) => _service.deleteBackup(fileId);

  @override
  bool get isSignedIn => _service.isSignedIn;

  @override
  Future<bool> signIn() => _service.signIn();

  @override
  Future<void> signOut() => _service.signOut();
}
