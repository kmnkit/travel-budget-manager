import 'package:freezed_annotation/freezed_annotation.dart';

part 'consent_status.freezed.dart';

@freezed
abstract class ConsentStatus with _$ConsentStatus {
  const factory ConsentStatus({
    required bool analyticsConsent,
    required bool personalizedAdsConsent,
    required bool attGranted,
    required DateTime? consentDate,
  }) = _ConsentStatus;
}
