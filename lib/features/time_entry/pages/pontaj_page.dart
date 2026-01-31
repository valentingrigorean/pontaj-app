import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/responsive/responsive.dart';
import '../../../data/models/time_entry.dart';
import '../../../shared/widgets/confetti_widget.dart';
import '../../../shared/widgets/glass_button.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/gradient_background.dart';
import '../../../shared/widgets/pulsing_widget.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_state.dart';
import '../bloc/time_entry_bloc.dart';
import '../bloc/time_entry_event.dart';
import '../bloc/time_entry_state.dart';

class PontajPage extends StatefulWidget {
  final String userName;
  final bool adminMode;
  final bool lockName;
  final bool embedded;

  const PontajPage({
    super.key,
    required this.userName,
    this.adminMode = false,
    this.lockName = false,
    this.embedded = false,
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

  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.userName;
    _startTimeController.text = '08:00';
    _endTimeController.text = '17:00';

    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      _currentUserId = authState.user.id;
      context.read<TimeEntryBloc>().add(LoadEntries(
        userId: authState.user.id,
        isAdmin: authState.user.isAdmin,
      ));
    } else {
      context.read<TimeEntryBloc>().add(const LoadEntries());
    }
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

  void _submitPontaj(List<TimeEntry> entries) {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;

    final workedTime = _calculateWorkedTime();
    if (workedTime.inMinutes <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.workedTimeMustBePositive)),
      );
      return;
    }

    if (_hasOverlappingEntry(entries)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(child: Text(l10n.timeOverlapError)),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    final intervalText = _quickHours != null
        ? l10n.nHours(_quickHours!)
        : '${_startTimeController.text} - ${_endTimeController.text}';

    final entry = TimeEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: _currentUserId,
      userName: _nameController.text.trim(),
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
            Text('${l10n.pontajSaved} - ${TimeEntry.formatDuration(workedTime)}'),
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

  List<TimeEntry> _getEntriesForSelectedDate(List<TimeEntry> entries) {
    final selectedDay =
        DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
    return entries.where((entry) {
      final entryDate =
          DateTime(entry.date.year, entry.date.month, entry.date.day);
      return entryDate == selectedDay &&
          entry.userName == _nameController.text.trim();
    }).toList();
  }

  (DateTime?, DateTime?) _parseIntervalText(String intervalText, DateTime date) {
    if (!intervalText.contains(' - ')) return (null, null);
    final parts = intervalText.split(' - ');
    if (parts.length != 2) return (null, null);

    final startParts = parts[0].trim().split(':');
    final endParts = parts[1].trim().split(':');

    if (startParts.length != 2 || endParts.length != 2) return (null, null);

    final startHour = int.tryParse(startParts[0]);
    final startMinute = int.tryParse(startParts[1]);
    final endHour = int.tryParse(endParts[0]);
    final endMinute = int.tryParse(endParts[1]);

    if (startHour == null ||
        startMinute == null ||
        endHour == null ||
        endMinute == null) {
      return (null, null);
    }

    final start = DateTime(date.year, date.month, date.day, startHour, startMinute);
    var end = DateTime(date.year, date.month, date.day, endHour, endMinute);

    return (start, end);
  }

  bool _timeRangesOverlap(
      DateTime start1, DateTime end1, DateTime start2, DateTime end2) {
    var adjustedEnd1 = end1;
    var adjustedEnd2 = end2;

    if (end1.isBefore(start1) || end1.isAtSameMomentAs(start1)) {
      adjustedEnd1 = end1.add(const Duration(days: 1));
    }
    if (end2.isBefore(start2) || end2.isAtSameMomentAs(start2)) {
      adjustedEnd2 = end2.add(const Duration(days: 1));
    }

    return start1.isBefore(adjustedEnd2) && start2.isBefore(adjustedEnd1);
  }

  bool _hasOverlappingEntry(List<TimeEntry> entries) {
    if (_quickHours != null) return false;

    final newStart = _parseTime(_startTimeController.text);
    final newEnd = _parseTime(_endTimeController.text);

    if (newStart == null || newEnd == null) return false;

    final existingEntries = _getEntriesForSelectedDate(entries);

    for (final entry in existingEntries) {
      final (existingStart, existingEnd) =
          _parseIntervalText(entry.intervalText, entry.date);

      if (existingStart == null || existingEnd == null) continue;

      if (_timeRangesOverlap(newStart, newEnd, existingStart, existingEnd)) {
        return true;
      }
    }

    return false;
  }

  void _removeExistingPontaj(TimeEntry entry) {
    final entryId = entry.id;
    if (entryId == null) return;
    final l10n = AppLocalizations.of(context)!;
    context.read<TimeEntryBloc>().add(DeleteEntry(entryId));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.delete, color: Colors.white),
            const SizedBox(width: 12),
            Text(l10n.pontajDeleted),
          ],
        ),
        backgroundColor: Colors.orange,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<TimeEntryBloc, TimeEntryState>(
      builder: (context, state) {
        final entries =
            state is TimeEntryLoaded ? state.entries : <TimeEntry>[];
        final locations =
            state is TimeEntryLoaded ? state.locations : <String>[];
        final workedTime = _calculateWorkedTime();
        final existingEntries = _getEntriesForSelectedDate(entries);
        final hasExistingEntries = existingEntries.isNotEmpty;

        return ConfettiWidget(
          isCelebrating: _isCelebrating,
          child: Scaffold(
            appBar: widget.embedded
                ? null
                : AppBar(
                    title: Text(l10n.addPontaj),
                    leading: widget.adminMode
                        ? IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () => context.pop(),
                          )
                        : null,
                  ),
            body: GradientBackground(
              animated: false,
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: ResponsiveSpacing.pagePadding(context),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600),
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
                        if (hasExistingEntries)
                          _ExistingEntriesInfo(
                            entries: existingEntries,
                            onDelete: _removeExistingPontaj,
                            l10n: l10n,
                          ),
                        if (hasExistingEntries) const SizedBox(height: 16),
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
                          l10n: l10n,
                        ),
                        const SizedBox(height: 16),
                        _QuickHoursCard(
                          quickHours: _quickHours,
                          options: _quickHourOptions,
                          onSelected: (hours) =>
                              setState(() => _quickHours = hours),
                          onClear: () => setState(() => _quickHours = null),
                          disabled: hasExistingEntries,
                          l10n: l10n,
                        ),
                        if (_quickHours == null || hasExistingEntries) ...[
                          const SizedBox(height: 16),
                          _TimeIntervalCard(
                            startController: _startTimeController,
                            endController: _endTimeController,
                            onChanged: () => setState(() {}),
                            validator: (v) {
                              if (v == null || v.isEmpty) return l10n.required;
                              if (_parseTime(v) == null) return l10n.invalidFormat;
                              return null;
                            },
                            l10n: l10n,
                          ),
                        ],
                        const SizedBox(height: 16),
                        _BreakCard(
                          breakMinutes: _breakMinutes,
                          options: _breakOptions,
                          onSelected: (mins) =>
                              setState(() => _breakMinutes = mins),
                          l10n: l10n,
                        ),
                        const SizedBox(height: 16),
                        _SummaryCard(workedTime: workedTime, l10n: l10n),
                        const SizedBox(height: 24),
                        PulsingWidget(
                          enabled: workedTime.inMinutes > 0,
                          child: GlassButton(
                            onPressed: () => _submitPontaj(entries),
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
                                  l10n.savePontaj,
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
            ),
          ),
        );
      },
    );
  }
}

class _ExistingEntriesInfo extends StatelessWidget {
  final List<TimeEntry> entries;
  final void Function(TimeEntry) onDelete;
  final AppLocalizations l10n;

  const _ExistingEntriesInfo({
    required this.entries,
    required this.onDelete,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      color: Colors.blue.withValues(alpha: 0.1),
      enableBlur: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue[700]),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.requireCustomInterval,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...entries.map((entry) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.location,
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${entry.intervalText} • ${TimeEntry.formatDuration(entry.totalWorked)}',
                              style: const TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete_outline, color: Colors.red[700]),
                        onPressed: () => onDelete(entry),
                        tooltip: l10n.delete,
                      ),
                    ],
                  ),
                ),
              )),
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
      enableBlur: false,
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
  final AppLocalizations l10n;

  const _LocationCard({
    required this.controller,
    required this.locations,
    required this.onLocationSelected,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      enableBlur: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.location,
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
                  hintText: l10n.locationHint,
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
                    return l10n.enterLocation;
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
  final bool disabled;
  final AppLocalizations l10n;

  const _QuickHoursCard({
    required this.quickHours,
    required this.options,
    required this.onSelected,
    required this.onClear,
    this.disabled = false,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      enableBlur: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.quickHours,
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
              final isSelected = quickHours == hours && !disabled;
              return GestureDetector(
                onTap: disabled ? null : () => onSelected(hours),
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
                    color: isSelected
                        ? null
                        : disabled
                            ? Colors.grey[300]
                            : Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey[300]!,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    l10n.nHours(hours),
                    style: TextStyle(
                      color: disabled
                          ? Colors.grey[500]
                          : isSelected
                              ? Colors.white
                              : Colors.black87,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          if (quickHours != null && !disabled) ...[
            const SizedBox(height: 12),
            TextButton.icon(
              icon: const Icon(Icons.clear),
              label: Text(l10n.useCustomInterval),
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
  final AppLocalizations l10n;

  const _TimeIntervalCard({
    required this.startController,
    required this.endController,
    required this.onChanged,
    required this.validator,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      enableBlur: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.customInterval,
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
                    labelText: l10n.startTime,
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
                    labelText: l10n.endTime,
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
  final AppLocalizations l10n;

  const _BreakCard({
    required this.breakMinutes,
    required this.options,
    required this.onSelected,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      enableBlur: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.breakTime,
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
                  label: Text(minutes == 0 ? l10n.noBreak : l10n.nMinutes(minutes)),
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
  final AppLocalizations l10n;

  const _SummaryCard({required this.workedTime, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      enableBlur: false,
      color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.totalHoursWorked,
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
