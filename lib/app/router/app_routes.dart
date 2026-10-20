/// Every route path of the application, in one place.
///
/// Referencing constants instead of string literals keeps navigation typo-proof
/// and makes a route rename a single edit.
abstract final class AppRoutes {
  /// Overview tab.
  static const String dashboard = '/';

  /// Transaction history tab.
  static const String transactions = '/transactions';

  /// New transaction form (pushed on top of the shell).
  static const String addTransaction = '/transactions/new';

  /// Edit form of a stored transaction; expects it as `extra`.
  static const String editTransaction = '/transactions/edit';

  /// Budget tab.
  static const String budget = '/budget';

  /// Category management tab.
  static const String categories = '/categories';

  /// Expense reports tab.
  static const String reports = '/reports';

  /// Camera screen used to photograph a receipt.
  static const String scan = '/scan';

  /// Review screen of a scanned receipt; expects the image path as `extra`.
  static const String receiptReview = '/scan/review';
}
