import 'package:flutter_test/flutter_test.dart';
import 'package:ant_budget/core/values/category_icon.dart';
import 'package:ant_budget/core/values/currency.dart';
import 'package:ant_budget/core/values/money.dart';
import 'package:ant_budget/core/values/transaction_kind.dart';
import 'package:ant_budget/features/categories/domain/entities/category.dart';
import 'package:ant_budget/features/receipt_scan/domain/usecases/suggest_category_usecase.dart';
import 'package:ant_budget/features/transactions/domain/entities/transaction.dart';

/// The business rules of "which category does this shop belong to", with no
/// database, camera or widget in sight.
void main() {
  const useCase = SuggestCategoryUseCase();

  Category category(int id, String name) => Category(
    id: id,
    name: name,
    icon: CategoryIcon.other,
    colorValue: 0,
    isDefault: true,
  );

  final categories = [
    category(1, 'Groceries'),
    category(2, 'Dining out'),
    category(3, 'Transport'),
  ];

  Transaction filed(String? merchant, int categoryId, {DateTime? at}) =>
      Transaction(
        amount: const Money(1000, Currency.turkishLira),
        categoryId: categoryId,
        occurredAt: at ?? DateTime(2026, 10, 14),
        kind: TransactionKind.expense,
        receiptMerchant: merchant,
      );

  int? suggest(
    String? merchant, {
    List<Transaction> past = const [],
    List<Category>? available,
  }) => useCase(
    merchantName: merchant,
    categories: available ?? categories,
    past: past,
  );

  test('preselects the shop category of a known chain', () {
    expect(suggest('ŞOK'), 1);
    expect(suggest('BİM'), 1);
    expect(suggest('Migros'), 1);
    expect(suggest('Starbucks'), 2);
    expect(suggest('OPET'), 3);
  });

  test('sees through the spelling the recogniser produces', () {
    expect(suggest('SOK'), 1);
    expect(suggest('SSUK MARKETLER'), 1);
  });

  test('uses the category this shop was filed under before', () {
    final past = [filed('Yıldız Bakkal', 3)];

    expect(suggest('Yıldız Bakkal', past: past), 3);
    // The shop is recognised again with a different spelling.
    expect(suggest('YILDIZ BAKKAL A.Ş.', past: past), 3);
  });

  test('lets the user history win over the shop catalogue', () {
    // The user buys their groceries at the petrol station and filed it as
    // Transport; the catalogue's Groceries guess must not come back.
    final past = [filed('OPET', 3)];

    expect(suggest('OPET', past: past), 3);
  });

  test('repeats the most recent decision, not the most frequent one', () {
    final past = [
      filed('Migros', 2, at: DateTime(2026, 9, 1)),
      filed('Migros', 2, at: DateTime(2026, 9, 2)),
      filed('Migros', 3, at: DateTime(2026, 10, 10)),
    ];

    expect(suggest('Migros', past: past), 3);
  });

  test('ignores the history of other shops', () {
    final past = [filed('Migros', 2)];

    expect(suggest('Yıldız Bakkal', past: past), isNull);
  });

  test('ignores transactions that carry no merchant', () {
    // A hand typed transaction is not evidence about any shop.
    final past = [filed(null, 3)];

    expect(suggest('Yıldız Bakkal', past: past), isNull);
  });

  test('suggests nothing for a shop it has never seen', () {
    expect(suggest('Yıldız Bakkal'), isNull);
    expect(suggest('Mehmet Market'), isNull);
  });

  test('suggests nothing without a merchant name', () {
    expect(suggest(null), isNull);
    expect(suggest('   '), isNull);
    expect(suggest('8718'), isNull);
  });

  test('drops a category the dropdown would not offer', () {
    // The user renamed or deleted the seeded category the catalogue points at.
    final renamed = [category(2, 'Dining out'), category(3, 'Transport')];

    expect(suggest('BİM', available: renamed), isNull);
  });

  test('drops a historical category that is no longer available', () {
    final past = [filed('Yıldız Bakkal', 1)];
    final remaining = [category(2, 'Dining out'), category(3, 'Transport')];

    expect(suggest('Yıldız Bakkal', past: past, available: remaining), isNull);
  });
}
