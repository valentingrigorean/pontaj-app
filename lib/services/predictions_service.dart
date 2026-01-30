import 'dart:math';
import 'database_service.dart';

/// Smart predictions service using historical data analysis
/// Predicts work patterns, suggests optimizations, and detects anomalies
class PredictionsService {
  static final PredictionsService _instance = PredictionsService._internal();
  factory PredictionsService() => _instance;
  PredictionsService._internal();

  final DatabaseService _db = DatabaseService();

  // ==================== WORK PATTERN PREDICTIONS ====================

  /// Predict most likely work hours for a user
  Future<WorkPrediction> predictWorkHours(String username) async {
    try {
      final entries = await _db.getPontajEntriesByUser(username);
      if (entries.isEmpty) {
        return WorkPrediction(
          confidence: 0.0,
          message: 'No historical data available',
        );
      }

      // Analyze typical work hours
      final hourCounts = <int, int>{};
      for (final entry in entries) {
        final hours = entry.totalWorked.inHours;
        hourCounts[hours] = (hourCounts[hours] ?? 0) + 1;
      }

      // Find most common work duration
      var maxCount = 0;
      var predictedHours = 8;
      hourCounts.forEach((hours, count) {
        if (count > maxCount) {
          maxCount = count;
          predictedHours = hours;
        }
      });

      final confidence = maxCount / entries.length;

      return WorkPrediction(
        predictedHours: predictedHours,
        confidence: confidence,
        message: 'Based on ${entries.length} past entries, you typically work $predictedHours hours',
        basedOnEntries: entries.length,
      );

    } catch (e) {
      return WorkPrediction(
        confidence: 0.0,
        message: 'Prediction error: $e',
      );
    }
  }

  /// Predict most likely location for a user
  Future<LocationPrediction> predictLocation(String username) async {
    try {
      final entries = await _db.getPontajEntriesByUser(username);
      if (entries.isEmpty) {
        return LocationPrediction(
          confidence: 0.0,
          message: 'No historical data available',
        );
      }

      // Count location frequency
      final locationCounts = <String, int>{};
      for (final entry in entries) {
        locationCounts[entry.locatie] = (locationCounts[entry.locatie] ?? 0) + 1;
      }

      // Find most common location
      var maxCount = 0;
      var predictedLocation = '';
      locationCounts.forEach((location, count) {
        if (count > maxCount) {
          maxCount = count;
          predictedLocation = location;
        }
      });

      final confidence = maxCount / entries.length;

      // Get top 3 locations
      final topLocations = locationCounts.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      return LocationPrediction(
        predictedLocation: predictedLocation,
        confidence: confidence,
        message: 'You usually work at $predictedLocation',
        topLocations: topLocations.take(3).map((e) => e.key).toList(),
        basedOnEntries: entries.length,
      );

    } catch (e) {
      return LocationPrediction(
        confidence: 0.0,
        message: 'Prediction error: $e',
      );
    }
  }

  /// Predict break time based on work duration
  Future<BreakPrediction> predictBreakTime(int workHours) async {
    try {
      final allEntries = await _db.getAllPontajEntries();
      if (allEntries.isEmpty) {
        return BreakPrediction(
          predictedBreakMinutes: 30,
          confidence: 0.5,
          message: 'Default break time suggestion',
        );
      }

      // Filter entries with similar work duration (±1 hour)
      final similarEntries = allEntries.where((entry) {
        final entryHours = entry.totalWorked.inHours;
        return (entryHours - workHours).abs() <= 1;
      }).toList();

      if (similarEntries.isEmpty) {
        // Use overall average
        final avgBreak = allEntries.map((e) => e.breakMinutes).reduce((a, b) => a + b) / allEntries.length;
        return BreakPrediction(
          predictedBreakMinutes: avgBreak.round(),
          confidence: 0.3,
          message: 'Based on overall average',
        );
      }

      // Calculate average break for similar work duration
      final avgBreak = similarEntries.map((e) => e.breakMinutes).reduce((a, b) => a + b) / similarEntries.length;

      return BreakPrediction(
        predictedBreakMinutes: avgBreak.round(),
        confidence: 0.8,
        message: 'For ${workHours}h work, typical break is ${avgBreak.round()} minutes',
        basedOnEntries: similarEntries.length,
      );

    } catch (e) {
      return BreakPrediction(
        predictedBreakMinutes: 30,
        confidence: 0.5,
        message: 'Default break time',
      );
    }
  }

  // ==================== ANOMALY DETECTION ====================

  /// Detect unusual work patterns
  Future<List<Anomaly>> detectAnomalies(String username, {int daysBack = 30}) async {
    try {
      final entries = await _db.getPontajEntriesByUser(username);
      if (entries.length < 5) {
        return []; // Not enough data
      }

      // Filter recent entries
      final cutoffDate = DateTime.now().subtract(Duration(days: daysBack));
      final recentEntries = entries.where((e) => e.date.isAfter(cutoffDate)).toList();

      if (recentEntries.isEmpty) return [];

      final anomalies = <Anomaly>[];

      // Calculate statistics
      final hours = recentEntries.map((e) => e.totalWorked.inMinutes / 60).toList();
      final avgHours = hours.reduce((a, b) => a + b) / hours.length;
      final stdDev = _calculateStdDev(hours, avgHours);

      // Detect outliers (more than 2 standard deviations from mean)
      for (final entry in recentEntries) {
        final entryHours = entry.totalWorked.inMinutes / 60;
        final deviation = (entryHours - avgHours).abs();

        if (deviation > 2 * stdDev) {
          anomalies.add(Anomaly(
            type: AnomalyType.unusualHours,
            date: entry.date,
            description: 'Worked ${entryHours.toStringAsFixed(1)}h (avg: ${avgHours.toStringAsFixed(1)}h)',
            severity: deviation > 3 * stdDev ? AnomalySeverity.high : AnomalySeverity.medium,
            value: entryHours,
            expected: avgHours,
          ));
        }
      }

      // Detect consecutive work days without breaks
      final sortedEntries = recentEntries..sort((a, b) => a.date.compareTo(b.date));
      int consecutiveDays = 0;
      DateTime? lastDate;

      for (final entry in sortedEntries) {
        if (lastDate != null) {
          final daysDiff = entry.date.difference(lastDate).inDays;
          if (daysDiff == 1) {
            consecutiveDays++;
            if (consecutiveDays >= 7) {
              anomalies.add(Anomaly(
                type: AnomalyType.consecutiveDays,
                date: entry.date,
                description: '$consecutiveDays consecutive work days detected',
                severity: consecutiveDays >= 10 ? AnomalySeverity.high : AnomalySeverity.medium,
                value: consecutiveDays.toDouble(),
                expected: 5.0, // Typical work week
              ));
            }
          } else {
            consecutiveDays = 0;
          }
        }
        lastDate = entry.date;
      }

      // Detect unusual locations
      final locationCounts = <String, int>{};
      for (final entry in entries) {
        locationCounts[entry.locatie] = (locationCounts[entry.locatie] ?? 0) + 1;
      }

      for (final entry in recentEntries) {
        final frequency = locationCounts[entry.locatie]! / entries.length;
        if (frequency < 0.05) { // Less than 5% of all entries
          anomalies.add(Anomaly(
            type: AnomalyType.unusualLocation,
            date: entry.date,
            description: 'Rare location: ${entry.locatie}',
            severity: AnomalySeverity.low,
            value: frequency,
            expected: 0.2, // Expected at least 20% frequency
          ));
        }
      }

      return anomalies;

    } catch (e) {
      return [];
    }
  }

  // ==================== PRODUCTIVITY INSIGHTS ====================

  /// Analyze productivity trends
  Future<ProductivityInsight> analyzeProductivity(String username) async {
    try {
      final entries = await _db.getPontajEntriesByUser(username);
      if (entries.isEmpty) {
        return ProductivityInsight(
          score: 0.0,
          trend: ProductivityTrend.stable,
          message: 'No data available',
        );
      }

      // Calculate weekly averages for trend analysis
      final weeklyHours = <int, double>{};
      for (final entry in entries) {
        final weekNum = _getWeekNumber(entry.date);
        weeklyHours[weekNum] = (weeklyHours[weekNum] ?? 0) + entry.totalWorked.inMinutes / 60;
      }

      if (weeklyHours.length < 2) {
        return ProductivityInsight(
          score: 50.0,
          trend: ProductivityTrend.stable,
          message: 'Not enough data for trend analysis',
        );
      }

      // Calculate trend (increasing, decreasing, stable)
      final weeks = weeklyHours.keys.toList()..sort();
      final recentWeeks = weeks.take(4).toList();
      final olderWeeks = weeks.skip(4).take(4).toList();

      if (olderWeeks.isEmpty) {
        return ProductivityInsight(
          score: 50.0,
          trend: ProductivityTrend.stable,
          message: 'Steady work pattern',
        );
      }

      final recentAvg = recentWeeks.map((w) => weeklyHours[w]!).reduce((a, b) => a + b) / recentWeeks.length;
      final olderAvg = olderWeeks.map((w) => weeklyHours[w]!).reduce((a, b) => a + b) / olderWeeks.length;

      final change = ((recentAvg - olderAvg) / olderAvg) * 100;

      ProductivityTrend trend;
      String message;
      double score;

      if (change > 10) {
        trend = ProductivityTrend.increasing;
        message = 'Productivity up ${change.toStringAsFixed(1)}% - Great work!';
        score = 75.0 + min(change, 25.0);
      } else if (change < -10) {
        trend = ProductivityTrend.decreasing;
        message = 'Productivity down ${change.abs().toStringAsFixed(1)}% - Consider reviewing workload';
        score = 50.0 - min(change.abs(), 25.0);
      } else {
        trend = ProductivityTrend.stable;
        message = 'Consistent work pattern maintained';
        score = 65.0;
      }

      return ProductivityInsight(
        score: score,
        trend: trend,
        message: message,
        recentWeeklyAvg: recentAvg,
        previousWeeklyAvg: olderAvg,
        changePercent: change,
      );

    } catch (e) {
      return ProductivityInsight(
        score: 0.0,
        trend: ProductivityTrend.stable,
        message: 'Analysis error: $e',
      );
    }
  }

  /// Suggest optimal work schedule
  Future<ScheduleSuggestion> suggestSchedule(String username) async {
    try {
      final entries = await _db.getPontajEntriesByUser(username);
      if (entries.isEmpty) {
        return ScheduleSuggestion(
          message: 'No data available for suggestions',
          suggestions: [],
        );
      }

      // Analyze day-of-week patterns
      final dayHours = <int, List<double>>{};
      for (final entry in entries) {
        final dayOfWeek = entry.date.weekday;
        dayHours.putIfAbsent(dayOfWeek, () => []);
        dayHours[dayOfWeek]!.add(entry.totalWorked.inMinutes / 60);
      }

      final suggestions = <String>[];

      // Find most productive days
      final avgByDay = <int, double>{};
      dayHours.forEach((day, hours) {
        avgByDay[day] = hours.reduce((a, b) => a + b) / hours.length;
      });

      final sortedDays = avgByDay.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      if (sortedDays.isNotEmpty) {
        final bestDay = _getDayName(sortedDays.first.key);
        suggestions.add('You\'re most productive on $bestDay (avg ${sortedDays.first.value.toStringAsFixed(1)}h)');
      }

      // Suggest optimal work hours based on patterns
      final avgHours = entries.map((e) => e.totalWorked.inMinutes / 60).reduce((a, b) => a + b) / entries.length;
      if (avgHours < 6) {
        suggestions.add('Consider longer work sessions for better efficiency');
      } else if (avgHours > 10) {
        suggestions.add('Long hours detected - ensure adequate breaks');
      } else {
        suggestions.add('Work duration looks optimal at ${avgHours.toStringAsFixed(1)}h average');
      }

      // Location suggestions
      final locationCounts = <String, int>{};
      for (final entry in entries) {
        locationCounts[entry.locatie] = (locationCounts[entry.locatie] ?? 0) + 1;
      }

      if (locationCounts.length > 3) {
        suggestions.add('Working at ${locationCounts.length} different locations - consider consolidating');
      }

      return ScheduleSuggestion(
        message: 'Based on ${entries.length} entries',
        suggestions: suggestions,
        optimalDuration: avgHours.round(),
        preferredLocation: locationCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key,
      );

    } catch (e) {
      return ScheduleSuggestion(
        message: 'Analysis error',
        suggestions: [],
      );
    }
  }

  // ==================== UTILITIES ====================

  double _calculateStdDev(List<double> values, double mean) {
    if (values.isEmpty) return 0.0;
    final squaredDiffs = values.map((v) => pow(v - mean, 2));
    final variance = squaredDiffs.reduce((a, b) => a + b) / values.length;
    return sqrt(variance);
  }

  int _getWeekNumber(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysDifference = date.difference(firstDayOfYear).inDays;
    return (daysDifference / 7).floor();
  }

  String _getDayName(int day) {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[day - 1];
  }
}

// ==================== PREDICTION MODELS ====================

class WorkPrediction {
  final int predictedHours;
  final double confidence;
  final String message;
  final int basedOnEntries;

  WorkPrediction({
    this.predictedHours = 8,
    required this.confidence,
    required this.message,
    this.basedOnEntries = 0,
  });
}

class LocationPrediction {
  final String predictedLocation;
  final double confidence;
  final String message;
  final List<String> topLocations;
  final int basedOnEntries;

  LocationPrediction({
    this.predictedLocation = '',
    required this.confidence,
    required this.message,
    this.topLocations = const [],
    this.basedOnEntries = 0,
  });
}

class BreakPrediction {
  final int predictedBreakMinutes;
  final double confidence;
  final String message;
  final int basedOnEntries;

  BreakPrediction({
    required this.predictedBreakMinutes,
    required this.confidence,
    required this.message,
    this.basedOnEntries = 0,
  });
}

class Anomaly {
  final AnomalyType type;
  final DateTime date;
  final String description;
  final AnomalySeverity severity;
  final double value;
  final double expected;

  Anomaly({
    required this.type,
    required this.date,
    required this.description,
    required this.severity,
    required this.value,
    required this.expected,
  });
}

enum AnomalyType {
  unusualHours,
  consecutiveDays,
  unusualLocation,
  missingData,
}

enum AnomalySeverity {
  low,
  medium,
  high,
}

class ProductivityInsight {
  final double score;
  final ProductivityTrend trend;
  final String message;
  final double? recentWeeklyAvg;
  final double? previousWeeklyAvg;
  final double? changePercent;

  ProductivityInsight({
    required this.score,
    required this.trend,
    required this.message,
    this.recentWeeklyAvg,
    this.previousWeeklyAvg,
    this.changePercent,
  });
}

enum ProductivityTrend {
  increasing,
  stable,
  decreasing,
}

class ScheduleSuggestion {
  final String message;
  final List<String> suggestions;
  final int? optimalDuration;
  final String? preferredLocation;

  ScheduleSuggestion({
    required this.message,
    required this.suggestions,
    this.optimalDuration,
    this.preferredLocation,
  });
}
