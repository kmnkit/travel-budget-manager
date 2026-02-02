import 'package:freezed_annotation/freezed_annotation.dart';

part 'trip.freezed.dart';

enum TripStatus { upcoming, ongoing, completed }

@freezed
abstract class Trip with _$Trip {
  const Trip._();

  const factory Trip({
    required int id,
    required String title,
    required String baseCurrency,
    required double budget,
    required DateTime startDate,
    required DateTime endDate,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Trip;

  TripStatus get status {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final startDay = DateTime(startDate.year, startDate.month, startDate.day);
    final endDay = DateTime(endDate.year, endDate.month, endDate.day);

    if (startDay.isAfter(startOfDay)) return TripStatus.upcoming;
    if (endDay.isBefore(startOfDay)) return TripStatus.completed;
    return TripStatus.ongoing;
  }
}
