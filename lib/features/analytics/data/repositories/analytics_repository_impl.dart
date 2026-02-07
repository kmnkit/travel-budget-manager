import 'package:firebase_analytics/firebase_analytics.dart';
import '../../domain/repositories/analytics_repository.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final FirebaseAnalytics _analytics;
  bool _isEnabled = false;

  // CRITICAL: Privacy-sensitive parameters that must NEVER be logged
  static const _blockedParameterKeys = [
    'amount',
    'budget',
    'destination',
    'location',
    'name',
    'email',
    'phone',
    'card',
    'account',
    'trip_name',
    'memo',
    'note',
    'title',
  ];

  AnalyticsRepositoryImpl(this._analytics);

  @override
  Future<void> setAnalyticsEnabled(bool enabled) async {
    _isEnabled = enabled;
    await _analytics.setAnalyticsCollectionEnabled(enabled);
  }

  @override
  Future<void> logScreenView(String screenName) async {
    if (!_isEnabled) return;
    await _analytics.logScreenView(screenName: screenName);
  }

  @override
  Future<void> logEvent(String name, Map<String, Object>? parameters) async {
    if (!_isEnabled) return;

    // Sanitize parameters - remove any blocked keys
    final sanitized = _sanitizeParameters(parameters);

    await _analytics.logEvent(name: name, parameters: sanitized);
  }

  @override
  Future<void> setUserProperty(String name, String value) async {
    if (!_isEnabled) return;
    // Only allow anonymous properties
    if (_blockedParameterKeys.contains(name.toLowerCase())) return;
    await _analytics.setUserProperty(name: name, value: value);
  }

  @override
  Future<void> resetAnalyticsData() async {
    await _analytics.resetAnalyticsData();
  }

  Map<String, Object>? _sanitizeParameters(Map<String, Object>? parameters) {
    if (parameters == null) return null;

    final sanitized = <String, Object>{};
    for (final entry in parameters.entries) {
      if (!_blockedParameterKeys.contains(entry.key.toLowerCase())) {
        sanitized[entry.key] = entry.value;
      }
    }
    return sanitized.isEmpty ? null : sanitized;
  }
}
