import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trip_wallet/features/ads/domain/entities/ad_type.dart';

part 'ad_config.freezed.dart';

@freezed
abstract class AdConfig with _$AdConfig {
  const factory AdConfig({
    required AdType type,
    required String unitId,
    required bool isTestAd,
    required bool isEnabled,
  }) = _AdConfig;
}
