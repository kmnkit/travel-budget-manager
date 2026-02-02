import 'package:trip_wallet/features/trip/data/datasources/trip_local_datasource.dart';
import 'package:trip_wallet/features/trip/domain/entities/trip.dart';
import 'package:trip_wallet/features/trip/domain/repositories/trip_repository.dart';

/// Implementation of [TripRepository] using local datasource.
class TripRepositoryImpl implements TripRepository {
  final TripLocalDataSource _localDataSource;

  const TripRepositoryImpl(this._localDataSource);

  @override
  Future<List<Trip>> getAllTrips() {
    return _localDataSource.getAllTrips();
  }

  @override
  Future<Trip?> getTripById(int id) {
    return _localDataSource.getTripById(id);
  }

  @override
  Future<Trip> createTrip({
    required String title,
    required String baseCurrency,
    required double budget,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return _localDataSource.createTrip(
      title: title,
      baseCurrency: baseCurrency,
      budget: budget,
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  Future<Trip> updateTrip(Trip trip) {
    return _localDataSource.updateTrip(trip);
  }

  @override
  Future<void> deleteTrip(int id) {
    return _localDataSource.deleteTrip(id);
  }

  @override
  Stream<List<Trip>> watchAllTrips() {
    return _localDataSource.watchAllTrips();
  }
}
