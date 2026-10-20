import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr'),
  ];

  /// No description provided for @actionAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get actionAdd;

  /// No description provided for @actionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// No description provided for @actionDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get actionDelete;

  /// No description provided for @actionEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get actionEdit;

  /// No description provided for @actionSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get actionSave;

  /// No description provided for @actionSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get actionSeeAll;

  /// No description provided for @actionSet.
  ///
  /// In en, this message translates to:
  /// **'Set'**
  String get actionSet;

  /// No description provided for @actionTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get actionTryAgain;

  /// No description provided for @navOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get navOverview;

  /// No description provided for @navTransactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get navTransactions;

  /// No description provided for @navBudget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get navBudget;

  /// No description provided for @navCategories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get navCategories;

  /// No description provided for @navReports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get navReports;

  /// No description provided for @dashboardScanTooltip.
  ///
  /// In en, this message translates to:
  /// **'Scan a receipt'**
  String get dashboardScanTooltip;

  /// No description provided for @dashboardRecentTransactions.
  ///
  /// In en, this message translates to:
  /// **'Recent transactions'**
  String get dashboardRecentTransactions;

  /// No description provided for @summaryIncome.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get summaryIncome;

  /// No description provided for @summaryExpenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get summaryExpenses;

  /// No description provided for @summaryBalance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get summaryBalance;

  /// No description provided for @transactionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactionsTitle;

  /// No description provided for @transactionsAddTooltip.
  ///
  /// In en, this message translates to:
  /// **'Add transaction'**
  String get transactionsAddTooltip;

  /// No description provided for @transactionsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No transactions for this month yet.'**
  String get transactionsEmpty;

  /// No description provided for @monthPrevious.
  ///
  /// In en, this message translates to:
  /// **'Previous month'**
  String get monthPrevious;

  /// No description provided for @monthNext.
  ///
  /// In en, this message translates to:
  /// **'Next month'**
  String get monthNext;

  /// No description provided for @addTransactionTitle.
  ///
  /// In en, this message translates to:
  /// **'Add transaction'**
  String get addTransactionTitle;

  /// No description provided for @transactionKindExpense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get transactionKindExpense;

  /// No description provided for @transactionKindIncome.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get transactionKindIncome;

  /// No description provided for @fieldAmountWithSymbol.
  ///
  /// In en, this message translates to:
  /// **'Amount ({symbol})'**
  String fieldAmountWithSymbol(String symbol);

  /// No description provided for @fieldTotalWithSymbol.
  ///
  /// In en, this message translates to:
  /// **'Total ({symbol})'**
  String fieldTotalWithSymbol(String symbol);

  /// No description provided for @fieldCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get fieldCategory;

  /// No description provided for @fieldDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get fieldDate;

  /// No description provided for @fieldDescriptionOptional.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get fieldDescriptionOptional;

  /// No description provided for @fieldMerchant.
  ///
  /// In en, this message translates to:
  /// **'Merchant'**
  String get fieldMerchant;

  /// No description provided for @validationEnterAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount'**
  String get validationEnterAmount;

  /// No description provided for @validationChooseCategory.
  ///
  /// In en, this message translates to:
  /// **'Choose a category'**
  String get validationChooseCategory;

  /// No description provided for @actionSaveTransaction.
  ///
  /// In en, this message translates to:
  /// **'Save transaction'**
  String get actionSaveTransaction;

  /// No description provided for @errorEnterAmountAndCategory.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount and choose a category.'**
  String get errorEnterAmountAndCategory;

  /// No description provided for @errorEnterValidAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount.'**
  String get errorEnterValidAmount;

  /// No description provided for @budgetTitle.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get budgetTitle;

  /// No description provided for @budgetSetMonthlyLimit.
  ///
  /// In en, this message translates to:
  /// **'Set monthly limit'**
  String get budgetSetMonthlyLimit;

  /// No description provided for @budgetMonthlyBudget.
  ///
  /// In en, this message translates to:
  /// **'Monthly budget'**
  String get budgetMonthlyBudget;

  /// No description provided for @budgetNoneSet.
  ///
  /// In en, this message translates to:
  /// **'No budget set for this month.'**
  String get budgetNoneSet;

  /// No description provided for @budgetUpdated.
  ///
  /// In en, this message translates to:
  /// **'Budget updated.'**
  String get budgetUpdated;

  /// No description provided for @budgetLimitWithSymbol.
  ///
  /// In en, this message translates to:
  /// **'Limit ({symbol})'**
  String budgetLimitWithSymbol(String symbol);

  /// No description provided for @budgetOfLimit.
  ///
  /// In en, this message translates to:
  /// **'of {amount}'**
  String budgetOfLimit(String amount);

  /// No description provided for @budgetOverBudget.
  ///
  /// In en, this message translates to:
  /// **'Over budget by {amount}'**
  String budgetOverBudget(String amount);

  /// No description provided for @budgetLeftNearLimit.
  ///
  /// In en, this message translates to:
  /// **'{amount} left — close to the limit'**
  String budgetLeftNearLimit(String amount);

  /// No description provided for @budgetLeft.
  ///
  /// In en, this message translates to:
  /// **'{amount} left'**
  String budgetLeft(String amount);

  /// No description provided for @scanTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan a receipt'**
  String get scanTitle;

  /// No description provided for @scanInstruction.
  ///
  /// In en, this message translates to:
  /// **'Fit the whole receipt in the frame, then tap the shutter.'**
  String get scanInstruction;

  /// No description provided for @scanReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Review receipt'**
  String get scanReviewTitle;

  /// No description provided for @scanReading.
  ///
  /// In en, this message translates to:
  /// **'Reading the receipt…'**
  String get scanReading;

  /// No description provided for @transactionUntitled.
  ///
  /// In en, this message translates to:
  /// **'Untitled transaction'**
  String get transactionUntitled;

  /// No description provided for @categoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categoriesTitle;

  /// No description provided for @categoriesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No categories yet.'**
  String get categoriesEmpty;

  /// No description provided for @categoriesAddTooltip.
  ///
  /// In en, this message translates to:
  /// **'Add category'**
  String get categoriesAddTooltip;

  /// No description provided for @categoryNewTitle.
  ///
  /// In en, this message translates to:
  /// **'New category'**
  String get categoryNewTitle;

  /// No description provided for @categoryEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit category'**
  String get categoryEditTitle;

  /// No description provided for @categorySaved.
  ///
  /// In en, this message translates to:
  /// **'Category saved.'**
  String get categorySaved;

  /// No description provided for @categoryDeleted.
  ///
  /// In en, this message translates to:
  /// **'Category deleted.'**
  String get categoryDeleted;

  /// No description provided for @fieldCategoryName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get fieldCategoryName;

  /// No description provided for @fieldCategoryIcon.
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get fieldCategoryIcon;

  /// No description provided for @fieldCategoryColor.
  ///
  /// In en, this message translates to:
  /// **'Colour'**
  String get fieldCategoryColor;

  /// No description provided for @categoryUsage.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No transactions} =1{1 transaction} other{{count} transactions}}'**
  String categoryUsage(int count);

  /// No description provided for @categoryDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete category?'**
  String get categoryDeleteTitle;

  /// No description provided for @categoryDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete {name}? This cannot be undone.'**
  String categoryDeleteConfirm(String name);

  /// No description provided for @categoryGroceries.
  ///
  /// In en, this message translates to:
  /// **'Groceries'**
  String get categoryGroceries;

  /// No description provided for @categoryDining.
  ///
  /// In en, this message translates to:
  /// **'Dining out'**
  String get categoryDining;

  /// No description provided for @categoryTransport.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get categoryTransport;

  /// No description provided for @categoryShopping.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get categoryShopping;

  /// No description provided for @categoryBills.
  ///
  /// In en, this message translates to:
  /// **'Bills & utilities'**
  String get categoryBills;

  /// No description provided for @categoryHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get categoryHealth;

  /// No description provided for @categoryEntertainment.
  ///
  /// In en, this message translates to:
  /// **'Entertainment'**
  String get categoryEntertainment;

  /// No description provided for @categorySalary.
  ///
  /// In en, this message translates to:
  /// **'Salary'**
  String get categorySalary;

  /// No description provided for @categoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get categoryOther;

  /// No description provided for @reportsTitle.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reportsTitle;

  /// No description provided for @reportsTotalExpenses.
  ///
  /// In en, this message translates to:
  /// **'Total expenses'**
  String get reportsTotalExpenses;

  /// No description provided for @reportsByCategory.
  ///
  /// In en, this message translates to:
  /// **'Expenses by category'**
  String get reportsByCategory;

  /// No description provided for @reportsByMerchant.
  ///
  /// In en, this message translates to:
  /// **'Expenses by shop'**
  String get reportsByMerchant;

  /// No description provided for @reportsNoExpenses.
  ///
  /// In en, this message translates to:
  /// **'No expenses recorded for this month.'**
  String get reportsNoExpenses;

  /// No description provided for @reportsNoMerchants.
  ///
  /// In en, this message translates to:
  /// **'No expenses recorded with a shop.'**
  String get reportsNoMerchants;

  /// No description provided for @reportsUnknownCategory.
  ///
  /// In en, this message translates to:
  /// **'Unknown category'**
  String get reportsUnknownCategory;

  /// No description provided for @reportsOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get reportsOther;

  /// No description provided for @reportsShare.
  ///
  /// In en, this message translates to:
  /// **'{value}%'**
  String reportsShare(int value);

  /// No description provided for @reportsTransactions.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No transactions} other{{count} transactions}}'**
  String reportsTransactions(int count);

  /// No description provided for @errorUnknown.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorUnknown;

  /// No description provided for @errorStorage.
  ///
  /// In en, this message translates to:
  /// **'The local database could not complete the operation.'**
  String get errorStorage;

  /// No description provided for @errorDevice.
  ///
  /// In en, this message translates to:
  /// **'The device could not complete the operation.'**
  String get errorDevice;

  /// No description provided for @errorCameraPermission.
  ///
  /// In en, this message translates to:
  /// **'Camera access is required to scan a receipt.'**
  String get errorCameraPermission;

  /// No description provided for @errorCameraUnavailable.
  ///
  /// In en, this message translates to:
  /// **'No camera is available on this device.'**
  String get errorCameraUnavailable;

  /// No description provided for @errorCameraCaptureFailed.
  ///
  /// In en, this message translates to:
  /// **'The photo could not be captured. Please try again.'**
  String get errorCameraCaptureFailed;

  /// No description provided for @errorOcrEngineUnavailable.
  ///
  /// In en, this message translates to:
  /// **'The text recogniser is no longer available.'**
  String get errorOcrEngineUnavailable;

  /// No description provided for @errorOcrNoText.
  ///
  /// In en, this message translates to:
  /// **'No readable text was found on the receipt.'**
  String get errorOcrNoText;

  /// No description provided for @errorOcrFailed.
  ///
  /// In en, this message translates to:
  /// **'The receipt could not be read. Please try again.'**
  String get errorOcrFailed;

  /// No description provided for @errorParseNoAmount.
  ///
  /// In en, this message translates to:
  /// **'No total amount could be found on the receipt.'**
  String get errorParseNoAmount;

  /// No description provided for @errorParseEmpty.
  ///
  /// In en, this message translates to:
  /// **'The scanned receipt does not contain any readable text.'**
  String get errorParseEmpty;

  /// No description provided for @errorTransactionNotFound.
  ///
  /// In en, this message translates to:
  /// **'That transaction no longer exists.'**
  String get errorTransactionNotFound;

  /// No description provided for @errorCategoryNotFound.
  ///
  /// In en, this message translates to:
  /// **'That category no longer exists.'**
  String get errorCategoryNotFound;

  /// No description provided for @errorNotFound.
  ///
  /// In en, this message translates to:
  /// **'The requested item could not be found.'**
  String get errorNotFound;

  /// No description provided for @errorAmountNotPositive.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount greater than zero.'**
  String get errorAmountNotPositive;

  /// No description provided for @errorCategoryMissing.
  ///
  /// In en, this message translates to:
  /// **'Choose a category for this transaction.'**
  String get errorCategoryMissing;

  /// No description provided for @errorDescriptionTooLong.
  ///
  /// In en, this message translates to:
  /// **'The description is too long.'**
  String get errorDescriptionTooLong;

  /// No description provided for @errorDateOutOfRange.
  ///
  /// In en, this message translates to:
  /// **'Pick a date within this century.'**
  String get errorDateOutOfRange;

  /// No description provided for @errorBudgetNotPositive.
  ///
  /// In en, this message translates to:
  /// **'The monthly budget must be greater than zero.'**
  String get errorBudgetNotPositive;

  /// No description provided for @errorBudgetCurrency.
  ///
  /// In en, this message translates to:
  /// **'Budgets are tracked in {code}.'**
  String errorBudgetCurrency(String code);

  /// No description provided for @errorCategoryNameEmpty.
  ///
  /// In en, this message translates to:
  /// **'Give the category a name.'**
  String get errorCategoryNameEmpty;

  /// No description provided for @errorCategoryNameTooLong.
  ///
  /// In en, this message translates to:
  /// **'The name can be at most 60 characters.'**
  String get errorCategoryNameTooLong;

  /// No description provided for @errorCategoryInUse.
  ///
  /// In en, this message translates to:
  /// **'This category is used by transactions, so it cannot be deleted.'**
  String get errorCategoryInUse;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
