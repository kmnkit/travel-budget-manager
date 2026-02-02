import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trip_wallet/shared/data/database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('AppDatabase', () {
    test('creates tables on initialization', () async {
      // If we can select from tables, they were created
      final trips = await db.select(db.trips).get();
      expect(trips, isEmpty);
    });

    test('seeds default payment methods', () async {
      final methods = await db.select(db.paymentMethods).get();
      expect(methods.length, 3);
      expect(methods[0].name, '현금');
      expect(methods[1].name, '신용카드');
      expect(methods[2].name, '교통카드');
    });

    test('default payment method is cash', () async {
      final methods = await db.select(db.paymentMethods).get();
      final defaultMethod = methods.firstWhere((m) => m.isDefault);
      expect(defaultMethod.name, '현금');
    });
  });
}
