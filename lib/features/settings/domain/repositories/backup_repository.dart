import 'package:googleapis/drive/v3.dart' as drive;
import 'package:ant_budget/features/settings/data/services/google_drive_backup_service.dart';

/// Abstract repository for backup operations.
abstract class BackupRepository {
  Future<BackupResult> backup();
  Future<List<drive.File>> listBackups();
  Future<RestoreResult> restore(drive.File backupFile);
  Future<bool> deleteBackup(String fileId);
  bool get isSignedIn;
  Future<bool> signIn();
  Future<void> signOut();
}