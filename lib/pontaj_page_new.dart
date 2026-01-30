import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'store.dart';
import 'widgets/glass_card.dart';
import 'widgets/gradient_background.dart';
import 'widgets/confetti_widget.dart';
import 'widgets/pulsing_widget.dart';

class PontajPageNew extends StatefulWidget {
  final String userName;
  final bool adminMode;
  final bool lockName;

  const PontajPageNew({
    super.key,
    required this.userName,
    required this.adminMode,
    this.lockName = false,
  });

  @override
  State<PontajPageNew> createState() => _PontajPageNewState();
}

class _PontajPageNewState extends State<PontajPageNew> {
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
    // Set default times
    _startTimeController.text = '08:00';
    _endTimeController.text = '17:00';
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

    return DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, hour, minute);
  }

  void _submitPontaj() {
    if (!_formKey.currentState!.validate()) return;

    final workedTime = _calculateWorkedTime();
    if (workedTime.inMinutes <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Timpul lucrat trebuie să fie pozitiv')),
      );
      return;
    }

    final intervalText = _quickHours != null
        ? 'Lucrat $_quickHours ore'
        : '${_startTimeController.text} - ${_endTimeController.text}';

    appStore.addEntry(
      PontajEntry(
        user: _nameController.text.trim(),
        locatie: _locationController.text.trim(),
        intervalText: intervalText,
        breakMinutes: _breakMinutes,
        date: DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day),
        totalWorked: workedTime,
      ),
    );

    // CELEBRATE! 🎉
    setState(() => _isCelebrating = true);
    _confettiController.celebrate();

    // Vibrate feedback
    HapticFeedback.mediumImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Text('Pontaj salvat - ${appStore.fmt(workedTime)} 🎉'),
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

    // Reset form
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

  bool _hasExistingPontajToday() {
    final today = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
    return appStore.entries.any((entry) {
      final entryDate = DateTime(entry.date.year, entry.date.month, entry.date.day);
      return entryDate == today && entry.user == _nameController.text.trim();
    });
  }

  PontajEntry? _getExistingPontajToday() {
    final today = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
    try {
      return appStore.entries.firstWhere((entry) {
        final entryDate = DateTime(entry.date.year, entry.date.month, entry.date.day);
        return entryDate == today && entry.user == _nameController.text.trim();
      });
    } catch (_) {
      return null;
    }
  }

  void _removeExistingPontaj() {
    final existing = _getExistingPontajToday();
    if (existing != null) {
      final index = appStore.entries.indexOf(existing);
      if (index != -1) {
        appStore.deleteEntry(index);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.delete, color: Colors.white),
                SizedBox(width: 12),
                Text('Pontaj șters'),
              ],
            ),
            backgroundColor: Colors.orange,
          ),
        );
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final savedLocations = appStore.locatii;
    final workedTime = _calculateWorkedTime();
    final hasExisting = _hasExistingPontajToday();
    final existingEntry = _getExistingPontajToday();

    return ConfettiWidget(
      isCelebrating: _isCelebrating,
      child: Scaffold(
      appBar: AppBar(
        title: const Text('Adaugă pontaj'),
        actions: [
          if (widget.adminMode)
            IconButton(
              icon: const Icon(Icons.home),
              tooltip: 'Înapoi la admin',
              onPressed: () => Navigator.pop(context),
            ),
        ],
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
                  // JR Logo at top
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

                  // Warning if pontaj already exists for today
                  if (hasExisting && existingEntry != null)
                    GlassCard(
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
                                  'Ai deja un pontaj pentru ziua selectată!',
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
                                  '📍 ${existingEntry.locatie}',
                                  style: const TextStyle(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '⏱️ ${existingEntry.intervalText}',
                                  style: const TextStyle(fontSize: 13),
                                ),
                                Text(
                                  '💼 Total: ${appStore.fmt(existingEntry.totalWorked)}',
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
                                  onPressed: _removeExistingPontaj,
                                  color: Colors.red.withValues(alpha: 0.1),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.delete, size: 18, color: Colors.red[700]),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Șterge',
                                        style: TextStyle(color: Colors.red[700]),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: GlassButton(
                                  onPressed: () {
                                    setState(() {
                                      _selectedDate = DateTime.now().add(const Duration(days: 1));
                                    });
                                  },
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.calendar_today, size: 18),
                                      SizedBox(width: 8),
                                      Text('Altă zi'),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                  if (hasExisting) const SizedBox(height: 16),

                  // User Info Card
                  GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
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
                                  widget.userName[0].toUpperCase(),
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
                                    widget.userName,
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  Text(
                                    '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: Colors.grey[600],
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.calendar_today),
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
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Location Card
                  GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Locație',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 12),
                        Autocomplete<String>(
                          optionsBuilder: (TextEditingValue textEditingValue) {
                            if (textEditingValue.text.isEmpty) {
                              return savedLocations;
                            }
                            return savedLocations.where((String option) {
                              return option.toLowerCase().contains(
                                    textEditingValue.text.toLowerCase(),
                                  );
                            });
                          },
                          onSelected: (String selection) {
                            _locationController.text = selection;
                          },
                          fieldViewBuilder: (
                            context,
                            controller,
                            focusNode,
                            onFieldSubmitted,
                          ) {
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
                                hintText: 'Ex: Casa A, Fabrica',
                                filled: true,
                                fillColor: Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
                                prefixIcon: Icon(
                                  Icons.location_on,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Introdu locația';
                                }
                                return null;
                              },
                              onFieldSubmitted: (value) => onFieldSubmitted(),
                            );
                          },
                        ),
                        if (savedLocations.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: savedLocations.take(4).map((loc) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _locationController.text = loc;
                                  });
                                },
                                child: Chip(
                                  label: Text(loc),
                                  backgroundColor: _locationController.text == loc
                                      ? Theme.of(context).colorScheme.primaryContainer
                                      : null,
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Quick Hours Card
                  GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ore lucrate rapide',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _quickHourOptions.map((hours) {
                            final isSelected = _quickHours == hours;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _quickHours = hours;
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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
                            label: const Text('Folosește interval personalizat'),
                            onPressed: () {
                              setState(() {
                                _quickHours = null;
                              });
                            },
                          ),
                        ],
                      ],
                    ),
                  ),

                  if (_quickHours == null) ...[
                    const SizedBox(height: 16),
                    // Time Interval Card
                    GlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Interval personalizat',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _startTimeController,
                                  decoration: InputDecoration(
                                    labelText: 'Ora început',
                                    hintText: '08:00',
                                    filled: true,
                                    fillColor: Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
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
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Obligatoriu';
                                    }
                                    if (_parseTime(value) == null) {
                                      return 'Format invalid';
                                    }
                                    return null;
                                  },
                                  onChanged: (_) => setState(() {}),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  controller: _endTimeController,
                                  decoration: InputDecoration(
                                    labelText: 'Ora sfârșit',
                                    hintText: '17:00',
                                    filled: true,
                                    fillColor: Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
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
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Obligatoriu';
                                    }
                                    if (_parseTime(value) == null) {
                                      return 'Format invalid';
                                    }
                                    return null;
                                  },
                                  onChanged: (_) => setState(() {}),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 16),

                  // Break Time Card
                  GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pauză',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _breakOptions.map((minutes) {
                            final isSelected = _breakMinutes == minutes;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _breakMinutes = minutes;
                                });
                              },
                              child: Chip(
                                label: Text(minutes == 0 ? 'Fără pauză' : '$minutes min'),
                                backgroundColor: isSelected
                                    ? Theme.of(context).colorScheme.primaryContainer
                                    : null,
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Summary Card
                  GlassCard(
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
                              appStore.fmt(workedTime),
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
                  ),
                  const SizedBox(height: 24),

                  // Submit Button with PULSE effect
                  PulsingWidget(
                    enabled: workedTime.inMinutes > 0 && !hasExisting,
                    child: GlassButton(
                      onPressed: _submitPontaj,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.save, color: Theme.of(context).colorScheme.primary),
                          const SizedBox(width: 12),
                          Text(
                            'Salvează pontaj',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
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
      ), // Close ConfettiWidget
    );
  }
}

// EXACT JR Logo Painter - DO NOT MODIFY (used on actual JR clothing!)
class _JrLogoPainter extends CustomPainter {
  const _JrLogoPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = min(size.width, size.height) * 0.42;
    final center = size.center(Offset.zero);
    const segments = 8; // EXACT: 8 segments
    const gap = 12 * pi / 180; // EXACT: 12 degrees gap
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
