import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_wallet/features/payment_method/domain/entities/payment_method.dart'
    as domain;
import 'package:trip_wallet/features/payment_method/domain/entities/payment_method_type.dart';
import 'package:trip_wallet/shared/data/database.dart';
import 'package:trip_wallet/core/errors/exceptions.dart';

class PaymentMethodLocalDatasource {
  final AppDatabase _db;

  PaymentMethodLocalDatasource(this._db);

  Future<List<domain.PaymentMethod>> getAllPaymentMethods() async {
    try {
      final rows = await _db.select(_db.paymentMethods).get();
      return rows.map(_mapToEntity).toList();
    } catch (e) {
      throw DatabaseException('Failed to fetch payment methods: $e');
    }
  }

  Future<domain.PaymentMethod?> getPaymentMethodById(int id) async {
    try {
      final row = await (_db.select(_db.paymentMethods)
            ..where((t) => t.id.equals(id)))
          .getSingleOrNull();
      return row != null ? _mapToEntity(row) : null;
    } catch (e) {
      throw DatabaseException('Failed to fetch payment method: $e');
    }
  }

  Future<domain.PaymentMethod> createPaymentMethod({
    required String name,
    required PaymentMethodType type,
  }) async {
    if (name.trim().isEmpty) {
      throw const ValidationException('Name cannot be empty');
    }

    try {
      final id = await _db.into(_db.paymentMethods).insert(
            PaymentMethodsCompanion.insert(
              name: name,
              type: type,
              createdAt: DateTime.now(),
            ),
          );

      final created = await getPaymentMethodById(id);
      if (created == null) {
        throw const DatabaseException('Failed to retrieve created payment method');
      }
      return created;
    } catch (e) {
      if (e is ValidationException) rethrow;
      throw DatabaseException('Failed to create payment method: $e');
    }
  }

  Future<domain.PaymentMethod> updatePaymentMethod(
      domain.PaymentMethod method) async {
    if (method.name.trim().isEmpty) {
      throw const ValidationException('Name cannot be empty');
    }

    try {
      await (_db.update(_db.paymentMethods)
            ..where((t) => t.id.equals(method.id)))
          .write(
        PaymentMethodsCompanion(
          name: Value(method.name),
          type: Value(method.type),
          isDefault: Value(method.isDefault),
        ),
      );

      final updated = await getPaymentMethodById(method.id);
      if (updated == null) {
        throw const DatabaseException('Failed to retrieve updated payment method');
      }
      return updated;
    } catch (e) {
      if (e is ValidationException) rethrow;
      throw DatabaseException('Failed to update payment method: $e');
    }
  }

  Future<void> deletePaymentMethod(int id) async {
    try {
      // Check if it's the default method
      final method = await getPaymentMethodById(id);
      if (method?.isDefault == true) {
        throw const DatabaseException('Cannot delete default payment method');
      }

      await (_db.delete(_db.paymentMethods)..where((t) => t.id.equals(id)))
          .go();
    } catch (e) {
      if (e is DatabaseException) rethrow;
      throw DatabaseException('Failed to delete payment method: $e');
    }
  }

  Future<void> setDefault(int id) async {
    try {
      await _db.transaction(() async {
        // Clear existing default
        await (_db.update(_db.paymentMethods)
              ..where((t) => t.isDefault.equals(true)))
            .write(const PaymentMethodsCompanion(isDefault: Value(false)));

        // Set new default
        await (_db.update(_db.paymentMethods)..where((t) => t.id.equals(id)))
            .write(const PaymentMethodsCompanion(isDefault: Value(true)));
      });
    } catch (e) {
      throw DatabaseException('Failed to set default payment method: $e');
    }
  }

  domain.PaymentMethod _mapToEntity(PaymentMethod row) {
    return domain.PaymentMethod(
      id: row.id,
      name: row.name,
      type: row.type,
      isDefault: row.isDefault,
      createdAt: row.createdAt,
    );
  }
}

final paymentMethodLocalDatasourceProvider = Provider<PaymentMethodLocalDatasource>((ref) {
  final db = ref.watch(databaseProvider);
  return PaymentMethodLocalDatasource(db);
});
