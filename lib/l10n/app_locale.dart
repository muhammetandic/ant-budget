import 'package:flutter/widgets.dart';

/// Chooses the language the UI is rendered in.
///
/// The app is Turkish first: a device in Turkish renders Turkish, a device in
/// English renders English, and every other language (including ones the app
/// does not ship) falls back to Turkish rather than to English.
abstract final class AppLocale {
  /// Language used when the device asks for something unsupported.
  static const Locale turkish = Locale('tr');

  /// The only language besides [turkish] the app ships.
  static const Locale english = Locale('en');

  /// Resolves the device [locale] against the [supported] ones.
  static Locale resolve(Locale? locale, Iterable<Locale> supported) {
    if (locale != null) {
      for (final candidate in supported) {
        if (candidate.languageCode == locale.languageCode) return candidate;
      }
    }
    return turkish;
  }
}
