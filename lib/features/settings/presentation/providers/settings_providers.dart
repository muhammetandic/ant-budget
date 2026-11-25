import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ant_budget/core/providers/database_providers.dart';
import 'package:ant_budget/features/settings/data/repositories/backup_repository_impl.dart';
import 'package:ant_budget/features/settings/data/services/google_drive_backup_service.dart';
import 'package:ant_budget/features/settings/domain/repositories/backup_repository.dart';
import 'package:ant_budget/features/settings/domain/usecases/backup_usecases.dart';

part 'settings_providers.g.dart';

/// GoogleSignIn singleton - initialized lazily on first use.
@riverpod
GoogleSignIn googleSignIn(Ref ref) => GoogleSignIn.instance;

/// Emits the authenticated account, or null after sign-out.
final googleSignInAccountProvider = StreamProvider<GoogleSignInAccount?>((
  ref,
) async* {
  final signIn = ref.watch(googleSignInProvider);
  await GoogleSignInInitializer.future;
  final lightweightAttempt = signIn.attemptLightweightAuthentication();
  if (lightweightAttempt != null) {
    try {
      final account = await lightweightAttempt;
      if (account != null) yield account;
    } on GoogleSignInException {
      yield null;
    }
  }
  await for (final event in signIn.authenticationEvents) {
    yield switch (event) {
      GoogleSignInAuthenticationEventSignIn(:final user) => user,
      GoogleSignInAuthenticationEventSignOut() => null,
    };
  }
});

/// Google Drive backup service.
@riverpod
GoogleDriveBackupService googleDriveBackupService(Ref ref) =>
    GoogleDriveBackupService(
      ref.watch(googleSignInProvider),
      ref.watch(appDatabaseProvider),
    );

/// Backup repository.
@riverpod
BackupRepository backupRepository(Ref ref) =>
    BackupRepositoryImpl(ref.watch(googleDriveBackupServiceProvider));

/// Use cases
@riverpod
CreateBackupUseCase createBackupUseCase(Ref ref) =>
    CreateBackupUseCase(ref.watch(backupRepositoryProvider));

@riverpod
ListBackupsUseCase listBackupsUseCase(Ref ref) =>
    ListBackupsUseCase(ref.watch(backupRepositoryProvider));

@riverpod
RestoreBackupUseCase restoreBackupUseCase(Ref ref) =>
    RestoreBackupUseCase(ref.watch(backupRepositoryProvider));

@riverpod
DeleteBackupUseCase deleteBackupUseCase(Ref ref) =>
    DeleteBackupUseCase(ref.watch(backupRepositoryProvider));

@riverpod
SignInToGoogleUseCase signInToGoogleUseCase(Ref ref) =>
    SignInToGoogleUseCase(ref.watch(backupRepositoryProvider));

@riverpod
SignOutFromGoogleUseCase signOutFromGoogleUseCase(Ref ref) =>
    SignOutFromGoogleUseCase(ref.watch(backupRepositoryProvider));

@riverpod
CheckGoogleSignInStatusUseCase checkGoogleSignInStatusUseCase(Ref ref) =>
    CheckGoogleSignInStatusUseCase(ref.watch(backupRepositoryProvider));
