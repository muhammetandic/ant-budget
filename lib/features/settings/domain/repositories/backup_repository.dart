sealed class BackupResult {
  const BackupResult();
}

final class BackupSuccess extends BackupResult {
  const BackupSuccess({
    required this.fileName,
    required this.timestamp,
    required this.sizeBytes,
  });

  final String fileName;
  final DateTime timestamp;
  final int sizeBytes;
}

final class BackupFailure extends BackupResult {
  const BackupFailure();
}

sealed class RestoreResult {
  const RestoreResult();
}

final class RestoreSuccess extends RestoreResult {
  const RestoreSuccess();
}

final class RestoreFailure extends RestoreResult {
  const RestoreFailure();
}

/// Backup metadata exposed to the app without Google Drive SDK types.
final class BackupFile {
  const BackupFile({
    required this.id,
    required this.name,
    this.createdAt,
    this.sizeBytes,
  });

  final String id;
  final String name;
  final DateTime? createdAt;
  final int? sizeBytes;
}

/// Abstract repository for backup operations.
abstract class BackupRepository {
  Future<BackupResult> backup();
  Future<List<BackupFile>> listBackups();
  Future<RestoreResult> restore(BackupFile backupFile);
  Future<bool> deleteBackup(String fileId);
  bool get isSignedIn;
  Future<bool> signIn();
  Future<void> signOut();
}
