import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../data/models/time_entry.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_state.dart';
import '../../time_entry/bloc/time_entry_bloc.dart';
import '../../time_entry/bloc/time_entry_event.dart';
import '../../time_entry/bloc/time_entry_state.dart';

class EntryBottomSheet extends StatefulWidget {
  final String userName;
  final bool isAdmin;

  const EntryBottomSheet({
    super.key,
    required this.userName,
    this.isAdmin = false,
  });

  @override
  State<EntryBottomSheet> createState() => _EntryBottomSheetState();
}

class _EntryBottomSheetState extends State<EntryBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _locationController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();

  late String _selectedUserName;
  DateTime _selectedDate = DateTime.now();
  int _breakMinutes = 0;
  int? _quickHours;
  bool _isSubmitting = false;

  final List<int> _quickHourOptions = [4, 6, 8, 10, 12];
  final List<int> _breakOptions = [0, 15, 30, 45, 60];

  @override
  void initState() {
    super.initState();
    _selectedUserName = widget.userName;
    _startTimeController.text = '08:00';
    _endTimeController.text = '17:00';
  }

  @override
  void dispose() {
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
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      hour,
      minute,
    );
  }

  void _submit() {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;

    final workedTime = _calculateWorkedTime();
    if (workedTime.inMinutes <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.workedTimeMustBePositive)));
      return;
    }

    setState(() => _isSubmitting = true);

    final authState = context.read<AuthBloc>().state;
    final userId = authState is AuthAuthenticated ? authState.user.id : null;

    final intervalText = _quickHours != null
        ? l10n.nHours(_quickHours!)
        : '${_startTimeController.text} - ${_endTimeController.text}';

    final entry = TimeEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      userName: _selectedUserName.trim(),
      location: _locationController.text.trim(),
      intervalText: intervalText,
      breakMinutes: _breakMinutes,
      date: DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
      ),
      totalWorked: workedTime,
    );

    context.read<TimeEntryBloc>().add(AddEntry(entry));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Text(
              '${l10n.pontajSaved} - ${TimeEntry.formatDuration(workedTime)}',
            ),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: .circular(12)),
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final workedTime = _calculateWorkedTime();

    return BlocBuilder<TimeEntryBloc, TimeEntryState>(
      builder: (context, state) {
        final locations = state is TimeEntryLoaded
            ? state.locations
            : <String>[];
        final users = state is TimeEntryLoaded
            ? state.entries.map((e) => e.userName).toSet().toList()
            : <String>[];

        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const .vertical(top: .circular(24)),
              ),
              child: Column(
                children: [
                  _buildHandle(),
                  _buildHeader(l10n),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      padding: const .all(20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: .stretch,
                          children: [
                            if (widget.isAdmin) ...[
                              _buildUserSelector(l10n, users),
                              const SizedBox(height: 16),
                            ],
                            _buildDateSelector(l10n),
                            const SizedBox(height: 16),
                            _buildLocationField(l10n, locations),
                            const SizedBox(height: 16),
                            _buildQuickHoursSelector(l10n),
                            if (_quickHours == null) ...[
                              const SizedBox(height: 16),
                              _buildTimeIntervalFields(l10n),
                            ],
                            const SizedBox(height: 16),
                            _buildBreakSelector(l10n),
                            const SizedBox(height: 24),
                            _buildSummary(l10n, workedTime),
                            const SizedBox(height: 24),
                            _buildSubmitButton(l10n, workedTime),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHandle() {
    return Container(
      margin: const .only(top: 12),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: .circular(2),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations l10n) {
    return Padding(
      padding: const .all(20),
      child: Row(
        children: [
          Icon(
            Icons.add_circle,
            color: Theme.of(context).colorScheme.primary,
            size: 28,
          ),
          const SizedBox(width: 12),
          Text(
            l10n.addEntry,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: .bold),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildUserSelector(AppLocalizations l10n, List<String> users) {
    return GlassCard(
      enableBlur: false,
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text(
            l10n.user,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: .bold),
          ),
          const SizedBox(height: 12),
          Autocomplete<String>(
            initialValue: TextEditingValue(text: _selectedUserName),
            optionsBuilder: (textEditingValue) {
              if (textEditingValue.text.isEmpty) {
                return users;
              }
              return users.where(
                (u) => u.toLowerCase().contains(
                  textEditingValue.text.toLowerCase(),
                ),
              );
            },
            onSelected: (user) {
              setState(() => _selectedUserName = user);
            },
            fieldViewBuilder: (context, controller, focusNode, onSubmitted) {
              return TextFormField(
                controller: controller,
                focusNode: focusNode,
                decoration: InputDecoration(
                  hintText: l10n.user,
                  filled: true,
                  fillColor: Theme.of(
                    context,
                  ).colorScheme.surface.withValues(alpha: 0.5),
                  prefixIcon: Icon(
                    Icons.person,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                onChanged: (value) {
                  setState(() => _selectedUserName = value);
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.required;
                  }
                  return null;
                },
              );
            },
          ),
          if (users.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: users.take(5).map((user) {
                final isSelected = _selectedUserName == user;
                return GestureDetector(
                  onTap: () => setState(() => _selectedUserName = user),
                  child: Chip(
                    label: Text(user),
                    backgroundColor: isSelected
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

  Widget _buildDateSelector(AppLocalizations l10n) {
    return GlassCard(
      enableBlur: false,
      child: Row(
        children: [
          Icon(
            Icons.calendar_today,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  l10n.date,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                ),
                Text(
                  '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(fontWeight: .bold),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime(2020),
                lastDate: DateTime(2100),
              );
              if (date != null) {
                setState(() => _selectedDate = date);
              }
            },
            child: Text(l10n.otherDay),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationField(AppLocalizations l10n, List<String> locations) {
    return GlassCard(
      enableBlur: false,
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text(
            l10n.location,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: .bold),
          ),
          const SizedBox(height: 12),
          Autocomplete<String>(
            optionsBuilder: (textEditingValue) {
              if (textEditingValue.text.isEmpty) {
                return locations;
              }
              return locations.where(
                (loc) => loc.toLowerCase().contains(
                  textEditingValue.text.toLowerCase(),
                ),
              );
            },
            onSelected: (loc) {
              setState(() => _locationController.text = loc);
            },
            fieldViewBuilder: (context, controller, focusNode, onSubmitted) {
              _locationController.addListener(() {
                if (controller.text != _locationController.text) {
                  controller.text = _locationController.text;
                }
              });
              controller.addListener(() {
                if (_locationController.text != controller.text) {
                  _locationController.text = controller.text;
                }
              });

              return TextFormField(
                controller: controller,
                focusNode: focusNode,
                decoration: InputDecoration(
                  hintText: l10n.locationHint,
                  filled: true,
                  fillColor: Theme.of(
                    context,
                  ).colorScheme.surface.withValues(alpha: 0.5),
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
              );
            },
          ),
          if (locations.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: locations.take(4).map((loc) {
                final isSelected = _locationController.text == loc;
                return GestureDetector(
                  onTap: () => setState(() => _locationController.text = loc),
                  child: Chip(
                    label: Text(loc),
                    backgroundColor: isSelected
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

  Widget _buildQuickHoursSelector(AppLocalizations l10n) {
    return GlassCard(
      enableBlur: false,
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text(
            l10n.quickHours,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: .bold),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _quickHourOptions.map((hours) {
              final isSelected = _quickHours == hours;
              return GestureDetector(
                onTap: () => setState(() => _quickHours = hours),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const .symmetric(horizontal: 20, vertical: 12),
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
                    borderRadius: .circular(20),
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
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: isSelected ? .bold : .normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          if (_quickHours != null) ...[
            const SizedBox(height: 12),
            TextButton.icon(
              icon: const Icon(Icons.clear),
              label: Text(l10n.useCustomInterval),
              onPressed: () => setState(() => _quickHours = null),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTimeIntervalFields(AppLocalizations l10n) {
    return GlassCard(
      enableBlur: false,
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text(
            l10n.customInterval,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: .bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _startTimeController,
                  decoration: InputDecoration(
                    labelText: l10n.startTime,
                    hintText: '08:00',
                    filled: true,
                    fillColor: Theme.of(
                      context,
                    ).colorScheme.surface.withValues(alpha: 0.5),
                    prefixIcon: Icon(
                      Icons.access_time,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  keyboardType: TextInputType.datetime,
                  onChanged: (_) => setState(() {}),
                  validator: (v) {
                    if (v == null || v.isEmpty) return l10n.required;
                    if (_parseTime(v) == null) return l10n.invalidFormat;
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _endTimeController,
                  decoration: InputDecoration(
                    labelText: l10n.endTime,
                    hintText: '17:00',
                    filled: true,
                    fillColor: Theme.of(
                      context,
                    ).colorScheme.surface.withValues(alpha: 0.5),
                    prefixIcon: Icon(
                      Icons.access_time,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  keyboardType: TextInputType.datetime,
                  onChanged: (_) => setState(() {}),
                  validator: (v) {
                    if (v == null || v.isEmpty) return l10n.required;
                    if (_parseTime(v) == null) return l10n.invalidFormat;
                    return null;
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBreakSelector(AppLocalizations l10n) {
    return GlassCard(
      enableBlur: false,
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text(
            l10n.breakTime,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: .bold),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _breakOptions.map((minutes) {
              final isSelected = _breakMinutes == minutes;
              return GestureDetector(
                onTap: () => setState(() => _breakMinutes = minutes),
                child: Chip(
                  label: Text(
                    minutes == 0 ? l10n.noBreak : l10n.nMinutes(minutes),
                  ),
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

  Widget _buildSummary(AppLocalizations l10n, Duration workedTime) {
    return GlassCard(
      enableBlur: false,
      color: Theme.of(
        context,
      ).colorScheme.primaryContainer.withValues(alpha: 0.3),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                l10n.totalHoursWorked,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 4),
              Text(
                TimeEntry.formatDuration(workedTime),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: .bold,
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

  Widget _buildSubmitButton(AppLocalizations l10n, Duration workedTime) {
    final isValid = workedTime.inMinutes > 0;

    return FilledButton.icon(
      onPressed: isValid && !_isSubmitting ? _submit : null,
      icon: _isSubmitting
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.save),
      label: Text(l10n.savePontaj),
      style: FilledButton.styleFrom(
        padding: const .symmetric(vertical: 16),
        textStyle: const TextStyle(fontSize: 16, fontWeight: .bold),
      ),
    );
  }
}
