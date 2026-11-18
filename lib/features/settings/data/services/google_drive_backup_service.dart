import 'dart:io';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:ant_budget/core/config/app_config.dart';
import 'package:ant_budget/core/data/database/app_database.dart';

/// Initializes the singleton Google Sign-In instance exactly once.
///
/// google_sign_in 7 requires [GoogleSignIn.initialize] to finish before any
/// other method on [GoogleSignIn.instance] is called.
class GoogleSignInInitializer {
  GoogleSignInInitializer._();

  static Future<void>? _future;

  static Future<void> get future =>
      _future ??= GoogleSignIn.instance.initialize();
}

/// Result of a backup operation.
sealed class BackupResult {
  const BackupResult();
}

class BackupSuccess extends BackupResult {
  final String fileName;
  final DateTime timestamp;
  final int sizeBytes;

  const BackupSuccess({
    required this.fileName,
    required this.timestamp,
    required this.sizeBytes,
  });
}

class BackupFailure extends BackupResult {
  final String message;

  const BackupFailure(this.message);
}

/// Result of a restore operation.
sealed class RestoreResult {
  const RestoreResult();
}

class RestoreSuccess extends RestoreResult {
  const RestoreSuccess();
}

class RestoreFailure extends RestoreResult {
  final String message;

  const RestoreFailure(this.message);
}

/// Service for backing up and restoring the app database to/from Google Drive.
class GoogleDriveBackupService {
  static const _appFolderName = 'AntBudgetBackups';
  static const _backupPrefix = 'ant_budget_backup_';
  static const _backupExtension = '.sqlite';
  static const _driveScopes = [drive.DriveApi.driveAppdataScope];

  final GoogleSignIn _googleSignIn;
  final AppDatabase _database;

  GoogleSignInAccount? _account;

  GoogleDriveBackupService(this._googleSignIn, this._database);

  /// Gets an authenticated HTTP client for Google APIs.
  Future<http.Client?> _getAuthClient() async {
    await GoogleSignInInitializer.future;
    final headers = await _googleSignIn.authorizationClient.authorizationHeaders(
      _driveScopes,
      promptIfNecessary: false,
    );
    final authHeader = headers?['Authorization'];
    if (authHeader == null) return null;

    final token = authHeader.split(' ').last;
    return _AuthenticatedClient(token);
  }

  /// Gets or creates the app-specific folder in Google Drive.
  Future<String?> _getOrCreateAppFolder(drive.DriveApi driveApi) async {
    final fileList = await driveApi.files.list(
      q: "name='$_appFolderName' and mimeType='application/vnd.google-apps.folder' and trashed=false",
      spaces: 'appDataFolder',
      $fields: 'files(id, name)',
    );

    if (fileList.files != null && fileList.files!.isNotEmpty) {
      return fileList.files!.first.id;
    }

    final folder = drive.File()
      ..name = _appFolderName
      ..mimeType = 'application/vnd.google-apps.folder'
      ..parents = ['appDataFolder'];

    final created = await driveApi.files.create(folder, uploadMedia: null);
    return created.id;
  }

  /// Generates a backup file name with timestamp.
  String _generateBackupFileName() {
    final now = DateTime.now();
    final timestamp = '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}_'
        '${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}';
    return '$_backupPrefix$timestamp$_backupExtension';
  }

  /// Gets the database file path.
  Future<String> _getDatabasePath() async {
    final docsDir = await getApplicationDocumentsDirectory();
    return '${docsDir.path}/${AppConfig.databaseName}.sqlite';
  }

  /// Exports the current database to a file.
  Future<File> _exportDatabase(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final backupFile = File('${directory.path}/$fileName');

    // Close the database connection to allow file copy
    await _database.close();

    try {
      // Copy the database file
      final dbPath = await _getDatabasePath();
      final dbFile = File(dbPath);
      await dbFile.copy(backupFile.path);
    } finally {
      // Note: The database will be reopened by the provider when needed
    }

    return backupFile;
  }

  /// Imports a database from a backup file.
  Future<void> _importDatabase(File backupFile) async {
    await _database.close();

    try {
      final dbPath = await _getDatabasePath();
      final dbFile = File(dbPath);
      await backupFile.copy(dbFile.path);
    } finally {
      // Database will be reopened by provider
    }
  }

  /// Backs up the database to Google Drive.
  Future<BackupResult> backup() async {
    final client = await _getAuthClient();
    if (client == null) {
      return const BackupFailure('Not signed in to Google. Please sign in first.');
    }

    final driveApi = drive.DriveApi(client);
    final folderId = await _getOrCreateAppFolder(driveApi);
    if (folderId == null) {
      return const BackupFailure('Failed to create/access backup folder.');
    }

    final fileName = _generateBackupFileName();
    final backupFile = await _exportDatabase(fileName);

    try {
      final media = drive.Media(backupFile.openRead(), await backupFile.length());
      final file = drive.File()
        ..name = fileName
        ..parents = [folderId];

      await driveApi.files.create(file, uploadMedia: media);
      final size = await backupFile.length();
      await backupFile.delete();

      return BackupSuccess(
        fileName: fileName,
        timestamp: DateTime.now(),
        sizeBytes: size,
      );
    } catch (e) {
      await backupFile.delete();
      return BackupFailure('Upload failed: $e');
    }
  }

  /// Lists available backups in Google Drive.
  Future<List<drive.File>> listBackups() async {
    final client = await _getAuthClient();
    if (client == null) return [];

    final driveApi = drive.DriveApi(client);
    final folderId = await _getOrCreateAppFolder(driveApi);
    if (folderId == null) return [];

    final fileList = await driveApi.files.list(
      q: "parents in '$folderId' and name contains '$_backupPrefix' and trashed=false",
      orderBy: 'createdTime desc',
      spaces: 'appDataFolder',
      $fields: 'files(id, name, size, createdTime)',
    );

    return fileList.files ?? [];
  }

  /// Restores the database from a Google Drive backup.
  Future<RestoreResult> restore(drive.File backupFile) async {
    final client = await _getAuthClient();
    if (client == null) {
      return const RestoreFailure('Not signed in to Google. Please sign in first.');
    }

    final driveApi = drive.DriveApi(client);
    final directory = await getApplicationDocumentsDirectory();
    final localFile = File('${directory.path}/${backupFile.name}');

    try {
      final media = await driveApi.files.get(backupFile.id!, downloadOptions: drive.DownloadOptions.fullMedia) as drive.Media;
      final sink = localFile.openWrite();
      await media.stream.pipe(sink);
      await sink.flush();
      await sink.close();

      await _importDatabase(localFile);
      await localFile.delete();

      return const RestoreSuccess();
    } catch (e) {
      await localFile.delete();
      return RestoreFailure('Restore failed: $e');
    }
  }

  /// Deletes a backup from Google Drive.
  Future<bool> deleteBackup(String fileId) async {
    final client = await _getAuthClient();
    if (client == null) return false;

    final driveApi = drive.DriveApi(client);
    try {
      await driveApi.files.delete(fileId);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Checks if user is signed in.
  bool get isSignedIn => _account != null;

  /// Signs in to Google.
  Future<bool> signIn() async {
    await GoogleSignInInitializer.future;
    try {
      _account = await _googleSignIn.authenticate(scopeHint: _driveScopes);
      return true;
    } on GoogleSignInException {
      return false;
    }
  }

  /// Signs out from Google.
  Future<void> signOut() async {
    await GoogleSignInInitializer.future;
    await _googleSignIn.signOut();
    _account = null;
  }
}

/// Simple authenticated HTTP client for Google APIs.
class _AuthenticatedClient extends http.BaseClient {
  final String _token;
  final http.Client _client = http.Client();

  _AuthenticatedClient(this._token);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['Authorization'] = 'Bearer $_token';
    return _client.send(request);
  }

  @override
  void close() {
    _client.close();
  }
}