import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_wallet/features/payment_method/domain/entities/payment_method.dart';
import 'package:trip_wallet/features/payment_method/domain/repositories/payment_method_repository.dart';
import 'package:trip_wallet/features/payment_method/data/repositories/payment_method_repository_impl.dart';
import 'package:trip_wallet/features/payment_method/data/datasources/payment_method_local_datasource.dart';

class GetPaymentMethods {
  final PaymentMethodRepository _repository;

  GetPaymentMethods(this._repository);

  Future<List<PaymentMethod>> call() {
    return _repository.getAllPaymentMethods();
  }
}

final getPaymentMethodsProvider = Provider<GetPaymentMethods>((ref) {
  final datasource = ref.watch(paymentMethodLocalDatasourceProvider);
  final repository = PaymentMethodRepositoryImpl(datasource);
  return GetPaymentMethods(repository);
});
