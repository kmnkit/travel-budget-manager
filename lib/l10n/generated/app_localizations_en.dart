// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'TripWallet';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get add => 'Add';

  @override
  String get retry => 'Retry';

  @override
  String get settings => 'Settings';

  @override
  String get loading => 'Loading';

  @override
  String get trips => 'Trips';

  @override
  String get expenses => 'Expenses';

  @override
  String get exchangeRates => 'Exchange Rates';

  @override
  String get statistics => 'Statistics';

  @override
  String get tripTitle => 'Trip Title';

  @override
  String get baseCurrency => 'Base Currency';

  @override
  String get budgetAmount => 'Budget';

  @override
  String get startDate => 'Start Date';

  @override
  String get endDate => 'End Date';

  @override
  String get addTrip => 'Add Trip';

  @override
  String get editTrip => 'Edit Trip';

  @override
  String get deleteTrip => 'Delete Trip';

  @override
  String get tripTitleHint => 'e.g., Tokyo Trip';

  @override
  String get tripNotFound => 'Trip not found';

  @override
  String get tripLoadFailed => 'Failed to load trip information';

  @override
  String get tripCreateSuccess => 'Trip created successfully';

  @override
  String tripCreateFailed(String error) {
    return 'Failed to create trip: $error';
  }

  @override
  String get tripUpdateSuccess => 'Trip updated successfully';

  @override
  String tripUpdateFailed(String error) {
    return 'Failed to update trip: $error';
  }

  @override
  String tripDeleteConfirm(String tripTitle) {
    return 'Do you want to delete $tripTitle?\nAll expense records will also be deleted.';
  }

  @override
  String get tripDeleteSuccess => 'Trip deleted successfully';

  @override
  String get tripDeleteFailed => 'Failed to delete trip';

  @override
  String get noTrips => 'Add your first trip!';

  @override
  String get noTripsDescription => 'Plan a new trip and manage your budget';

  @override
  String get tripStatusUpcoming => 'Upcoming';

  @override
  String get tripStatusOngoing => 'Ongoing';

  @override
  String get tripStatusCompleted => 'Completed';

  @override
  String get error => 'Error';

  @override
  String get amount => 'Amount';

  @override
  String get memo => 'Memo';

  @override
  String get memoOptional => 'Memo (Optional)';

  @override
  String get memoHint => 'Enter memo';

  @override
  String get category => 'Category';

  @override
  String get paymentMethod => 'Payment Method';

  @override
  String get date => 'Date';

  @override
  String get addExpense => 'Add Expense';

  @override
  String get editExpense => 'Edit Expense';

  @override
  String get deleteExpense => 'Delete Expense';

  @override
  String get noExpenses => 'Record your first expense!';

  @override
  String get expenseLoadFailed => 'Failed to load expense list';

  @override
  String get expenseListLoadFailed => 'Failed to load expense list';

  @override
  String get expenseCreateSuccess => 'Expense added successfully';

  @override
  String expenseCreateFailed(String error) {
    return 'Failed to save: $error';
  }

  @override
  String get expenseUpdateSuccess => 'Expense updated successfully';

  @override
  String get expenseUpdateFailed => 'Failed to update expense';

  @override
  String expenseDeleteConfirm(String item) {
    return 'Do you want to delete $item?';
  }

  @override
  String get expenseDeleteSuccess => 'Expense deleted successfully';

  @override
  String get expenseDeleteFailed => 'Failed to delete expense';

  @override
  String get categoryRequired => 'Please select a category';

  @override
  String get paymentMethodRequired => 'Please select a payment method';

  @override
  String get enterValidAmount => 'Please enter a valid amount';

  @override
  String get conversionInProgress =>
      'Currency conversion in progress. Please wait.';

  @override
  String get noPaymentMethods =>
      'No payment methods available. Please add a payment method first.';

  @override
  String get categoryFood => 'Food';

  @override
  String get categoryTransport => 'Transport';

  @override
  String get categoryAccommodation => 'Accommodation';

  @override
  String get categoryShopping => 'Shopping';

  @override
  String get categoryEntertainment => 'Entertainment';

  @override
  String get categorySightseeing => 'Sightseeing';

  @override
  String get categoryCommunication => 'Communication';

  @override
  String get categoryOther => 'Other';

  @override
  String get paymentMethods => 'Payment Methods';

  @override
  String get addPaymentMethod => 'Add Payment Method';

  @override
  String get editPaymentMethod => 'Edit Payment Method';

  @override
  String get deletePaymentMethod => 'Delete Payment Method';

  @override
  String get paymentMethodName => 'Payment Method Name';

  @override
  String get defaultPayment => 'Default';

  @override
  String get setAsDefault => 'Set as Default';

  @override
  String get paymentMethodAdded => 'Payment method added';

  @override
  String get paymentMethodUpdated => 'Payment method updated';

  @override
  String get paymentMethodDeleted => 'Payment method deleted';

  @override
  String paymentMethodDeleteConfirm(String name) {
    return 'Do you want to delete $name?';
  }

  @override
  String paymentMethodSetDefault(String name) {
    return '$name has been set as the default payment method';
  }

  @override
  String paymentMethodAddFailed(String error) {
    return 'Failed to add: $error';
  }

  @override
  String paymentMethodUpdateFailed(String error) {
    return 'Failed to update: $error';
  }

  @override
  String paymentMethodDeleteFailed(String error) {
    return 'Failed to delete: $error';
  }

  @override
  String paymentMethodSetDefaultFailed(String error) {
    return 'Failed to set default: $error';
  }

  @override
  String paymentMethodLoadFailed(String error) {
    return 'Failed to load payment methods: $error';
  }

  @override
  String get noPaymentMethodsAvailable => 'No payment methods available';

  @override
  String get paymentCash => 'Cash';

  @override
  String get paymentCreditCard => 'Credit Card';

  @override
  String get paymentDebitCard => 'Debit Card';

  @override
  String get paymentTransitCard => 'Transit Card';

  @override
  String get paymentOther => 'Other';

  @override
  String get budget => 'Budget';

  @override
  String get total => 'Total';

  @override
  String get remaining => 'Remaining';

  @override
  String get used => 'Used';

  @override
  String get budgetComfortable => 'Comfortable';

  @override
  String get budgetCaution => 'Caution';

  @override
  String get budgetWarning => 'Warning';

  @override
  String get budgetExceeded => 'Exceeded';

  @override
  String get autoRate => 'Auto';

  @override
  String get manualRate => 'Manual';

  @override
  String get refreshRate => 'Refresh Exchange Rates';

  @override
  String get lastUpdated => 'Last Updated';

  @override
  String get noExchangeRates => 'No exchange rates registered';

  @override
  String exchangeRateLoadFailed(String error) {
    return 'Failed to load exchange rate information\n$error';
  }

  @override
  String get exchangeRateRefreshHint =>
      'Press the refresh button to fetch exchange rates';

  @override
  String get exchangeRateLoading => 'Loading exchange rate information...';

  @override
  String get noData => 'No data available';

  @override
  String get noExpenseData => 'No expense data available';

  @override
  String get noExpenseDataInPeriod =>
      'No expense records in the selected period';

  @override
  String statisticsLoadFailed(String error) {
    return 'Failed to load statistics data\n$error';
  }

  @override
  String get statisticsCalculating => 'Calculating statistics...';

  @override
  String get periodAll => 'All';

  @override
  String get periodWeek => 'This Week';

  @override
  String get periodMonth => 'This Month';

  @override
  String get periodCustom => 'Custom';

  @override
  String get allCategories => 'All';

  @override
  String get sortByDate => 'Latest First';

  @override
  String get sortByAmount => 'Amount';

  @override
  String get selectDefaultCurrency => 'Select Default Currency';

  @override
  String get language => 'Language';

  @override
  String get languageKorean => 'Korean';

  @override
  String get languageEnglish => 'English';

  @override
  String get defaultCurrency => 'Default Currency';

  @override
  String get general => 'General';

  @override
  String get data => 'Data';

  @override
  String get info => 'Info';

  @override
  String get version => 'Version';

  @override
  String get backup => 'Backup';

  @override
  String get restore => 'Restore';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get licenses => 'Open Source Licenses';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get validationTitleRequired => 'Title is required';

  @override
  String get validationTitleTooLong => 'Title must be 100 characters or less';

  @override
  String get validationBudgetRequired => 'Please enter a budget';

  @override
  String get validationBudgetPositive => 'Budget must be positive';

  @override
  String get validationEndDateAfterStart => 'End date must be after start date';

  @override
  String get validationAmountPositive => 'Amount must be positive';

  @override
  String get validationCategoryRequired => 'Please select a category';

  @override
  String get validationPaymentRequired => 'Please select a payment method';

  @override
  String get enterTripTitle => 'Enter trip title';

  @override
  String get enterBudget => 'Enter budget';

  @override
  String get enterAmountGreaterThanZero => 'Enter an amount greater than 0';

  @override
  String get networkError => 'Network error occurred';

  @override
  String get offlineMode => 'Offline';

  @override
  String get loadFailed => 'Load failed';

  @override
  String get saveFailed => 'Save failed';

  @override
  String get unknownError => 'An unknown error occurred';
}
