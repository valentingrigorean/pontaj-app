import 'package:equatable/equatable.dart';

class TimeEntry extends Equatable {
  final String id;
  final String user;
  final String location;
  final String intervalText;
  final int breakMinutes;
  final DateTime date;
  final Duration totalWorked;

  const TimeEntry({
    required this.id,
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
        user,
        location,
        intervalText,
        breakMinutes,
        date,
        totalWorked,
      ];

  Map<String, dynamic> toJson() => {
        'id': id,
        'user': user,
        'location': location,
        'intervalText': intervalText,
        'breakMinutes': breakMinutes,
        'date': date.toIso8601String(),
        'totalWorked': totalWorked.inMinutes,
      };

  factory TimeEntry.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as String? ??
        DateTime.now().millisecondsSinceEpoch.toString();
    return TimeEntry(
      id: id,
      user: json['user'] as String? ?? '',
      location: json['location'] as String? ?? json['locatie'] as String? ?? '',
      intervalText: json['intervalText'] as String? ?? '',
      breakMinutes: json['breakMinutes'] as int? ?? 0,
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
      totalWorked: Duration(minutes: (json['totalWorked'] as int?) ?? 0),
    );
  }

  TimeEntry copyWith({
    String? id,
    String? user,
    String? location,
    String? intervalText,
    int? breakMinutes,
    DateTime? date,
    Duration? totalWorked,
  }) =>
      TimeEntry(
        id: id ?? this.id,
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
