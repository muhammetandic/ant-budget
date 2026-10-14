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

  /// Budget tab.
  static const String budget = '/budget';

  /// Camera screen used to photograph a receipt.
  static const String scan = '/scan';

  /// Review screen of a scanned receipt; expects the image path as `extra`.
  static const String receiptReview = '/scan/review';
}
