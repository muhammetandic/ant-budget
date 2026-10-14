import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:ant_budget/core/values/money.dart';
import 'package:ant_budget/features/receipt_scan/domain/values/ocr_raw_text.dart';

/// A receipt as understood by the parser, ready to be reviewed by the user.
///
/// Only the total is mandatory: a receipt without a readable date or merchant is
/// still useful, and the review screen lets the user fill the gaps.
@immutable
final class ScannedReceipt extends Equatable {
  const ScannedReceipt({
    required this.total,
    required this.purchasedAt,
    this.merchantName,
    this.rawText,
  });

  /// The amount the receipt was paid for.
  final Money total;

  /// Purchase date; falls back to "now" when the receipt has no readable date.
  final DateTime purchasedAt;

  /// Merchant name, when one could be derived from the receipt header.
  final String? merchantName;

  /// The OCR text the receipt was parsed from, kept for transparency and for
  /// re-parsing after a parser improvement.
  final OcrRawText? rawText;

  /// Title to show in the review screen.
  String get displayName {
    final merchant = merchantName?.trim();
    if (merchant != null && merchant.isNotEmpty) return merchant;
    return 'Scanned receipt';
  }

  /// Whether a merchant name was recognised.
  bool get hasMerchantName => displayName != 'Scanned receipt';

  /// Copy with overrides, used while the user edits the parsed values.
  ScannedReceipt copyWith({
    Money? total,
    DateTime? purchasedAt,
    String? merchantName,
  }) => ScannedReceipt(
    total: total ?? this.total,
    purchasedAt: purchasedAt ?? this.purchasedAt,
    merchantName: merchantName ?? this.merchantName,
    rawText: rawText,
  );

  @override
  List<Object?> get props => [total, purchasedAt, merchantName, rawText];
}
