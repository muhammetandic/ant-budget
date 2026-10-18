import 'package:ant_budget/features/categories/domain/entities/category.dart';
import 'package:ant_budget/features/receipt_scan/domain/values/merchant_category_rules.dart';
import 'package:ant_budget/features/receipt_scan/domain/values/merchant_key.dart';
import 'package:ant_budget/features/transactions/domain/entities/transaction.dart';

/// Proposes the category a scanned receipt belongs to, so the review screen
/// opens with the dropdown already filled in.
///
/// Two signals are combined, the user's own first:
///
/// * what this shop was filed under last time — a neighbourhood grocer is
///   whatever the user picked for it, so it only has to be corrected once;
/// * [MerchantCategoryRules], which knows the chains (`BİM` is a grocery shop).
///
/// The proposal is never a decision: the reviewer sees it in an editable
/// dropdown and can pick something else.
final class SuggestCategoryUseCase {
  const SuggestCategoryUseCase();

  /// The id of the category to preselect, or `null` when nothing fits.
  ///
  /// [categories] are the categories that may be selected and [past] every
  /// recorded transaction, in any order.
  int? call({
    required String? merchantName,
    required List<Category> categories,
    required List<Transaction> past,
  }) {
    final merchant = merchantName?.trim() ?? '';
    // A merchant without a usable name would key to the empty string, which
    // every other nameless receipt shares; guessing a category from that would
    // be inventing a match.
    if (merchant.isEmpty || categories.isEmpty) return null;
    if (MerchantKey.of(merchant).isEmpty) return null;

    return _fromHistory(merchant, categories, past) ??
        _fromRules(merchant, categories);
  }

  /// The category the most recent receipt from this shop was filed under.
  ///
  /// Recency rather than frequency: the latest decision is the one worth
  /// repeating, and changing a suggestion therefore sticks immediately.
  int? _fromHistory(
    String merchant,
    List<Category> categories,
    List<Transaction> past,
  ) {
    final key = MerchantKey.of(merchant);
    Transaction? latest;
    for (final transaction in past) {
      final stored = transaction.receiptMerchant;
      if (stored == null || MerchantKey.of(stored) != key) continue;
      if (latest == null || transaction.occurredAt.isAfter(latest.occurredAt)) {
        latest = transaction;
      }
    }
    if (latest == null) return null;
    return _selectable(categories, latest.categoryId);
  }

  /// The category the shop catalogue lists for [merchant].
  int? _fromRules(String merchant, List<Category> categories) {
    final name = MerchantCategoryRules.categoryNameFor(merchant);
    if (name == null) return null;
    for (final category in categories) {
      if (category.isDefault && category.name == name) return category.id;
    }
    return null;
  }

  /// [categoryId] when [categories] offers it.
  ///
  /// A dropdown given a value that is not among its items throws, so a
  /// suggestion that no longer exists (a category the user removed) has to be
  /// dropped rather than forwarded.
  int? _selectable(List<Category> categories, int? categoryId) =>
      categories.any((category) => category.id == categoryId)
      ? categoryId
      : null;
}
