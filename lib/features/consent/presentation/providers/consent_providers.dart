import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import '../../domain/entities/consent_status.dart';
import '../../domain/repositories/consent_repository.dart';

/// Repository provider - will be overridden in main.dart with actual implementation
final consentRepositoryProvider = Provider<ConsentRepository>((ref) {
  throw UnimplementedError('ConsentRepository must be overridden in main.dart');
});

/// Check if consent is completed (for app flow)
final consentCompletedProvider = FutureProvider<bool>((ref) async {
  final repo = ref.watch(consentRepositoryProvider);
  return repo.isConsentCompleted();
});

/// Current consent status
final consentStatusProvider = FutureProvider<ConsentStatus?>((ref) async {
  final repo = ref.watch(consentRepositoryProvider);
  return repo.getConsentStatus();
});

/// Notifier for managing consent state changes
class ConsentNotifier extends Notifier<AsyncValue<ConsentStatus?>> {
  @override
  AsyncValue<ConsentStatus?> build() {
    // Load initial consent status
    _loadConsentStatus();
    return const AsyncValue.loading();
  }

  Future<void> _loadConsentStatus() async {
    state = const AsyncValue.loading();
    try {
      final repo = ref.read(consentRepositoryProvider);
      final status = await repo.getConsentStatus();
      state = AsyncValue.data(status);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Save consent with the provided settings
  Future<void> saveConsent({
    required bool analyticsConsent,
    required bool personalizedAdsConsent,
  }) async {
    state = const AsyncValue.loading();
    try {
      final repo = ref.read(consentRepositoryProvider);

      // Request ATT on iOS if personalized ads are enabled
      bool attGranted = false;
      if (Platform.isIOS && personalizedAdsConsent) {
        attGranted = await requestATT();
      }

      final consentStatus = ConsentStatus(
        analyticsConsent: analyticsConsent,
        personalizedAdsConsent: personalizedAdsConsent,
        attGranted: attGranted,
        consentDate: DateTime.now(),
      );

      await repo.saveConsentStatus(consentStatus);
      state = AsyncValue.data(consentStatus);

      // Invalidate related providers
      ref.invalidate(consentCompletedProvider);
      ref.invalidate(consentStatusProvider);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Clear consent (for testing or reset)
  Future<void> clearConsent() async {
    state = const AsyncValue.loading();
    try {
      final repo = ref.read(consentRepositoryProvider);
      await repo.clearConsent();
      state = const AsyncValue.data(null);

      // Invalidate related providers
      ref.invalidate(consentCompletedProvider);
      ref.invalidate(consentStatusProvider);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Request App Tracking Transparency (iOS only)
  Future<bool> requestATT() async {
    if (!Platform.isIOS) {
      return false;
    }

    try {
      final status = await AppTrackingTransparency.trackingAuthorizationStatus;

      // If not determined, request authorization
      if (status == TrackingStatus.notDetermined) {
        final requestedStatus = await AppTrackingTransparency.requestTrackingAuthorization();
        return requestedStatus == TrackingStatus.authorized;
      }

      // Return current status
      return status == TrackingStatus.authorized;
    } catch (e) {
      // If ATT request fails, return false
      return false;
    }
  }
}

final consentNotifierProvider = NotifierProvider<ConsentNotifier, AsyncValue<ConsentStatus?>>(() {
  return ConsentNotifier();
});
