import 'package:ant_budget/core/values/currency.dart';

/// Compile-time configuration of the application.
///
/// Values that a product owner may want to tweak live here instead of being
/// scattered as magic constants across the code base.
abstract final class AppConfig {
  /// Product name shown in the UI and the platform shells.
  static const String appName = 'Ant Budget';

  /// File name of the local SQLite database (without extension).
  static const String databaseName = 'ant_budget';

  /// Currency used for budgets and monthly reports when nothing more specific
  /// can be derived (e.g. the receipt has no currency symbol).
  ///
  /// Transactions keep their own currency; only *reporting* is single-currency
  /// in this version, which is why this value is injected into the use cases
  /// that aggregate money.
  static const Currency reportingCurrency = Currency.turkishLira;
}
