import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_wallet/features/payment_method/domain/entities/payment_method.dart';
import 'package:trip_wallet/features/payment_method/domain/entities/payment_method_type.dart';
import 'package:trip_wallet/features/payment_method/domain/repositories/payment_method_repository.dart';
import 'package:trip_wallet/features/payment_method/data/repositories/payment_method_repository_impl.dart';
import 'package:trip_wallet/features/payment_method/data/datasources/payment_method_local_datasource.dart';

class CreatePaymentMethod {
  final PaymentMethodRepository _repository;

  CreatePaymentMethod(this._repository);

  Future<PaymentMethod> call({
    required String name,
    required PaymentMethodType type,
  }) {
    return _repository.createPaymentMethod(name: name, type: type);
  }
}

final createPaymentMethodProvider = Provider<CreatePaymentMethod>((ref) {
  final datasource = ref.watch(paymentMethodLocalDatasourceProvider);
  final repository = PaymentMethodRepositoryImpl(datasource);
  return CreatePaymentMethod(repository);
});
