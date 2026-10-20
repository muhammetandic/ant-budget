// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get actionAdd => 'Add';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionDelete => 'Delete';

  @override
  String get actionEdit => 'Edit';

  @override
  String get actionSave => 'Save';

  @override
  String get actionSeeAll => 'See all';

  @override
  String get actionSet => 'Set';

  @override
  String get actionTryAgain => 'Try again';

  @override
  String get navOverview => 'Overview';

  @override
  String get navTransactions => 'Transactions';

  @override
  String get navBudget => 'Budget';

  @override
  String get navCategories => 'Categories';

  @override
  String get navReports => 'Reports';

  @override
  String get dashboardScanTooltip => 'Scan a receipt';

  @override
  String get dashboardRecentTransactions => 'Recent transactions';

  @override
  String get summaryIncome => 'Income';

  @override
  String get summaryExpenses => 'Expenses';

  @override
  String get summaryBalance => 'Balance';

  @override
  String get transactionsTitle => 'Transactions';

  @override
  String get transactionsAddTooltip => 'Add transaction';

  @override
  String get transactionsEmpty => 'No transactions for this month yet.';

  @override
  String get monthPrevious => 'Previous month';

  @override
  String get monthNext => 'Next month';

  @override
  String get addTransactionTitle => 'Add transaction';

  @override
  String get editTransactionTitle => 'Edit transaction';

  @override
  String get transactionKindExpense => 'Expense';

  @override
  String get transactionKindIncome => 'Income';

  @override
  String fieldAmountWithSymbol(String symbol) {
    return 'Amount ($symbol)';
  }

  @override
  String fieldTotalWithSymbol(String symbol) {
    return 'Total ($symbol)';
  }

  @override
  String get fieldCategory => 'Category';

  @override
  String get fieldDate => 'Date';

  @override
  String get fieldDescriptionOptional => 'Description (optional)';

  @override
  String get fieldMerchant => 'Merchant';

  @override
  String get validationEnterAmount => 'Enter a valid amount';

  @override
  String get validationChooseCategory => 'Choose a category';

  @override
  String get actionSaveTransaction => 'Save transaction';

  @override
  String get errorEnterAmountAndCategory =>
      'Enter an amount and choose a category.';

  @override
  String get errorEnterValidAmount => 'Enter a valid amount.';

  @override
  String get budgetTitle => 'Budget';

  @override
  String get budgetSetMonthlyLimit => 'Set monthly limit';

  @override
  String get budgetMonthlyBudget => 'Monthly budget';

  @override
  String get budgetNoneSet => 'No budget set for this month.';

  @override
  String get budgetUpdated => 'Budget updated.';

  @override
  String budgetLimitWithSymbol(String symbol) {
    return 'Limit ($symbol)';
  }

  @override
  String budgetOfLimit(String amount) {
    return 'of $amount';
  }

  @override
  String budgetOverBudget(String amount) {
    return 'Over budget by $amount';
  }

  @override
  String budgetLeftNearLimit(String amount) {
    return '$amount left — close to the limit';
  }

  @override
  String budgetLeft(String amount) {
    return '$amount left';
  }

  @override
  String get budgetByCategory => 'Budget by category';

  @override
  String get budgetCategoryAdd => 'Add category budget';

  @override
  String get budgetCategoryNoneSet => 'No category budget set for this month.';

  @override
  String get budgetCategoryDeleteTitle => 'Delete budget?';

  @override
  String budgetCategoryDeleteConfirm(String name) {
    return 'Delete this month\'s budget for $name?';
  }

  @override
  String get budgetCategoryDeleted => 'Category budget deleted.';

  @override
  String get scanTitle => 'Scan a receipt';

  @override
  String get scanInstruction =>
      'Fit the whole receipt in the frame, then tap the shutter.';

  @override
  String get scanReviewTitle => 'Review receipt';

  @override
  String get scanReading => 'Reading the receipt…';

  @override
  String get transactionUntitled => 'Untitled transaction';

  @override
  String get transactionDeleteTitle => 'Delete transaction?';

  @override
  String transactionDeleteConfirm(String title) {
    return 'Delete $title? This cannot be undone.';
  }

  @override
  String get transactionDeleted => 'Transaction deleted.';

  @override
  String get categoriesTitle => 'Categories';

  @override
  String get categoriesEmpty => 'No categories yet.';

  @override
  String get categoriesAddTooltip => 'Add category';

  @override
  String get categoryNewTitle => 'New category';

  @override
  String get categoryEditTitle => 'Edit category';

  @override
  String get categorySaved => 'Category saved.';

  @override
  String get categoryDeleted => 'Category deleted.';

  @override
  String get fieldCategoryName => 'Name';

  @override
  String get fieldCategoryIcon => 'Icon';

  @override
  String get fieldCategoryColor => 'Colour';

  @override
  String categoryUsage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transactions',
      one: '1 transaction',
      zero: 'No transactions',
    );
    return '$_temp0';
  }

  @override
  String get categoryDeleteTitle => 'Delete category?';

  @override
  String categoryDeleteConfirm(String name) {
    return 'Delete $name? This cannot be undone.';
  }

  @override
  String get categoryGroceries => 'Groceries';

  @override
  String get categoryDining => 'Dining out';

  @override
  String get categoryTransport => 'Transport';

  @override
  String get categoryShopping => 'Shopping';

  @override
  String get categoryBills => 'Bills & utilities';

  @override
  String get categoryHealth => 'Health';

  @override
  String get categoryEntertainment => 'Entertainment';

  @override
  String get categorySalary => 'Salary';

  @override
  String get categoryOther => 'Other';

  @override
  String get reportsTitle => 'Reports';

  @override
  String get reportsTotalExpenses => 'Total expenses';

  @override
  String get reportsByCategory => 'Expenses by category';

  @override
  String get reportsByMerchant => 'Expenses by shop';

  @override
  String get reportsNoExpenses => 'No expenses recorded for this month.';

  @override
  String get reportsNoMerchants => 'No expenses recorded with a shop.';

  @override
  String get reportsUnknownCategory => 'Unknown category';

  @override
  String get reportsOther => 'Other';

  @override
  String reportsShare(int value) {
    return '$value%';
  }

  @override
  String reportsTransactions(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transactions',
      zero: 'No transactions',
    );
    return '$_temp0';
  }

  @override
  String get errorUnknown => 'Something went wrong. Please try again.';

  @override
  String get errorStorage =>
      'The local database could not complete the operation.';

  @override
  String get errorDevice => 'The device could not complete the operation.';

  @override
  String get errorCameraPermission =>
      'Camera access is required to scan a receipt.';

  @override
  String get errorCameraUnavailable => 'No camera is available on this device.';

  @override
  String get errorCameraCaptureFailed =>
      'The photo could not be captured. Please try again.';

  @override
  String get errorOcrEngineUnavailable =>
      'The text recogniser is no longer available.';

  @override
  String get errorOcrNoText => 'No readable text was found on the receipt.';

  @override
  String get errorOcrFailed =>
      'The receipt could not be read. Please try again.';

  @override
  String get errorParseNoAmount =>
      'No total amount could be found on the receipt.';

  @override
  String get errorParseEmpty =>
      'The scanned receipt does not contain any readable text.';

  @override
  String get errorTransactionNotFound => 'That transaction no longer exists.';

  @override
  String get errorCategoryNotFound => 'That category no longer exists.';

  @override
  String get errorNotFound => 'The requested item could not be found.';

  @override
  String get errorAmountNotPositive => 'Enter an amount greater than zero.';

  @override
  String get errorCategoryMissing => 'Choose a category for this transaction.';

  @override
  String get errorDescriptionTooLong => 'The description is too long.';

  @override
  String get errorDateOutOfRange => 'Pick a date within this century.';

  @override
  String get errorBudgetNotPositive =>
      'The monthly budget must be greater than zero.';

  @override
  String errorBudgetCurrency(String code) {
    return 'Budgets are tracked in $code.';
  }

  @override
  String get errorCategoryNameEmpty => 'Give the category a name.';

  @override
  String get errorCategoryNameTooLong =>
      'The name can be at most 60 characters.';

  @override
  String get errorCategoryInUse =>
      'This category is used by transactions, so it cannot be deleted.';
}
