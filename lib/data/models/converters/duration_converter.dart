import 'package:json_annotation/json_annotation.dart';

/// Converts Duration to/from int (minutes) for Freezed models.
class DurationConverter implements JsonConverter<Duration, int> {
  const DurationConverter();

  @override
  Duration fromJson(int json) => Duration(minutes: json);

  @override
  int toJson(Duration duration) => duration.inMinutes;
}

/// Converts nullable Duration to/from int (minutes).
class NullableDurationConverter implements JsonConverter<Duration?, int?> {
  const NullableDurationConverter();

  @override
  Duration? fromJson(int? json) => json != null ? Duration(minutes: json) : null;

  @override
  int? toJson(Duration? duration) => duration?.inMinutes;
}
