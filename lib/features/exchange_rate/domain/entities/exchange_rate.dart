import 'package:freezed_annotation/freezed_annotation.dart';

part 'exchange_rate.freezed.dart';

@freezed
abstract class ExchangeRate with _$ExchangeRate {
  const factory ExchangeRate({
    required int id,
    int? tripId,
    required String baseCurrency,
    required String targetCurrency,
    required double rate,
    @Default(false) bool isManual,
    required DateTime updatedAt,
  }) = _ExchangeRate;
}
