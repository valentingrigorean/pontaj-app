import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

/// Handles server timestamp fields that may be null during creation
/// but become Timestamp after write.
class ServerTimestampConverter implements JsonConverter<DateTime?, dynamic> {
  const ServerTimestampConverter();

  @override
  DateTime? fromJson(dynamic json) {
    if (json == null) return null;
    if (json is Timestamp) {
      return json.toDate();
    }
    if (json is String) {
      return DateTime.tryParse(json);
    }
    return null;
  }

  @override
  dynamic toJson(DateTime? date) {
    // For server timestamps, we typically want FieldValue.serverTimestamp()
    // But JSON serialization requires a concrete value
    // Use null here - handle FieldValue.serverTimestamp() in toFirestore()
    return date != null ? Timestamp.fromDate(date) : null;
  }
}
