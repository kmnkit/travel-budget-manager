import '../entities/consent_status.dart';

abstract class ConsentRepository {
  Future<ConsentStatus?> getConsentStatus();
  Future<void> saveConsentStatus(ConsentStatus status);
  Future<bool> isConsentCompleted();
  Future<void> clearConsent();
}
