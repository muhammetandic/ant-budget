import 'package:ant_budget/core/values/currency.dart';
import 'package:ant_budget/core/values/money.dart';
import 'package:ant_budget/core/values/year_month.dart';
import 'package:ant_budget/features/receipt_scan/domain/values/merchant_key.dart';
import 'package:ant_budget/features/reports/domain/repositories/expense_report_repository.dart';
import 'package:ant_budget/features/reports/domain/values/expense_breakdown.dart';
import 'package:ant_budget/features/reports/domain/values/expense_group.dart';
import 'package:ant_budget/features/reports/domain/values/expense_slice.dart';

/// Streams the category and shop report of a single month.
///
/// The database sums and groups the rows; everything after that — which bucket
/// belongs to which dimension, their order, and the share each one covers of
/// the month's expenses — is decided here, so it stays testable without a
/// database.
final class WatchExpenseBreakdownUseCase {
  WatchExpenseBreakdownUseCase(this._repository, this._currency);

  final ExpenseReportRepository _repository;

  /// Currency the report is restricted to and expressed in.
  final Currency _currency;

  /// Emits the breakdown of [period] and re-emits whenever a write changes it.
  Stream<ExpenseBreakdown> call(YearMonth period) => _repository
      .watchExpenseGroups(period: period, currency: _currency)
      .map((groups) => _breakdown(period, groups));

  /// Folds the grouped rows into the two dimensions of the report.
  ExpenseBreakdown _breakdown(YearMonth period, List<ExpenseGroup> groups) {
    final categories = <int, _Bucket>{};
    final shops = <String, _ShopBucket>{};
    var total = Money.zero(_currency);

    for (final group in groups) {
      total = total + group.amount;
      categories.update(
        group.categoryId,
        (bucket) => bucket..add(group),
        ifAbsent: () => _Bucket(group),
      );

      final merchant = group.merchant?.trim() ?? '';
      if (merchant.isEmpty) continue;
      // The same shop reaches the app in many spellings, and [MerchantKey] is
      // the app's single notion of "which shop is this": the report therefore
      // splits the history exactly the way the category suggestion reads it.
      final key = MerchantKey.of(merchant);
      if (key.isEmpty) continue;
      final shop = shops[key];
      if (shop == null) {
        shops[key] = _ShopBucket(group, merchant);
      } else {
        shop.add(group);
        if (group.lastOccurredAt.isAfter(shop.lastSeenAt)) {
          shop.lastSeenAt = group.lastOccurredAt;
          shop.label = merchant;
        }
      }
    }

    final byCategory = <ExpenseSlice>[];
    for (final entry in _sorted(categories, (a, b) => a.compareTo(b))) {
      byCategory.add(
        ExpenseSlice.category(
          categoryId: entry.key,
          amount: entry.value.amount,
          transactions: entry.value.transactions,
          share: _share(entry.value.amount, total),
        ),
      );
    }
    final byMerchant = <ExpenseSlice>[];
    for (final entry in _sorted(shops, (a, b) => a.compareTo(b))) {
      byMerchant.add(
        ExpenseSlice.merchant(
          merchant: entry.value.label,
          amount: entry.value.amount,
          transactions: entry.value.transactions,
          share: _share(entry.value.amount, total),
        ),
      );
    }

    return ExpenseBreakdown(
      period: period,
      currency: _currency,
      total: total,
      byCategory: byCategory,
      byMerchant: byMerchant,
    );
  }

  /// Buckets ordered by amount, largest first, ties broken by [tieBreak] so
  /// the report never reshuffles between emissions.
  static List<MapEntry<K, V>> _sorted<K, V extends _Bucket>(
    Map<K, V> buckets,
    Comparator<K> tieBreak,
  ) {
    final entries = buckets.entries.toList()
      ..sort((a, b) {
        final byAmount = b.value.amount.minorUnits.compareTo(
          a.value.amount.minorUnits,
        );
        if (byAmount != 0) return byAmount;
        return tieBreak(a.key, b.key);
      });
    return entries;
  }

  /// [amount] as a part of [total]; `0` for a month without expenses.
  static double _share(Money amount, Money total) =>
      total.minorUnits == 0 ? 0 : amount.minorUnits / total.minorUnits;
}

/// Running total of one report slice.
class _Bucket {
  _Bucket(ExpenseGroup group)
    : amount = group.amount,
      transactions = group.transactions;

  Money amount;
  int transactions;

  /// Absorbs another group of the same slice.
  void add(ExpenseGroup group) {
    amount = amount + group.amount;
    transactions += group.transactions;
  }
}

/// A bucket of the shop dimension, which also carries the shop's label.
final class _ShopBucket extends _Bucket {
  _ShopBucket(super.group, this.label) : lastSeenAt = group.lastOccurredAt;

  /// Spelling of the shop shown to the user.
  String label;

  /// When its newest transaction happened: a newer spelling replaces [label].
  DateTime lastSeenAt;
}
