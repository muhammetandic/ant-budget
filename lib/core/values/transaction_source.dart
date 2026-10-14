/// How a [Transaction] was created.
///
/// Kept on the entity so the UI can show provenance and so automated imports
/// (OCR, bank sync, ...) can be told apart from hand written entries.
enum TransactionSource {
  /// Typed in manually by the user.
  manual,

  /// Extracted from a scanned receipt through the OCR pipeline.
  receiptScan,
}
