import 'package:freezed_annotation/freezed_annotation.dart';
import 'payment_method_type.dart';

part 'payment_method.freezed.dart';

@freezed
abstract class PaymentMethod with _$PaymentMethod {
  const factory PaymentMethod({
    required int id,
    required String name,
    required PaymentMethodType type,
    @Default(false) bool isDefault,
    required DateTime createdAt,
  }) = _PaymentMethod;
}
