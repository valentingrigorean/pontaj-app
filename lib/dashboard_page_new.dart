import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'store.dart';
import 'widgets/glass_card.dart';
import 'widgets/gradient_background.dart';
import 'widgets/number_ticker.dart';

class DashboardPageNew extends StatefulWidget {
  const DashboardPageNew({super.key});

  @override
  State<DashboardPageNew> createState() => _DashboardPageNewState();
}

class _DashboardPageNewState extends State<DashboardPageNew> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  DateTimeRange? _dateRange;
  int _touchedPieIndex = -1;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appStore,
      builder: (context, _) {
        final stats = _calculateStats();

        return GradientBackground(
          animated: true,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with JR Logo
                _buildHeader(context),
                const SizedBox(height: 24),

                // KPI Cards
                _buildKPICards(context, stats),
                const SizedBox(height: 24),

                // Charts Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: _buildHoursBarChart(context, stats),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTopWorkers(context, stats),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Location Distribution Pie Chart
                _buildLocationPieChart(context, stats),
                const SizedBox(height: 16),

                // Recent Activity
                _buildRecentActivity(context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // JR Logo
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Center(
              child: Text(
                'JR',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                    ],
                  ).createShader(bounds),
                  child: Text(
                    'Tablou de Bord',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _dateRange != null
                      ? 'Perioadă: ${_formatDate(_dateRange!.start)} - ${_formatDate(_dateRange!.end)}'
                      : 'Toate datele • Analiză completă',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),
          ),
          IconButton.filledTonal(
            icon: const Icon(Icons.date_range),
            tooltip: 'Filtrează perioada',
            onPressed: _showDateRangePicker,
          ),
          if (_dateRange != null) ...[
            const SizedBox(width: 8),
            IconButton.filledTonal(
              icon: const Icon(Icons.clear),
              tooltip: 'Resetează filtru',
              onPressed: () => setState(() => _dateRange = null),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildKPICards(BuildContext context, Map<String, dynamic> stats) {
    final totalHours = stats['totalHours'] as double;
    final totalDays = stats['totalDays'] as int;
    final avgHoursPerDay = stats['avgHoursPerDay'] as double;
    final totalUsers = stats['totalUsers'] as int;

    return Row(
      children: [
        Expanded(
          child: _buildKPICard(
            context,
            'Total Ore',
            totalHours,
            Icons.access_time,
            Theme.of(context).colorScheme.primary,
            suffix: 'h',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildKPICard(
            context,
            'Zile Lucrate',
            totalDays.toDouble(),
            Icons.calendar_today,
            Colors.green,
            decimals: 0,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildKPICard(
            context,
            'Medie/Zi',
            avgHoursPerDay,
            Icons.trending_up,
            Colors.orange,
            suffix: 'h',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildKPICard(
            context,
            'Angajați',
            totalUsers.toDouble(),
            Icons.people,
            Colors.blue,
            decimals: 0,
          ),
        ),
      ],
    );
  }

  Widget _buildKPICard(
    BuildContext context,
    String label,
    double value,
    IconData icon,
    Color color, {
    int decimals = 1,
    String suffix = '',
  }) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 12),
          NumberTicker(
            value: value,
            decimals: decimals,
            suffix: suffix,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildHoursBarChart(BuildContext context, Map<String, dynamic> stats) {
    final userHours = stats['userHours'] as Map<String, double>;
    if (userHours.isEmpty) {
      return _buildEmptyState(context, 'Nicio dată disponibilă', Icons.bar_chart);
    }

    final sortedEntries = userHours.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final topUsers = sortedEntries.take(8).toList();

    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.bar_chart, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 12),
              Text(
                'Ore Lucrate pe Angajat',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 300,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: topUsers.first.value * 1.2,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => Colors.black87,
                    tooltipRoundedRadius: 8,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final user = topUsers[group.x.toInt()].key;
                      final hours = topUsers[group.x.toInt()].value;
                      return BarTooltipItem(
                        '$user\n${hours.toStringAsFixed(1)}h',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= topUsers.length) return const SizedBox();
                        final userName = topUsers[value.toInt()].key;
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            userName.length > 8 ? '${userName.substring(0, 8)}...' : userName,
                            style: const TextStyle(fontSize: 11),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}h',
                          style: const TextStyle(fontSize: 11),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withValues(alpha: 0.2),
                      strokeWidth: 1,
                    );
                  },
                ),
                barGroups: List.generate(topUsers.length, (index) {
                  final hours = topUsers[index].value;
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: hours,
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).colorScheme.primary,
                            Theme.of(context).colorScheme.secondary,
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                        width: 20,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopWorkers(BuildContext context, Map<String, dynamic> stats) {
    final userHours = stats['userHours'] as Map<String, double>;
    if (userHours.isEmpty) {
      return _buildEmptyState(context, 'Nicio dată', Icons.people);
    }

    final sortedUsers = userHours.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final topThree = sortedUsers.take(3).toList();

    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.emoji_events, color: Colors.amber[700]),
              const SizedBox(width: 12),
              Text(
                'Top 3',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...topThree.asMap().entries.map((entry) {
            final index = entry.key;
            final user = entry.value;
            final podiumColors = [Colors.amber, Colors.grey[400] ?? Colors.grey, Colors.brown[300] ?? Colors.brown];
            final podiumIcons = [Icons.looks_one, Icons.looks_two, Icons.looks_3];

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: podiumColors[index].withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: podiumColors[index].withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(podiumIcons[index], color: podiumColors[index], size: 32),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.key,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            '${user.value.toStringAsFixed(1)} ore',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildLocationPieChart(BuildContext context, Map<String, dynamic> stats) {
    final locationData = stats['locationData'] as Map<String, int>;
    if (locationData.isEmpty) {
      return _buildEmptyState(context, 'Nicio locație', Icons.location_on);
    }

    final total = locationData.values.fold(0, (sum, val) => sum + val);
    final colors = _generateColors(locationData.length);

    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.pie_chart, color: Theme.of(context).colorScheme.secondary),
              const SizedBox(width: 12),
              Text(
                'Distribuție Locații',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 250,
            child: Row(
              children: [
                Expanded(
                  child: PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              _touchedPieIndex = -1;
                              return;
                            }
                            _touchedPieIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                          });
                        },
                      ),
                      borderData: FlBorderData(show: false),
                      sectionsSpace: 2,
                      centerSpaceRadius: 60,
                      sections: locationData.entries.toList().asMap().entries.map((entry) {
                        final index = entry.key;
                        final location = entry.value;
                        final isTouched = index == _touchedPieIndex;
                        final radius = isTouched ? 70.0 : 60.0;
                        final fontSize = isTouched ? 16.0 : 14.0;

                        return PieChartSectionData(
                          color: colors[index],
                          value: location.value.toDouble(),
                          title: '${(location.value / total * 100).toStringAsFixed(1)}%',
                          radius: radius,
                          titleStyle: TextStyle(
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                // Legend
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: locationData.entries.toList().asMap().entries.map((entry) {
                    final index = entry.key;
                    final location = entry.value;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: colors[index],
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            location.key,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '(${location.value})',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity(BuildContext context) {
    final recentEntries = appStore.entries.take(5).toList();

    if (recentEntries.isEmpty) {
      return _buildEmptyState(context, 'Nicio activitate', Icons.history);
    }

    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.history, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 12),
              Text(
                'Activitate Recentă',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...recentEntries.map((entry) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.secondary,
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        entry.user[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.user,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${entry.locatie} • ${entry.intervalText}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        appStore.fmt(entry.totalWorked),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      Text(
                        _formatDate(entry.date),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String message, IconData icon) {
    return GlassCard(
      padding: const EdgeInsets.all(40),
      child: Center(
        child: Column(
          children: [
            Icon(icon, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              message,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _calculateStats() {
    List<PontajEntry> filteredEntries = appStore.entries;

    if (_dateRange != null) {
      filteredEntries = filteredEntries.where((entry) {
        return entry.date.isAfter(_dateRange!.start.subtract(const Duration(days: 1))) &&
            entry.date.isBefore(_dateRange!.end.add(const Duration(days: 1)));
      }).toList();
    }

    double totalHours = 0;
    int totalDays = filteredEntries.length;
    final Map<String, double> userHours = {};
    final Map<String, int> locationData = {};

    for (final entry in filteredEntries) {
      final hours = entry.totalWorked.inMinutes / 60;
      totalHours += hours;
      userHours[entry.user] = (userHours[entry.user] ?? 0) + hours;
      locationData[entry.locatie] = (locationData[entry.locatie] ?? 0) + 1;
    }

    final avgHoursPerDay = totalDays > 0 ? totalHours / totalDays : 0.0;
    final totalUsers = userHours.keys.length;

    return {
      'totalHours': totalHours,
      'totalDays': totalDays,
      'avgHoursPerDay': avgHoursPerDay,
      'totalUsers': totalUsers,
      'userHours': userHours,
      'locationData': locationData,
    };
  }

  Future<void> _showDateRangePicker() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDateRange: _dateRange,
    );

    if (picked != null) {
      setState(() => _dateRange = picked);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  List<Color> _generateColors(int count) {
    return List.generate(count, (index) {
      final hue = (index * 360 / count) % 360;
      return HSLColor.fromAHSL(1.0, hue, 0.7, 0.6).toColor();
    });
  }
}
