// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// GoogleSignIn instance - configured for Drive app folder access.

@ProviderFor(googleSignIn)
final googleSignInProvider = GoogleSignInProvider._();

/// GoogleSignIn instance - configured for Drive app folder access.

final class GoogleSignInProvider
    extends $FunctionalProvider<GoogleSignIn, GoogleSignIn, GoogleSignIn>
    with $Provider<GoogleSignIn> {
  /// GoogleSignIn instance - configured for Drive app folder access.
  GoogleSignInProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'googleSignInProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$googleSignInHash();

  @$internal
  @override
  $ProviderElement<GoogleSignIn> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoogleSignIn create(Ref ref) {
    return googleSignIn(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoogleSignIn value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoogleSignIn>(value),
    );
  }
}

String _$googleSignInHash() => r'dec7ae91741a59692386d6c4c70cbb3cdc23cfe0';

/// Google Drive backup service.

@ProviderFor(googleDriveBackupService)
final googleDriveBackupServiceProvider = GoogleDriveBackupServiceProvider._();

/// Google Drive backup service.

final class GoogleDriveBackupServiceProvider
    extends
        $FunctionalProvider<
          GoogleDriveBackupService,
          GoogleDriveBackupService,
          GoogleDriveBackupService
        >
    with $Provider<GoogleDriveBackupService> {
  /// Google Drive backup service.
  GoogleDriveBackupServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'googleDriveBackupServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$googleDriveBackupServiceHash();

  @$internal
  @override
  $ProviderElement<GoogleDriveBackupService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GoogleDriveBackupService create(Ref ref) {
    return googleDriveBackupService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoogleDriveBackupService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoogleDriveBackupService>(value),
    );
  }
}

String _$googleDriveBackupServiceHash() =>
    r'9e81543da84839e9766ea6fdc7c9c0deb133d9b3';

/// Backup repository.

@ProviderFor(backupRepository)
final backupRepositoryProvider = BackupRepositoryProvider._();

/// Backup repository.

final class BackupRepositoryProvider
    extends
        $FunctionalProvider<
          BackupRepository,
          BackupRepository,
          BackupRepository
        >
    with $Provider<BackupRepository> {
  /// Backup repository.
  BackupRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'backupRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$backupRepositoryHash();

  @$internal
  @override
  $ProviderElement<BackupRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BackupRepository create(Ref ref) {
    return backupRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BackupRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BackupRepository>(value),
    );
  }
}

String _$backupRepositoryHash() => r'b709cf5ced9816e31618ff6a82834cd2b6b6a91f';

/// Use cases

@ProviderFor(createBackupUseCase)
final createBackupUseCaseProvider = CreateBackupUseCaseProvider._();

/// Use cases

final class CreateBackupUseCaseProvider
    extends
        $FunctionalProvider<
          CreateBackupUseCase,
          CreateBackupUseCase,
          CreateBackupUseCase
        >
    with $Provider<CreateBackupUseCase> {
  /// Use cases
  CreateBackupUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createBackupUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createBackupUseCaseHash();

  @$internal
  @override
  $ProviderElement<CreateBackupUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CreateBackupUseCase create(Ref ref) {
    return createBackupUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CreateBackupUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CreateBackupUseCase>(value),
    );
  }
}

String _$createBackupUseCaseHash() =>
    r'95bb5b19459ddf59a122c30c1bc9448cfbacfd0a';

@ProviderFor(listBackupsUseCase)
final listBackupsUseCaseProvider = ListBackupsUseCaseProvider._();

final class ListBackupsUseCaseProvider
    extends
        $FunctionalProvider<
          ListBackupsUseCase,
          ListBackupsUseCase,
          ListBackupsUseCase
        >
    with $Provider<ListBackupsUseCase> {
  ListBackupsUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'listBackupsUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$listBackupsUseCaseHash();

  @$internal
  @override
  $ProviderElement<ListBackupsUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ListBackupsUseCase create(Ref ref) {
    return listBackupsUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ListBackupsUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ListBackupsUseCase>(value),
    );
  }
}

String _$listBackupsUseCaseHash() =>
    r'0fb4a6ae58c7abc8a5d3f1ae820f09d80d1857c2';

@ProviderFor(restoreBackupUseCase)
final restoreBackupUseCaseProvider = RestoreBackupUseCaseProvider._();

final class RestoreBackupUseCaseProvider
    extends
        $FunctionalProvider<
          RestoreBackupUseCase,
          RestoreBackupUseCase,
          RestoreBackupUseCase
        >
    with $Provider<RestoreBackupUseCase> {
  RestoreBackupUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'restoreBackupUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$restoreBackupUseCaseHash();

  @$internal
  @override
  $ProviderElement<RestoreBackupUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RestoreBackupUseCase create(Ref ref) {
    return restoreBackupUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RestoreBackupUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RestoreBackupUseCase>(value),
    );
  }
}

String _$restoreBackupUseCaseHash() =>
    r'b231032acf4dd6a163b0b05cb50b749718cae9c4';

@ProviderFor(deleteBackupUseCase)
final deleteBackupUseCaseProvider = DeleteBackupUseCaseProvider._();

final class DeleteBackupUseCaseProvider
    extends
        $FunctionalProvider<
          DeleteBackupUseCase,
          DeleteBackupUseCase,
          DeleteBackupUseCase
        >
    with $Provider<DeleteBackupUseCase> {
  DeleteBackupUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deleteBackupUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deleteBackupUseCaseHash();

  @$internal
  @override
  $ProviderElement<DeleteBackupUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DeleteBackupUseCase create(Ref ref) {
    return deleteBackupUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeleteBackupUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeleteBackupUseCase>(value),
    );
  }
}

String _$deleteBackupUseCaseHash() =>
    r'54121978c3876e54ac0bad0dcf40d26c81968f3a';

@ProviderFor(signInToGoogleUseCase)
final signInToGoogleUseCaseProvider = SignInToGoogleUseCaseProvider._();

final class SignInToGoogleUseCaseProvider
    extends
        $FunctionalProvider<
          SignInToGoogleUseCase,
          SignInToGoogleUseCase,
          SignInToGoogleUseCase
        >
    with $Provider<SignInToGoogleUseCase> {
  SignInToGoogleUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'signInToGoogleUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$signInToGoogleUseCaseHash();

  @$internal
  @override
  $ProviderElement<SignInToGoogleUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SignInToGoogleUseCase create(Ref ref) {
    return signInToGoogleUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SignInToGoogleUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SignInToGoogleUseCase>(value),
    );
  }
}

String _$signInToGoogleUseCaseHash() =>
    r'fe522284cfef0924432118bb3acf0ced8733ca6f';

@ProviderFor(signOutFromGoogleUseCase)
final signOutFromGoogleUseCaseProvider = SignOutFromGoogleUseCaseProvider._();

final class SignOutFromGoogleUseCaseProvider
    extends
        $FunctionalProvider<
          SignOutFromGoogleUseCase,
          SignOutFromGoogleUseCase,
          SignOutFromGoogleUseCase
        >
    with $Provider<SignOutFromGoogleUseCase> {
  SignOutFromGoogleUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'signOutFromGoogleUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$signOutFromGoogleUseCaseHash();

  @$internal
  @override
  $ProviderElement<SignOutFromGoogleUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SignOutFromGoogleUseCase create(Ref ref) {
    return signOutFromGoogleUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SignOutFromGoogleUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SignOutFromGoogleUseCase>(value),
    );
  }
}

String _$signOutFromGoogleUseCaseHash() =>
    r'eb61fd852c9eba5107ad033dd9771b9b952bccfd';

@ProviderFor(checkGoogleSignInStatusUseCase)
final checkGoogleSignInStatusUseCaseProvider =
    CheckGoogleSignInStatusUseCaseProvider._();

final class CheckGoogleSignInStatusUseCaseProvider
    extends
        $FunctionalProvider<
          CheckGoogleSignInStatusUseCase,
          CheckGoogleSignInStatusUseCase,
          CheckGoogleSignInStatusUseCase
        >
    with $Provider<CheckGoogleSignInStatusUseCase> {
  CheckGoogleSignInStatusUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'checkGoogleSignInStatusUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$checkGoogleSignInStatusUseCaseHash();

  @$internal
  @override
  $ProviderElement<CheckGoogleSignInStatusUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CheckGoogleSignInStatusUseCase create(Ref ref) {
    return checkGoogleSignInStatusUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CheckGoogleSignInStatusUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CheckGoogleSignInStatusUseCase>(
        value,
      ),
    );
  }
}

String _$checkGoogleSignInStatusUseCaseHash() =>
    r'4be7a44b4947752690a9360c676513a89633d330';
