import 'package:smart_budget_tracker/core/error/failure.dart';
import 'package:smart_budget_tracker/core/error/result.dart';
import 'package:smart_budget_tracker/core/utils/month_names.dart';
import 'package:smart_budget_tracker/features/receipt_scan/domain/parsing/ocr_parse_input.dart';
import 'package:smart_budget_tracker/features/receipt_scan/domain/parsing/ocr_parsing_strategy.dart';

/// Extracts the purchase date of a receipt.
///
/// Optional by design: a receipt without a readable date is still usable, so the
/// strategy reports "not found" as a *successful* `null` and the pipeline
/// substitutes the current date. Three shapes are supported — ISO, numeric and
/// month names in English or Turkish — and every candidate is validated against
/// the calendar (so `31/02/2026` is rejected instead of silently rolled over).
final class DateParserStrategy implements OcrParsingStrategy<DateTime?> {
  const DateParserStrategy();

  /// Years outside this range are treated as misreads.
  static const int minYear = 2000;
  static const int maxYear = 2100;

  /// `2026-10-14`, `2026.10.14`.
  static final RegExp isoPattern = RegExp(r'(\d{4})[./-](\d{1,2})[./-](\d{1,2})');

  /// `14/10/2026`, `14.10.26`, `10/14/2026`.
  static final RegExp numericPattern = RegExp(
    r'(\d{1,2})[./-](\d{1,2})[./-](\d{2,4})',
  );

  /// `14 Oct 2026`, `14 Ekim 2026`, `14 Eki. 26`.
  static final RegExp namedPattern = RegExp(
    r'(\d{1,2})\s+([A-Za-zĞÜŞİÖÇğüşıöç]{3,9})\.?\s*,?\s*(\d{2,4})',
  );

  @override
  Result<DateTime?, ParseFailure> parse(OcrParseInput input) {
    for (final line in input.lines) {
      final date = _parseLine(line);
      if (date != null) return Result.ok(date);
    }
    return const Result.ok(null);
  }

  DateTime? _parseLine(String line) =>
      _fromIsoPattern(line) ?? _fromNumericPattern(line) ?? _fromNamedPattern(line);

  DateTime? _fromIsoPattern(String line) {
    final match = isoPattern.firstMatch(line);
    if (match == null) return null;
    return _buildDate(
      year: int.parse(match.group(1)!),
      month: int.parse(match.group(2)!),
      day: int.parse(match.group(3)!),
    );
  }

  DateTime? _fromNumericPattern(String line) {
    final match = numericPattern.firstMatch(line);
    if (match == null) return null;
    final first = int.parse(match.group(1)!);
    final second = int.parse(match.group(2)!);
    final year = _normalizeYear(int.parse(match.group(3)!));

    // `14/10/2026` and `10/14/2026` are indistinguishable when both numbers are
    // <= 12; day-first is assumed because it is the convention the majority of
    // countries (and both supported languages) use.
    final isDayFirst = first > 12 || second <= 12;
    return _buildDate(
      year: year,
      month: isDayFirst ? second : first,
      day: isDayFirst ? first : second,
    );
  }

  DateTime? _fromNamedPattern(String line) {
    final match = namedPattern.firstMatch(line);
    if (match == null) return null;
    final month = MonthNames.indexOf(match.group(2)!);
    if (month == null) return null;
    return _buildDate(
      year: _normalizeYear(int.parse(match.group(3)!)),
      month: month,
      day: int.parse(match.group(1)!),
    );
  }

  DateTime? _buildDate({
    required int year,
    required int month,
    required int day,
  }) {
    if (year < minYear || year > maxYear) return null;
    if (month < 1 || month > 12) return null;
    if (day < 1 || day > 31) return null;
    final candidate = DateTime(year, month, day);
    if (candidate.day != day || candidate.month != month) return null;
    return candidate;
  }

  int _normalizeYear(int year) => year < 100 ? 2000 + year : year;
}
