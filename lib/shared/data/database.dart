import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_wallet/features/trip/data/models/trip_model.dart';
import 'package:trip_wallet/features/expense/data/models/expense_model.dart';
import 'package:trip_wallet/features/payment_method/data/models/payment_method_model.dart';
import 'package:trip_wallet/features/exchange_rate/data/models/exchange_rate_model.dart';
import 'package:trip_wallet/features/expense/domain/entities/expense_category.dart';
import 'package:trip_wallet/features/payment_method/domain/entities/payment_method_type.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Trips, Expenses, PaymentMethods, ExchangeRates])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
      // Seed default payment methods
      await into(paymentMethods).insert(PaymentMethodsCompanion.insert(
        name: '현금',
        type: PaymentMethodType.cash,
        isDefault: const Value(true),
        createdAt: DateTime.now(),
      ));
      await into(paymentMethods).insert(PaymentMethodsCompanion.insert(
        name: '신용카드',
        type: PaymentMethodType.creditCard,
        createdAt: DateTime.now(),
      ));
      await into(paymentMethods).insert(PaymentMethodsCompanion.insert(
        name: '교통카드',
        type: PaymentMethodType.transitCard,
        createdAt: DateTime.now(),
      ));
    },
  );

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'trip_wallet.db');
  }
}

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});
