class AppConstants {
  AppConstants._();

  static const double borderRadius = 12.0;
  static const double minTouchTarget = 48.0;
  static const int maxTitleLength = 100;
  static const double maxBudget = 10000000000; // 100억
  static const Duration apiTimeout = Duration(seconds: 5);
  static const Duration rateCacheDuration = Duration(hours: 24);
  static const String exchangeRateApiBaseUrl = 'https://open.er-api.com/v6/latest';
  static const String exchangeRateApiFallbackUrl = 'https://api.exchangerate-api.com/v4/latest';
}
