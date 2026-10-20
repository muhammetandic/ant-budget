// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The application's [GoRouter] configuration.
///
/// The five tabs live inside a [ShellRoute] so the bottom bar survives tab
/// switches, while creation/scanning screens are pushed above the shell.

@ProviderFor(appRouter)
final appRouterProvider = AppRouterProvider._();

/// The application's [GoRouter] configuration.
///
/// The five tabs live inside a [ShellRoute] so the bottom bar survives tab
/// switches, while creation/scanning screens are pushed above the shell.

final class AppRouterProvider
    extends $FunctionalProvider<GoRouter, GoRouter, GoRouter>
    with $Provider<GoRouter> {
  /// The application's [GoRouter] configuration.
  ///
  /// The five tabs live inside a [ShellRoute] so the bottom bar survives tab
  /// switches, while creation/scanning screens are pushed above the shell.
  AppRouterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appRouterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appRouterHash();

  @$internal
  @override
  $ProviderElement<GoRouter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoRouter create(Ref ref) {
    return appRouter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoRouter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoRouter>(value),
    );
  }
}

String _$appRouterHash() => r'666e1ba43b42ce80c512794cb0d598a90c2493d8';
