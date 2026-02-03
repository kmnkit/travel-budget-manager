import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ko.dart';

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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('ko'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'TripWallet'**
  String get appTitle;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// No description provided for @trips.
  ///
  /// In en, this message translates to:
  /// **'Trips'**
  String get trips;

  /// No description provided for @expenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get expenses;

  /// No description provided for @exchangeRates.
  ///
  /// In en, this message translates to:
  /// **'Exchange Rates'**
  String get exchangeRates;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @tripTitle.
  ///
  /// In en, this message translates to:
  /// **'Trip Title'**
  String get tripTitle;

  /// No description provided for @baseCurrency.
  ///
  /// In en, this message translates to:
  /// **'Base Currency'**
  String get baseCurrency;

  /// No description provided for @budgetAmount.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get budgetAmount;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDate;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get endDate;

  /// No description provided for @addTrip.
  ///
  /// In en, this message translates to:
  /// **'Add Trip'**
  String get addTrip;

  /// No description provided for @editTrip.
  ///
  /// In en, this message translates to:
  /// **'Edit Trip'**
  String get editTrip;

  /// No description provided for @deleteTrip.
  ///
  /// In en, this message translates to:
  /// **'Delete Trip'**
  String get deleteTrip;

  /// No description provided for @tripTitleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Tokyo Trip'**
  String get tripTitleHint;

  /// No description provided for @tripNotFound.
  ///
  /// In en, this message translates to:
  /// **'Trip not found'**
  String get tripNotFound;

  /// No description provided for @tripLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load trip information'**
  String get tripLoadFailed;

  /// No description provided for @tripCreateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Trip created successfully'**
  String get tripCreateSuccess;

  /// No description provided for @tripCreateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to create trip: {error}'**
  String tripCreateFailed(String error);

  /// No description provided for @tripUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Trip updated successfully'**
  String get tripUpdateSuccess;

  /// No description provided for @tripUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update trip: {error}'**
  String tripUpdateFailed(String error);

  /// No description provided for @tripDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Do you want to delete {tripTitle}?\nAll expense records will also be deleted.'**
  String tripDeleteConfirm(String tripTitle);

  /// No description provided for @tripDeleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Trip deleted successfully'**
  String get tripDeleteSuccess;

  /// No description provided for @tripDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete trip'**
  String get tripDeleteFailed;

  /// No description provided for @noTrips.
  ///
  /// In en, this message translates to:
  /// **'Add your first trip!'**
  String get noTrips;

  /// No description provided for @noTripsDescription.
  ///
  /// In en, this message translates to:
  /// **'Plan a new trip and manage your budget'**
  String get noTripsDescription;

  /// No description provided for @tripStatusUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get tripStatusUpcoming;

  /// No description provided for @tripStatusOngoing.
  ///
  /// In en, this message translates to:
  /// **'Ongoing'**
  String get tripStatusOngoing;

  /// No description provided for @tripStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get tripStatusCompleted;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @memo.
  ///
  /// In en, this message translates to:
  /// **'Memo'**
  String get memo;

  /// No description provided for @memoOptional.
  ///
  /// In en, this message translates to:
  /// **'Memo (Optional)'**
  String get memoOptional;

  /// No description provided for @memoHint.
  ///
  /// In en, this message translates to:
  /// **'Enter memo'**
  String get memoHint;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @addExpense.
  ///
  /// In en, this message translates to:
  /// **'Add Expense'**
  String get addExpense;

  /// No description provided for @editExpense.
  ///
  /// In en, this message translates to:
  /// **'Edit Expense'**
  String get editExpense;

  /// No description provided for @deleteExpense.
  ///
  /// In en, this message translates to:
  /// **'Delete Expense'**
  String get deleteExpense;

  /// No description provided for @noExpenses.
  ///
  /// In en, this message translates to:
  /// **'Record your first expense!'**
  String get noExpenses;

  /// No description provided for @expenseLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load expense list'**
  String get expenseLoadFailed;

  /// No description provided for @expenseListLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load expense list'**
  String get expenseListLoadFailed;

  /// No description provided for @expenseCreateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Expense added successfully'**
  String get expenseCreateSuccess;

  /// No description provided for @expenseCreateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to save: {error}'**
  String expenseCreateFailed(String error);

  /// No description provided for @expenseUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Expense updated successfully'**
  String get expenseUpdateSuccess;

  /// No description provided for @expenseUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update expense'**
  String get expenseUpdateFailed;

  /// No description provided for @expenseDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Do you want to delete {item}?'**
  String expenseDeleteConfirm(String item);

  /// No description provided for @expenseDeleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Expense deleted successfully'**
  String get expenseDeleteSuccess;

  /// No description provided for @expenseDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete expense'**
  String get expenseDeleteFailed;

  /// No description provided for @categoryRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select a category'**
  String get categoryRequired;

  /// No description provided for @paymentMethodRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select a payment method'**
  String get paymentMethodRequired;

  /// No description provided for @enterValidAmount.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid amount'**
  String get enterValidAmount;

  /// No description provided for @conversionInProgress.
  ///
  /// In en, this message translates to:
  /// **'Currency conversion in progress. Please wait.'**
  String get conversionInProgress;

  /// No description provided for @noPaymentMethods.
  ///
  /// In en, this message translates to:
  /// **'No payment methods available. Please add a payment method first.'**
  String get noPaymentMethods;

  /// No description provided for @categoryFood.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get categoryFood;

  /// No description provided for @categoryTransport.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get categoryTransport;

  /// No description provided for @categoryAccommodation.
  ///
  /// In en, this message translates to:
  /// **'Accommodation'**
  String get categoryAccommodation;

  /// No description provided for @categoryShopping.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get categoryShopping;

  /// No description provided for @categoryEntertainment.
  ///
  /// In en, this message translates to:
  /// **'Entertainment'**
  String get categoryEntertainment;

  /// No description provided for @categorySightseeing.
  ///
  /// In en, this message translates to:
  /// **'Sightseeing'**
  String get categorySightseeing;

  /// No description provided for @categoryCommunication.
  ///
  /// In en, this message translates to:
  /// **'Communication'**
  String get categoryCommunication;

  /// No description provided for @categoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get categoryOther;

  /// No description provided for @paymentMethods.
  ///
  /// In en, this message translates to:
  /// **'Payment Methods'**
  String get paymentMethods;

  /// No description provided for @addPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Add Payment Method'**
  String get addPaymentMethod;

  /// No description provided for @editPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Edit Payment Method'**
  String get editPaymentMethod;

  /// No description provided for @deletePaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Delete Payment Method'**
  String get deletePaymentMethod;

  /// No description provided for @paymentMethodName.
  ///
  /// In en, this message translates to:
  /// **'Payment Method Name'**
  String get paymentMethodName;

  /// No description provided for @defaultPayment.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get defaultPayment;

  /// No description provided for @setAsDefault.
  ///
  /// In en, this message translates to:
  /// **'Set as Default'**
  String get setAsDefault;

  /// No description provided for @paymentMethodAdded.
  ///
  /// In en, this message translates to:
  /// **'Payment method added'**
  String get paymentMethodAdded;

  /// No description provided for @paymentMethodUpdated.
  ///
  /// In en, this message translates to:
  /// **'Payment method updated'**
  String get paymentMethodUpdated;

  /// No description provided for @paymentMethodDeleted.
  ///
  /// In en, this message translates to:
  /// **'Payment method deleted'**
  String get paymentMethodDeleted;

  /// No description provided for @paymentMethodDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Do you want to delete {name}?'**
  String paymentMethodDeleteConfirm(String name);

  /// No description provided for @paymentMethodSetDefault.
  ///
  /// In en, this message translates to:
  /// **'{name} has been set as the default payment method'**
  String paymentMethodSetDefault(String name);

  /// No description provided for @paymentMethodAddFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to add: {error}'**
  String paymentMethodAddFailed(String error);

  /// No description provided for @paymentMethodUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update: {error}'**
  String paymentMethodUpdateFailed(String error);

  /// No description provided for @paymentMethodDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete: {error}'**
  String paymentMethodDeleteFailed(String error);

  /// No description provided for @paymentMethodSetDefaultFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to set default: {error}'**
  String paymentMethodSetDefaultFailed(String error);

  /// No description provided for @paymentMethodLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load payment methods: {error}'**
  String paymentMethodLoadFailed(String error);

  /// No description provided for @noPaymentMethodsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No payment methods available'**
  String get noPaymentMethodsAvailable;

  /// No description provided for @paymentCash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get paymentCash;

  /// No description provided for @paymentCreditCard.
  ///
  /// In en, this message translates to:
  /// **'Credit Card'**
  String get paymentCreditCard;

  /// No description provided for @paymentDebitCard.
  ///
  /// In en, this message translates to:
  /// **'Debit Card'**
  String get paymentDebitCard;

  /// No description provided for @paymentTransitCard.
  ///
  /// In en, this message translates to:
  /// **'Transit Card'**
  String get paymentTransitCard;

  /// No description provided for @paymentOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get paymentOther;

  /// No description provided for @budget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get budget;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @remaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get remaining;

  /// No description provided for @used.
  ///
  /// In en, this message translates to:
  /// **'Used'**
  String get used;

  /// No description provided for @budgetComfortable.
  ///
  /// In en, this message translates to:
  /// **'Comfortable'**
  String get budgetComfortable;

  /// No description provided for @budgetCaution.
  ///
  /// In en, this message translates to:
  /// **'Caution'**
  String get budgetCaution;

  /// No description provided for @budgetWarning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get budgetWarning;

  /// No description provided for @budgetExceeded.
  ///
  /// In en, this message translates to:
  /// **'Exceeded'**
  String get budgetExceeded;

  /// No description provided for @autoRate.
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get autoRate;

  /// No description provided for @manualRate.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get manualRate;

  /// No description provided for @refreshRate.
  ///
  /// In en, this message translates to:
  /// **'Refresh Exchange Rates'**
  String get refreshRate;

  /// No description provided for @lastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last Updated'**
  String get lastUpdated;

  /// No description provided for @noExchangeRates.
  ///
  /// In en, this message translates to:
  /// **'No exchange rates registered'**
  String get noExchangeRates;

  /// No description provided for @exchangeRateLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load exchange rate information\n{error}'**
  String exchangeRateLoadFailed(String error);

  /// No description provided for @exchangeRateRefreshHint.
  ///
  /// In en, this message translates to:
  /// **'Press the refresh button to fetch exchange rates'**
  String get exchangeRateRefreshHint;

  /// No description provided for @exchangeRateLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading exchange rate information...'**
  String get exchangeRateLoading;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noData;

  /// No description provided for @noExpenseData.
  ///
  /// In en, this message translates to:
  /// **'No expense data available'**
  String get noExpenseData;

  /// No description provided for @noExpenseDataInPeriod.
  ///
  /// In en, this message translates to:
  /// **'No expense records in the selected period'**
  String get noExpenseDataInPeriod;

  /// No description provided for @statisticsLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load statistics data\n{error}'**
  String statisticsLoadFailed(String error);

  /// No description provided for @statisticsCalculating.
  ///
  /// In en, this message translates to:
  /// **'Calculating statistics...'**
  String get statisticsCalculating;

  /// No description provided for @periodAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get periodAll;

  /// No description provided for @periodWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get periodWeek;

  /// No description provided for @periodMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get periodMonth;

  /// No description provided for @periodCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get periodCustom;

  /// No description provided for @allCategories.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allCategories;

  /// No description provided for @sortByDate.
  ///
  /// In en, this message translates to:
  /// **'Latest First'**
  String get sortByDate;

  /// No description provided for @sortByAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get sortByAmount;

  /// No description provided for @selectDefaultCurrency.
  ///
  /// In en, this message translates to:
  /// **'Select Default Currency'**
  String get selectDefaultCurrency;

  /// No description provided for @totalBalance.
  ///
  /// In en, this message translates to:
  /// **'TOTAL BALANCE'**
  String get totalBalance;

  /// No description provided for @filterAllTrips.
  ///
  /// In en, this message translates to:
  /// **'All Trips'**
  String get filterAllTrips;

  /// No description provided for @filterActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get filterActive;

  /// No description provided for @filterPast.
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get filterPast;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageKorean.
  ///
  /// In en, this message translates to:
  /// **'Korean'**
  String get languageKorean;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @defaultCurrency.
  ///
  /// In en, this message translates to:
  /// **'Default Currency'**
  String get defaultCurrency;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @data.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get data;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @backup.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get backup;

  /// No description provided for @restore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restore;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @licenses.
  ///
  /// In en, this message translates to:
  /// **'Open Source Licenses'**
  String get licenses;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;

  /// No description provided for @validationTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Title is required'**
  String get validationTitleRequired;

  /// No description provided for @validationTitleTooLong.
  ///
  /// In en, this message translates to:
  /// **'Title must be 100 characters or less'**
  String get validationTitleTooLong;

  /// No description provided for @validationBudgetRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a budget'**
  String get validationBudgetRequired;

  /// No description provided for @validationBudgetPositive.
  ///
  /// In en, this message translates to:
  /// **'Budget must be positive'**
  String get validationBudgetPositive;

  /// No description provided for @validationEndDateAfterStart.
  ///
  /// In en, this message translates to:
  /// **'End date must be after start date'**
  String get validationEndDateAfterStart;

  /// No description provided for @validationAmountPositive.
  ///
  /// In en, this message translates to:
  /// **'Amount must be positive'**
  String get validationAmountPositive;

  /// No description provided for @validationCategoryRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select a category'**
  String get validationCategoryRequired;

  /// No description provided for @validationPaymentRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select a payment method'**
  String get validationPaymentRequired;

  /// No description provided for @enterTripTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter trip title'**
  String get enterTripTitle;

  /// No description provided for @enterBudget.
  ///
  /// In en, this message translates to:
  /// **'Enter budget'**
  String get enterBudget;

  /// No description provided for @enterAmountGreaterThanZero.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount greater than 0'**
  String get enterAmountGreaterThanZero;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Network error occurred'**
  String get networkError;

  /// No description provided for @offlineMode.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offlineMode;

  /// No description provided for @loadFailed.
  ///
  /// In en, this message translates to:
  /// **'Load failed'**
  String get loadFailed;

  /// No description provided for @saveFailed.
  ///
  /// In en, this message translates to:
  /// **'Save failed'**
  String get saveFailed;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred'**
  String get unknownError;
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
      <String>['en', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ko':
      return AppLocalizationsKo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
