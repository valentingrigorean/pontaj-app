import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../blocs/time_entry/time_entry_bloc.dart';
import '../blocs/time_entry/time_entry_event.dart';
import '../blocs/time_entry/time_entry_state.dart';
import '../models/time_entry.dart';
import '../widgets/glass_card.dart';
import '../widgets/gradient_background.dart';
import '../widgets/confetti_widget.dart';
import '../widgets/pulsing_widget.dart';

class PontajPage extends StatefulWidget {
  final String userName;
  final bool adminMode;
  final bool lockName;

  const PontajPage({
    super.key,
    required this.userName,
    this.adminMode = false,
    this.lockName = false,
  });

  @override
  State<PontajPage> createState() => _PontajPageState();
}

class _PontajPageState extends State<PontajPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();
  final _confettiController = ConfettiController();

  DateTime _selectedDate = DateTime.now();
  int _breakMinutes = 0;
  int? _quickHours;
  bool _isCelebrating = false;

  final List<int> _quickHourOptions = [4, 6, 8, 10, 12];
  final List<int> _breakOptions = [0, 15, 30, 45, 60];

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.userName;
    _startTimeController.text = '08:00';
    _endTimeController.text = '17:00';
    context.read<TimeEntryBloc>().add(const LoadEntries());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    super.dispose();
  }

  Duration _calculateWorkedTime() {
    if (_quickHours != null) {
      return Duration(hours: _quickHours!, minutes: -_breakMinutes);
    }

    final start = _parseTime(_startTimeController.text);
    final end = _parseTime(_endTimeController.text);

    if (start == null || end == null) return Duration.zero;

    var duration = end.difference(start);
    if (duration.isNegative) {
      duration = duration + const Duration(days: 1);
    }

    return duration - Duration(minutes: _breakMinutes);
  }

  DateTime? _parseTime(String time) {
    final parts = time.split(':');
    if (parts.length != 2) return null;

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);

    if (hour == null || minute == null) return null;
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;

    return DateTime(
        _selectedDate.year, _selectedDate.month, _selectedDate.day, hour, minute);
  }

  void _submitPontaj() {
    if (!_formKey.currentState!.validate()) return;

    final workedTime = _calculateWorkedTime();
    if (workedTime.inMinutes <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Timpul lucrat trebuie sa fie pozitiv')),
      );
      return;
    }

    final intervalText = _quickHours != null
        ? 'Lucrat $_quickHours ore'
        : '${_startTimeController.text} - ${_endTimeController.text}';

    final entry = TimeEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      user: _nameController.text.trim(),
      location: _locationController.text.trim(),
      intervalText: intervalText,
      breakMinutes: _breakMinutes,
      date: DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day),
      totalWorked: workedTime,
    );

    context.read<TimeEntryBloc>().add(AddEntry(entry));

    setState(() => _isCelebrating = true);
    _confettiController.celebrate();
    HapticFeedback.mediumImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Text('Pontaj salvat - ${TimeEntry.formatDuration(workedTime)}'),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );

    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) setState(() => _isCelebrating = false);
    });

    if (!widget.lockName) {
      _nameController.clear();
    }
    _locationController.clear();
    setState(() {
      _quickHours = null;
      _breakMinutes = 0;
      _selectedDate = DateTime.now();
    });
  }

  bool _hasExistingPontajToday(List<TimeEntry> entries) {
    final today =
        DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
    return entries.any((entry) {
      final entryDate =
          DateTime(entry.date.year, entry.date.month, entry.date.day);
      return entryDate == today && entry.user == _nameController.text.trim();
    });
  }

  TimeEntry? _getExistingPontajToday(List<TimeEntry> entries) {
    final today =
        DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
    try {
      return entries.firstWhere((entry) {
        final entryDate =
            DateTime(entry.date.year, entry.date.month, entry.date.day);
        return entryDate == today && entry.user == _nameController.text.trim();
      });
    } catch (_) {
      return null;
    }
  }

  void _removeExistingPontaj(TimeEntry entry) {
    context.read<TimeEntryBloc>().add(DeleteEntry(entry.id));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.delete, color: Colors.white),
            SizedBox(width: 12),
            Text('Pontaj sters'),
          ],
        ),
        backgroundColor: Colors.orange,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimeEntryBloc, TimeEntryState>(
      builder: (context, state) {
        final entries =
            state is TimeEntryLoaded ? state.entries : <TimeEntry>[];
        final locations =
            state is TimeEntryLoaded ? state.locations : <String>[];
        final workedTime = _calculateWorkedTime();
        final hasExisting = _hasExistingPontajToday(entries);
        final existingEntry = _getExistingPontajToday(entries);

        return ConfettiWidget(
          isCelebrating: _isCelebrating,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Adauga pontaj'),
              leading: widget.adminMode
                  ? IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => context.pop(),
                    )
                  : null,
            ),
            body: GradientBackground(
              animated: true,
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: SizedBox(
                            width: 120,
                            height: 120,
                            child: CustomPaint(
                              painter: _JrLogoPainter(progress: 1.0),
                              child: const Center(
                                child: Text(
                                  'JR',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 2,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (hasExisting && existingEntry != null)
                          _ExistingEntryWarning(
                            entry: existingEntry,
                            onDelete: () => _removeExistingPontaj(existingEntry),
                            onChangeDate: () {
                              setState(() {
                                _selectedDate =
                                    DateTime.now().add(const Duration(days: 1));
                              });
                            },
                          ),
                        if (hasExisting) const SizedBox(height: 16),
                        _UserInfoCard(
                          userName: widget.userName,
                          selectedDate: _selectedDate,
                          onDateChanged: (date) =>
                              setState(() => _selectedDate = date),
                        ),
                        const SizedBox(height: 16),
                        _LocationCard(
                          controller: _locationController,
                          locations: locations,
                          onLocationSelected: (loc) =>
                              setState(() => _locationController.text = loc),
                        ),
                        const SizedBox(height: 16),
                        _QuickHoursCard(
                          quickHours: _quickHours,
                          options: _quickHourOptions,
                          onSelected: (hours) =>
                              setState(() => _quickHours = hours),
                          onClear: () => setState(() => _quickHours = null),
                        ),
                        if (_quickHours == null) ...[
                          const SizedBox(height: 16),
                          _TimeIntervalCard(
                            startController: _startTimeController,
                            endController: _endTimeController,
                            onChanged: () => setState(() {}),
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Obligatoriu';
                              if (_parseTime(v) == null) return 'Format invalid';
                              return null;
                            },
                          ),
                        ],
                        const SizedBox(height: 16),
                        _BreakCard(
                          breakMinutes: _breakMinutes,
                          options: _breakOptions,
                          onSelected: (mins) =>
                              setState(() => _breakMinutes = mins),
                        ),
                        const SizedBox(height: 16),
                        _SummaryCard(workedTime: workedTime),
                        const SizedBox(height: 24),
                        PulsingWidget(
                          enabled: workedTime.inMinutes > 0 && !hasExisting,
                          child: GlassButton(
                            onPressed: _submitPontaj,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withValues(alpha: 0.2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.save,
                                    color:
                                        Theme.of(context).colorScheme.primary),
                                const SizedBox(width: 12),
                                Text(
                                  'Salveaza pontaj',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ExistingEntryWarning extends StatelessWidget {
  final TimeEntry entry;
  final VoidCallback onDelete;
  final VoidCallback onChangeDate;

  const _ExistingEntryWarning({
    required this.entry,
    required this.onDelete,
    required this.onChangeDate,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      color: Colors.orange.withValues(alpha: 0.1),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.warning, color: Colors.orange[700]),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Ai deja un pontaj pentru ziua selectata!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[900],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.location,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  entry.intervalText,
                  style: const TextStyle(fontSize: 13),
                ),
                Text(
                  'Total: ${TimeEntry.formatDuration(entry.totalWorked)}',
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: GlassButton(
                  onPressed: onDelete,
                  color: Colors.red.withValues(alpha: 0.1),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.delete, size: 18, color: Colors.red[700]),
                      const SizedBox(width: 8),
                      Text('Sterge', style: TextStyle(color: Colors.red[700])),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GlassButton(
                  onPressed: onChangeDate,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.calendar_today, size: 18),
                      SizedBox(width: 8),
                      Text('Alta zi'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _UserInfoCard extends StatelessWidget {
  final String userName;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateChanged;

  const _UserInfoCard({
    required this.userName,
    required this.selectedDate,
    required this.onDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
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
                userName[0].toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime(2020),
                lastDate: DateTime(2100),
              );
              if (date != null) {
                onDateChanged(date);
              }
            },
          ),
        ],
      ),
    );
  }
}

class _LocationCard extends StatelessWidget {
  final TextEditingController controller;
  final List<String> locations;
  final ValueChanged<String> onLocationSelected;

  const _LocationCard({
    required this.controller,
    required this.locations,
    required this.onLocationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Locatie',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Autocomplete<String>(
            optionsBuilder: (textEditingValue) {
              if (textEditingValue.text.isEmpty) {
                return locations;
              }
              return locations.where((option) => option
                  .toLowerCase()
                  .contains(textEditingValue.text.toLowerCase()));
            },
            onSelected: onLocationSelected,
            fieldViewBuilder: (context, textController, focusNode, onSubmitted) {
              controller.addListener(() {
                if (textController.text != controller.text) {
                  textController.text = controller.text;
                }
              });
              textController.addListener(() {
                if (controller.text != textController.text) {
                  controller.text = textController.text;
                }
              });

              return TextFormField(
                controller: textController,
                focusNode: focusNode,
                decoration: InputDecoration(
                  hintText: 'Ex: Casa A, Fabrica',
                  filled: true,
                  fillColor:
                      Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
                  prefixIcon: Icon(
                    Icons.location_on,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Introdu locatia';
                  }
                  return null;
                },
                onFieldSubmitted: (_) => onSubmitted(),
              );
            },
          ),
          if (locations.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: locations.take(4).map((loc) {
                return GestureDetector(
                  onTap: () => onLocationSelected(loc),
                  child: Chip(
                    label: Text(loc),
                    backgroundColor: controller.text == loc
                        ? Theme.of(context).colorScheme.primaryContainer
                        : null,
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _QuickHoursCard extends StatelessWidget {
  final int? quickHours;
  final List<int> options;
  final ValueChanged<int> onSelected;
  final VoidCallback onClear;

  const _QuickHoursCard({
    required this.quickHours,
    required this.options,
    required this.onSelected,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ore lucrate rapide',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: options.map((hours) {
              final isSelected = quickHours == hours;
              return GestureDetector(
                onTap: () => onSelected(hours),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? LinearGradient(
                            colors: [
                              Theme.of(context).colorScheme.primary,
                              Theme.of(context).colorScheme.secondary,
                            ],
                          )
                        : null,
                    color: isSelected ? null : Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey[300]!,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    '$hours ore',
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          if (quickHours != null) ...[
            const SizedBox(height: 12),
            TextButton.icon(
              icon: const Icon(Icons.clear),
              label: const Text('Foloseste interval personalizat'),
              onPressed: onClear,
            ),
          ],
        ],
      ),
    );
  }
}

class _TimeIntervalCard extends StatelessWidget {
  final TextEditingController startController;
  final TextEditingController endController;
  final VoidCallback onChanged;
  final String? Function(String?) validator;

  const _TimeIntervalCard({
    required this.startController,
    required this.endController,
    required this.onChanged,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Interval personalizat',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: startController,
                  decoration: InputDecoration(
                    labelText: 'Ora inceput',
                    hintText: '08:00',
                    filled: true,
                    fillColor: Theme.of(context)
                        .colorScheme
                        .surface
                        .withValues(alpha: 0.5),
                    prefixIcon: Icon(
                      Icons.access_time,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  keyboardType: TextInputType.datetime,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9:]')),
                    LengthLimitingTextInputFormatter(5),
                  ],
                  validator: validator,
                  onChanged: (_) => onChanged(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: endController,
                  decoration: InputDecoration(
                    labelText: 'Ora sfarsit',
                    hintText: '17:00',
                    filled: true,
                    fillColor: Theme.of(context)
                        .colorScheme
                        .surface
                        .withValues(alpha: 0.5),
                    prefixIcon: Icon(
                      Icons.access_time,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  keyboardType: TextInputType.datetime,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9:]')),
                    LengthLimitingTextInputFormatter(5),
                  ],
                  validator: validator,
                  onChanged: (_) => onChanged(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BreakCard extends StatelessWidget {
  final int breakMinutes;
  final List<int> options;
  final ValueChanged<int> onSelected;

  const _BreakCard({
    required this.breakMinutes,
    required this.options,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pauza',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: options.map((minutes) {
              final isSelected = breakMinutes == minutes;
              return GestureDetector(
                onTap: () => onSelected(minutes),
                child: Chip(
                  label: Text(minutes == 0 ? 'Fara pauza' : '$minutes min'),
                  backgroundColor: isSelected
                      ? Theme.of(context).colorScheme.primaryContainer
                      : null,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final Duration workedTime;

  const _SummaryCard({required this.workedTime});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total ore lucrate',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 4),
              Text(
                TimeEntry.formatDuration(workedTime),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ],
          ),
          Icon(
            Icons.schedule,
            size: 48,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
          ),
        ],
      ),
    );
  }
}

class _JrLogoPainter extends CustomPainter {
  const _JrLogoPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = min(size.width, size.height) * 0.42;
    final center = size.center(Offset.zero);
    const segments = 8;
    const gap = 12 * pi / 180;
    final sweep = (2 * pi / segments) - gap;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final stroke = radius * 0.18;

    final paint = Paint()
      ..color = Colors.black26
      ..strokeWidth = stroke
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    double start = -pi / 2;
    for (int i = 0; i < segments; i++) {
      canvas.drawArc(rect, start, sweep, false, paint);
      start += sweep + gap;
    }
  }

  @override
  bool shouldRepaint(covariant _JrLogoPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
