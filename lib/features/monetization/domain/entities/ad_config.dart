import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trip_wallet/features/monetization/domain/entities/ad_type.dart';

part 'ad_config.freezed.dart';

@freezed
abstract class AdConfig with _$AdConfig {
  const factory AdConfig({
    required String adUnitId,
    required AdType adType,
    required bool isTestMode,
  }) = _AdConfig;

  const AdConfig._();
}
