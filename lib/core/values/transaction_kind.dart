/// Direction of a [Transaction].
enum TransactionKind {
  /// Money leaving the budget.
  expense,

  /// Money entering the budget.
  income;

  /// Whether this kind reduces the available budget.
  bool get isExpense => this == TransactionKind.expense;

  /// Whether this kind increases the available budget.
  bool get isIncome => this == TransactionKind.income;
}
