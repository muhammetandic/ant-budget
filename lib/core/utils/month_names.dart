import 'package:ant_budget/core/utils/ascii_folding.dart';

/// Month names used when parsing (OCR) and rendering dates.
///
/// Deliberately a plain lookup table instead of an `intl` dependency: receipt
/// parsing must work without locale bundles being initialised, and the two
/// supported languages are known up front. Adding a language means adding one
/// list here.
abstract final class MonthNames {
  /// English short names, index 0 = January.
  static const List<String> englishShort = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  /// English full names, index 0 = January.
  static const List<String> englishFull = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  /// Turkish short names (as printed on receipts), index 0 = January.
  static const List<String> turkishShort = [
    'Oca',
    'Şub',
    'Mar',
    'Nis',
    'May',
    'Haz',
    'Tem',
    'Ağu',
    'Eyl',
    'Eki',
    'Kas',
    'Ara',
  ];

  /// Turkish full names, index 0 = January.
  static const List<String> turkishFull = [
    'Ocak',
    'Şubat',
    'Mart',
    'Nisan',
    'Mayıs',
    'Haziran',
    'Temmuz',
    'Ağustos',
    'Eylül',
    'Ekim',
    'Kasım',
    'Aralık',
  ];

  /// Short name of [month] (1 = January) in [languageCode].
  ///
  /// Turkish for `tr`, English for everything else, mirroring the locales the
  /// application ships.
  static String shortFor(int month, String languageCode) => languageCode == 'tr'
      ? turkishShort[month - 1]
      : englishShort[month - 1];

  /// Full name of [month] (1 = January) in [languageCode].
  static String fullFor(int month, String languageCode) => languageCode == 'tr'
      ? turkishFull[month - 1]
      : englishFull[month - 1];

  /// Returns the 1-based month index matching [token], or `null`.
  ///
  /// Matching ignores case, accents, and a trailing dot (`Eki.`), and understands both
  /// short and full names of the supported languages in any casing (including Turkish
  /// uppercase `KASIM`, `NİSAN`, `MAYIS`, `AĞUSTOS`, `ARALIK`).
  static int? indexOf(String token) {
    final cleaned = AsciiFolding.fold(token.replaceAll('.', '').trim());
    if (cleaned.isEmpty) return null;
    final tables = <List<String>>[
      englishShort,
      englishFull,
      turkishShort,
      turkishFull,
    ];
    for (final table in tables) {
      for (var i = 0; i < table.length; i++) {
        if (AsciiFolding.fold(table[i]) == cleaned) return i + 1;
      }
    }
    return null;
  }

  /// English short name of a 1-based [month], e.g. `Oct`.
  static String shortEnglish(int month) => englishShort[month - 1];
}
