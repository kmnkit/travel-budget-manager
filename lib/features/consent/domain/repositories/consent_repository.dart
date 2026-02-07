import 'package:trip_wallet/features/consent/domain/entities/consent_record.dart';

abstract class ConsentRepository {
  Future<ConsentRecord> getConsentRecord();
  Future<void> setConsentAccepted(String version);
  Future<void> clearConsent();
}
