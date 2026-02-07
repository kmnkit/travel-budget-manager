import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/analytics_repository.dart';
import '../../data/repositories/analytics_repository_impl.dart';
import '../../../consent/presentation/providers/consent_providers.dart';

/// Firebase Analytics instance provider
final firebaseAnalyticsProvider = Provider<FirebaseAnalytics>((ref) {
  return FirebaseAnalytics.instance;
});

/// Analytics repository provider
final analyticsRepositoryProvider = Provider<AnalyticsRepository>((ref) {
  final analytics = ref.watch(firebaseAnalyticsProvider);
  return AnalyticsRepositoryImpl(analytics);
});

/// Provider that initializes analytics based on consent status
final analyticsInitializerProvider = FutureProvider<void>((ref) async {
  final consentRecord = await ref.watch(consentRecordProvider.future);
  final analyticsRepo = ref.read(analyticsRepositoryProvider);

  // Enable analytics only if user has given valid consent
  final enabled = consentRecord?.hasValidConsent ?? false;
  await analyticsRepo.setAnalyticsEnabled(enabled);

  // Set anonymous user properties
  if (enabled) {
    // Example: Set app language
    // final locale = ref.read(localeProvider);
    // await analyticsRepo.setUserProperty('app_language', locale?.languageCode ?? 'en');
  }
});
