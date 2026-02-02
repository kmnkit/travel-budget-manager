import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_wallet/features/exchange_rate/domain/entities/exchange_rate.dart'
    as domain;
import 'package:trip_wallet/shared/data/database.dart';
import 'package:trip_wallet/core/errors/exceptions.dart';

class ExchangeRateLocalDatasource {
  final AppDatabase _db;

  ExchangeRateLocalDatasource(this._db);

  Future<List<domain.ExchangeRate>> getRatesByTrip(int tripId) async {
    try {
      final rows = await (_db.select(_db.exchangeRates)
            ..where((t) => t.tripId.equals(tripId)))
          .get();
      return rows.map(_mapToEntity).toList();
    } catch (e) {
      throw DatabaseException('Failed to fetch exchange rates: $e');
    }
  }

  Future<domain.ExchangeRate?> getRate(
    String baseCurrency,
    String targetCurrency, {
    int? tripId,
  }) async {
    try {
      final query = _db.select(_db.exchangeRates)
        ..where((t) =>
            t.baseCurrency.equals(baseCurrency) &
            t.targetCurrency.equals(targetCurrency));

      if (tripId != null) {
        query.where((t) => t.tripId.equals(tripId));
      } else {
        query.where((t) => t.tripId.isNull());
      }

      query.orderBy([
        (t) => OrderingTerm(expression: t.isManual, mode: OrderingMode.desc),
        (t) => OrderingTerm(expression: t.updatedAt, mode: OrderingMode.desc),
      ]);

      final row = await query.getSingleOrNull();
      return row != null ? _mapToEntity(row) : null;
    } catch (e) {
      throw DatabaseException('Failed to fetch exchange rate: $e');
    }
  }

  Future<domain.ExchangeRate> setManualRate({
    int? tripId,
    required String baseCurrency,
    required String targetCurrency,
    required double rate,
  }) async {
    if (rate <= 0) {
      throw const ValidationException('Rate must be positive');
    }

    try {
      // Check if manual rate already exists
      final existing = await (_db.select(_db.exchangeRates)
            ..where((t) =>
                t.baseCurrency.equals(baseCurrency) &
                t.targetCurrency.equals(targetCurrency) &
                t.isManual.equals(true) &
                (tripId != null ? t.tripId.equals(tripId) : t.tripId.isNull())))
          .getSingleOrNull();

      final now = DateTime.now();

      if (existing != null) {
        // Update existing manual rate
        await (_db.update(_db.exchangeRates)
              ..where((t) => t.id.equals(existing.id)))
            .write(
          ExchangeRatesCompanion(
            rate: Value(rate),
            updatedAt: Value(now),
          ),
        );

        final updated = await (_db.select(_db.exchangeRates)
              ..where((t) => t.id.equals(existing.id)))
            .getSingle();
        return _mapToEntity(updated);
      } else {
        // Insert new manual rate
        final id = await _db.into(_db.exchangeRates).insert(
              ExchangeRatesCompanion.insert(
                tripId: Value(tripId),
                baseCurrency: baseCurrency,
                targetCurrency: targetCurrency,
                rate: rate,
                isManual: const Value(true),
                updatedAt: now,
              ),
            );

        final created = await (_db.select(_db.exchangeRates)
              ..where((t) => t.id.equals(id)))
            .getSingle();
        return _mapToEntity(created);
      }
    } catch (e) {
      if (e is ValidationException) rethrow;
      throw DatabaseException('Failed to set manual rate: $e');
    }
  }

  Future<List<domain.ExchangeRate>> saveRates({
    required String baseCurrency,
    required Map<String, double> rates,
  }) async {
    try {
      final now = DateTime.now();
      final savedRates = <domain.ExchangeRate>[];

      await _db.transaction(() async {
        for (final entry in rates.entries) {
          final targetCurrency = entry.key;
          final rate = entry.value;

          // Check if automatic rate exists
          final existing = await (_db.select(_db.exchangeRates)
                ..where((t) =>
                    t.baseCurrency.equals(baseCurrency) &
                    t.targetCurrency.equals(targetCurrency) &
                    t.isManual.equals(false) &
                    t.tripId.isNull()))
              .getSingleOrNull();

          if (existing != null) {
            // Update existing automatic rate
            await (_db.update(_db.exchangeRates)
                  ..where((t) => t.id.equals(existing.id)))
                .write(
              ExchangeRatesCompanion(
                rate: Value(rate),
                updatedAt: Value(now),
              ),
            );

            final updated = await (_db.select(_db.exchangeRates)
                  ..where((t) => t.id.equals(existing.id)))
                .getSingle();
            savedRates.add(_mapToEntity(updated));
          } else {
            // Insert new automatic rate
            final id = await _db.into(_db.exchangeRates).insert(
                  ExchangeRatesCompanion.insert(
                    baseCurrency: baseCurrency,
                    targetCurrency: targetCurrency,
                    rate: rate,
                    isManual: const Value(false),
                    updatedAt: now,
                  ),
                );

            final created = await (_db.select(_db.exchangeRates)
                  ..where((t) => t.id.equals(id)))
                .getSingle();
            savedRates.add(_mapToEntity(created));
          }
        }
      });

      return savedRates;
    } catch (e) {
      throw DatabaseException('Failed to save rates: $e');
    }
  }

  Future<List<domain.ExchangeRate>> getCachedRates(String baseCurrency) async {
    try {
      final rows = await (_db.select(_db.exchangeRates)
            ..where((t) =>
                t.baseCurrency.equals(baseCurrency) &
                t.tripId.isNull() &
                t.isManual.equals(false)))
          .get();
      return rows.map(_mapToEntity).toList();
    } catch (e) {
      throw DatabaseException('Failed to fetch cached rates: $e');
    }
  }

  Stream<List<domain.ExchangeRate>> watchRatesByTrip(int tripId) {
    return (_db.select(_db.exchangeRates)
          ..where((t) => t.tripId.equals(tripId)))
        .watch()
        .map((rows) => rows.map(_mapToEntity).toList());
  }

  domain.ExchangeRate _mapToEntity(ExchangeRate row) {
    return domain.ExchangeRate(
      id: row.id,
      tripId: row.tripId,
      baseCurrency: row.baseCurrency,
      targetCurrency: row.targetCurrency,
      rate: row.rate,
      isManual: row.isManual,
      updatedAt: row.updatedAt,
    );
  }
}

final exchangeRateLocalDatasourceProvider =
    Provider<ExchangeRateLocalDatasource>((ref) {
  final db = ref.watch(databaseProvider);
  return ExchangeRateLocalDatasource(db);
});
