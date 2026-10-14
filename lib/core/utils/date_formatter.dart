import 'package:smart_budget_tracker/core/utils/month_names.dart';

/// Renders [DateTime] values for the UI.
///
/// Kept dependency-free (no `intl`) to stay consistent with OCR date parsing,
/// which already understands English and Turkish month names.
abstract final class DateFormatter {
  /// `14 Oct 2026`.
  static String short(DateTime date) =>
      '${date.day} ${MonthNames.shortEnglish(date.month)} ${date.year}';

  /// `Oct 2026`, used for month headers.
  static String month(DateTime date) =>
      '${MonthNames.englishFull[date.month - 1]} ${date.year}';
}
