import 'package:flutter/material.dart';

/// Central definition of the app's look and feel.
///
/// Screens never hard-code colours; they read them from `Theme.of(context)`, so
/// changing the brand colour only ever touches this class.
abstract final class AppTheme {
  /// Brand colour the whole Material 3 palette is derived from.
  static const Color seedColor = Color(0xFF00695C);

  /// Light [ThemeData].
  static ThemeData light() => _build(Brightness.light);

  /// Dark [ThemeData].
  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
        isDense: true,
      ),
    );
  }
}
