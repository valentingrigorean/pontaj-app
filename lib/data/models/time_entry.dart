import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class TimeEntry extends Equatable {
  final String id;
  final String? userId;
  final String user;
  final String location;
  final String intervalText;
  final int breakMinutes;
  final DateTime date;
  final Duration totalWorked;

  const TimeEntry({
    required this.id,
    this.userId,
    required this.user,
    required this.location,
    required this.intervalText,
    required this.breakMinutes,
    required this.date,
    required this.totalWorked,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        user,
        location,
        intervalText,
        breakMinutes,
        date,
        totalWorked,
      ];

  Map<String, dynamic> toJson() => {
        'id': id,
        if (userId != null) 'userId': userId,
        'user': user,
        'location': location,
        'intervalText': intervalText,
        'breakMinutes': breakMinutes,
        'date': date.toIso8601String(),
        'totalWorked': totalWorked.inMinutes,
      };

  Map<String, dynamic> toFirestore() => {
        'userId': userId,
        'userName': user,
        'location': location,
        'intervalText': intervalText,
        'breakMinutes': breakMinutes,
        'date': Timestamp.fromDate(date),
        'totalWorkedMinutes': totalWorked.inMinutes,
        'createdAt': FieldValue.serverTimestamp(),
      };

  factory TimeEntry.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as String? ??
        DateTime.now().millisecondsSinceEpoch.toString();
    return TimeEntry(
      id: id,
      userId: json['userId'] as String?,
      user: json['user'] as String? ?? json['userName'] as String? ?? '',
      location: json['location'] as String? ?? json['locatie'] as String? ?? '',
      intervalText: json['intervalText'] as String? ?? '',
      breakMinutes: json['breakMinutes'] as int? ?? 0,
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
      totalWorked: Duration(
          minutes: (json['totalWorked'] as int?) ??
              (json['totalWorkedMinutes'] as int?) ??
              0),
    );
  }

  factory TimeEntry.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TimeEntry(
      id: doc.id,
      userId: data['userId'] as String?,
      user: data['userName'] as String? ?? '',
      location: data['location'] as String? ?? '',
      intervalText: data['intervalText'] as String? ?? '',
      breakMinutes: data['breakMinutes'] as int? ?? 0,
      date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      totalWorked: Duration(minutes: data['totalWorkedMinutes'] as int? ?? 0),
    );
  }

  TimeEntry copyWith({
    String? id,
    String? userId,
    String? user,
    String? location,
    String? intervalText,
    int? breakMinutes,
    DateTime? date,
    Duration? totalWorked,
  }) =>
      TimeEntry(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        user: user ?? this.user,
        location: location ?? this.location,
        intervalText: intervalText ?? this.intervalText,
        breakMinutes: breakMinutes ?? this.breakMinutes,
        date: date ?? this.date,
        totalWorked: totalWorked ?? this.totalWorked,
      );

  static String formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes % 60;
    return m == 0 ? '${h}h' : '${h}h ${m}m';
  }
}
