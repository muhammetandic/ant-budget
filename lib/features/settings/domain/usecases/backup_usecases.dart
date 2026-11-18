import 'package:googleapis/drive/v3.dart' as drive;
import 'package:ant_budget/features/settings/data/services/google_drive_backup_service.dart';
import 'package:ant_budget/features/settings/domain/repositories/backup_repository.dart';

/// Use case for creating a backup.
class CreateBackupUseCase {
  final BackupRepository _repository;

  CreateBackupUseCase(this._repository);

  Future<BackupResult> call() => _repository.backup();
}

/// Use case for listing backups.
class ListBackupsUseCase {
  final BackupRepository _repository;

  ListBackupsUseCase(this._repository);

  Future<List<drive.File>> call() => _repository.listBackups();
}

/// Use case for restoring from a backup.
class RestoreBackupUseCase {
  final BackupRepository _repository;

  RestoreBackupUseCase(this._repository);

  Future<RestoreResult> call(drive.File backupFile) => _repository.restore(backupFile);
}

/// Use case for deleting a backup.
class DeleteBackupUseCase {
  final BackupRepository _repository;

  DeleteBackupUseCase(this._repository);

  Future<bool> call(String fileId) => _repository.deleteBackup(fileId);
}

/// Use case for signing in to Google.
class SignInToGoogleUseCase {
  final BackupRepository _repository;

  SignInToGoogleUseCase(this._repository);

  Future<bool> call() => _repository.signIn();
}

/// Use case for signing out from Google.
class SignOutFromGoogleUseCase {
  final BackupRepository _repository;

  SignOutFromGoogleUseCase(this._repository);

  Future<void> call() => _repository.signOut();
}

/// Use case for checking if signed in.
class CheckGoogleSignInStatusUseCase {
  final BackupRepository _repository;

  CheckGoogleSignInStatusUseCase(this._repository);

  bool call() => _repository.isSignedIn;
}