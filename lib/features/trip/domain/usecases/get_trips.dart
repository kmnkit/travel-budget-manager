import 'package:trip_wallet/features/trip/domain/entities/trip.dart';
import 'package:trip_wallet/features/trip/domain/repositories/trip_repository.dart';

/// Use case for retrieving all trips.
///
/// Returns a list of all trips ordered by creation date descending.
class GetTrips {
  final TripRepository _repository;

  const GetTrips(this._repository);

  /// Executes the use case to get all trips.
  Future<List<Trip>> call() {
    return _repository.getAllTrips();
  }
}
