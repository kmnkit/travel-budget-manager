/// Abstract interface for analytics operations.
/// Implementations should handle privacy-sensitive data filtering.
abstract class AnalyticsRepository {
  /// Log a screen view event
  Future<void> logScreenView(String screenName);

  /// Log a custom event with optional parameters
  /// Parameters should be sanitized to remove personal data
  Future<void> logEvent(String name, Map<String, Object>? parameters);

  /// Set a user property (must be anonymous)
  Future<void> setUserProperty(String name, String value);

  /// Enable or disable analytics collection
  Future<void> setAnalyticsEnabled(bool enabled);

  /// Reset analytics data (for GDPR compliance)
  Future<void> resetAnalyticsData();
}
