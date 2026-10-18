import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ant_budget/features/categories/presentation/providers/category_providers.dart';
import 'package:ant_budget/features/receipt_scan/data/providers/receipt_scan_providers.dart';
import 'package:ant_budget/features/transactions/presentation/providers/transaction_providers.dart';

part 'suggested_category.g.dart';

/// The category to preselect for a receipt whose shop is [merchantName].
///
/// Derived state: the decision itself lives in `SuggestCategoryUseCase`, this
/// provider only feeds it the categories that may be selected and the history
/// them are chosen from. `null` while either is still loading, which is why the
/// review form waits for both before it is built.
@riverpod
int? suggestedCategory(Ref ref, String? merchantName) =>
    ref.watch(suggestCategoryUseCaseProvider)(
      merchantName: merchantName,
      categories: ref.watch(categoriesProvider).value ?? const [],
      past: ref.watch(allTransactionsProvider).value ?? const [],
    );
