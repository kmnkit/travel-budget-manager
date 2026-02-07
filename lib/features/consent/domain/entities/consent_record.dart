import 'package:freezed_annotation/freezed_annotation.dart';

part 'consent_record.freezed.dart';

@freezed
abstract class ConsentRecord with _$ConsentRecord {
  const ConsentRecord._();

  const factory ConsentRecord({
    required bool isAccepted,
    required DateTime? acceptedAt,
    required String policyVersion,
  }) = _ConsentRecord;

  bool get hasValidConsent => isAccepted && acceptedAt != null;
}
