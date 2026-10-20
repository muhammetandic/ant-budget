/// Barrel file for the Drift schema.
///
/// The whole schema lives next to [AppDatabase] so that the generated database
/// never has to reach back into a feature; features only depend on it.
library;

export 'budgets_table.dart';
export 'categories_table.dart';
export 'category_budgets_table.dart';
export 'transactions_table.dart';
