import 'package:trip_wallet/features/trip/domain/repositories/trip_repository.dart';

/// Use case for deleting a trip.
///
/// Deletes a trip by its ID from the repository.
class DeleteTrip {
  final TripRepository _repository;

  const DeleteTrip(this._repository);

  /// Executes the use case to delete a trip by its ID.
  ///
  /// Throws an exception if the trip doesn't exist.
  Future<void> call(int id) {
    return _repository.deleteTrip(id);
  }
}
