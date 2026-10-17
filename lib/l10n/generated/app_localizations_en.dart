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
}
