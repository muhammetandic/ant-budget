import 'package:ant_budget/core/utils/month_names.dart';

/// Renders [DateTime] values for the UI.
///
/// Kept dependency-free (no `intl`) to stay consistent with OCR date parsing,
/// which already understands English and Turkish month names.
abstract final class DateFormatter {
  /// Default language: English month names.
  static const String _defaultLanguage = 'en';

  /// `14 Oct 2026` in English, `14 Eki 2026` in Turkish.
  static String short(
    DateTime date, {
    String languageCode = _defaultLanguage,
  }) =>
      '${date.day} ${MonthNames.shortFor(date.month, languageCode)} '
      '${date.year}';

  /// `Oct 2026` / `Ekim 2026`, used for month headers.
  static String month(
    DateTime date, {
    String languageCode = _defaultLanguage,
  }) =>
      '${MonthNames.fullFor(date.month, languageCode)} ${date.year}';
}
