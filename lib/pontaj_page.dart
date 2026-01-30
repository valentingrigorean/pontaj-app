import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'store.dart';

class PontajPage extends StatefulWidget {
  final String userName;
  final bool adminMode;
  final bool lockName;
  const PontajPage({
    super.key,
    required this.userName,
    required this.adminMode,
    this.lockName = false,
  });

  @override
  State<PontajPage> createState() => _PontajPageState();
}

class _PontajPageState extends State<PontajPage> with SingleTickerProviderStateMixin {
  final nume = TextEditingController();
  final locatie = TextEditingController();
  final interval = TextEditingController();
  final customBreak = TextEditingController();
  final FocusNode _locatieFocus = FocusNode();
  final FocusNode _intervalFocus = FocusNode();
  final LayerLink _locatieLink = LayerLink();
  final ScrollController _locSuggestionsScroll = ScrollController();
  OverlayEntry? _locatieOverlay;
  double _locFieldWidth = 0;
  int _locScrollIndex = 0;
  int _intervalScrollIndex = 0;
  String brk = 'Fără pauză';
  int brkMin = 0;
  Duration total = Duration.zero;
  DateTime date = DateTime.now();
  int? _presetHours;
  bool _suppressIntervalListener = false;
  late AnimationController _logoController;

  // Intervale predefinite de la 1 oră la 12 ore
  final List<String> _intervalePredefinite = List.generate(
    12,
    (index) {
      final ore = index + 1;
      return ore == 1 ? 'Lucrat 1 oră' : 'Lucrat $ore ore';
    },
  );

  @override
  void initState() {
    super.initState();
    nume.text = widget.userName;
    interval.addListener(_handleIntervalChanged);
    customBreak.addListener(_recalc);
    _locatieFocus.addListener(() {
      if (!_locatieFocus.hasFocus) _removeLocationOverlay();
    });
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    nume.dispose();
    locatie.dispose();
    interval.dispose();
    customBreak.dispose();
    _locatieFocus.dispose();
    _intervalFocus.dispose();
    _locSuggestionsScroll.dispose();
    _logoController.dispose();
    _removeLocationOverlay();
    super.dispose();
  }

  Duration _parseInterval(String raw) {
    final txt = raw.replaceAll(' ', '');
    final reg = RegExp(r'^(\d{1,2}):?(\d{2})?-(\d{1,2}):?(\d{2})?$');
    final match = reg.firstMatch(txt);
    if (match == null) return Duration.zero;
    int h1 = int.parse(match.group(1)!);
    int m1 = int.parse(match.group(2) ?? '00');
    int h2 = int.parse(match.group(3)!);
    int m2 = int.parse(match.group(4) ?? '00');
    final start = Duration(hours: h1 % 24, minutes: m1.clamp(0, 59));
    var end = Duration(hours: h2 % 24, minutes: m2.clamp(0, 59));
    if (end < start) end += const Duration(days: 1);
    return end - start;
  }

  void _handleIntervalChanged() {
    if (_suppressIntervalListener) return;
    if (_presetHours != null) {
      setState(() => _presetHours = null);
    }
    _recalc();
  }

  void _recalc() {
    final base =
        _presetHours != null ? Duration(hours: _presetHours!) : _parseInterval(interval.text);
    final custom = brk == 'Custom'
        ? int.tryParse(customBreak.text) ?? 0
        : brkMin;
    setState(() {
      final mins = (base.inMinutes - custom).clamp(0, 1440);
      total = Duration(minutes: mins);
    });
  }

  void _applyPresetHours(int hours) {
    setState(() {
      _presetHours = hours;
      brk = 'Fără pauză';
      brkMin = 0;
      customBreak.clear();
      _suppressIntervalListener = true;
      interval.text = 'Lucrat $hours ore';
      _suppressIntervalListener = false;
      total = Duration(hours: hours);
    });
  }

  void _submit() {
    final name = nume.text.trim();
    final loc = locatie.text.trim();
    final intv = interval.text.trim();
    if (name.isEmpty || loc.isEmpty || intv.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completează numele, locația și intervalul.')),
      );
      return;
    }
    appStore.addEntry(
      PontajEntry(
        user: name,
        locatie: loc,
        intervalText: intv,
        breakMinutes: brk == 'Custom'
            ? int.tryParse(customBreak.text) ?? 0
            : brkMin,
        date: DateTime(date.year, date.month, date.day),
        totalWorked: total,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pontaj salvat')),
    );
    interval.clear();
    customBreak.clear();
    setState(() {
      brk = 'Fără pauză';
      brkMin = 0;
      total = Duration.zero;
      _presetHours = null;
    });
  }

  void _showLocationOverlay(List<String> saved) {
    if (_locatieOverlay != null || saved.isEmpty) return;
    final overlay = Overlay.of(context);
    _locatieOverlay = OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _removeLocationOverlay,
        child: Stack(
          children: [
            CompositedTransformFollower(
              link: _locatieLink,
              showWhenUnlinked: false,
              targetAnchor: Alignment.bottomLeft,
              followerAnchor: Alignment.topLeft,
              offset: const Offset(0, 8),
              child: _LocationSuggestionList(
                controller: locatie,
                scrollController: _locSuggestionsScroll,
                width: _locFieldWidth == 0 ? 360 : _locFieldWidth,
                items: saved,
                onSelected: (value) {
                  setState(() {
                    locatie.text = value;
                    locatie.selection = TextSelection.fromPosition(
                      TextPosition(offset: value.length),
                    );
                  });
                  _removeLocationOverlay();
                  FocusScope.of(context).requestFocus(_locatieFocus);
                },
              ),
            ),
          ],
        ),
      ),
    );
    overlay.insert(_locatieOverlay!);
  }

  void _removeLocationOverlay() {
    _locatieOverlay?.remove();
    _locatieOverlay = null;
  }

  void _syncLocationIndex(List<String> saved) {
    if (saved.isEmpty) return;
    final current = saved.indexWhere(
      (loc) => loc.toLowerCase() == locatie.text.trim().toLowerCase(),
    );
    if (current != -1) {
      _locScrollIndex = current;
    } else if (_locScrollIndex >= saved.length) {
      _locScrollIndex = saved.length - 1;
    }
    if (_locScrollIndex < 0) _locScrollIndex = 0;
  }

  void _cycleLocation(List<String> saved, int delta) {
    if (saved.isEmpty) return;
    _syncLocationIndex(saved);
    var next = _locScrollIndex + delta;
    while (next < 0) {
      next += saved.length;
    }
    next %= saved.length;
    _locScrollIndex = next;
    final value = saved[_locScrollIndex];

    // Force rebuild by removing and re-adding overlay
    final hadOverlay = _locatieOverlay != null;
    if (hadOverlay) {
      _removeLocationOverlay();
    }

    setState(() {
      locatie.text = value;
      locatie.selection = TextSelection.fromPosition(
        TextPosition(offset: value.length),
      );
    });

    // Re-show overlay if it was open
    if (hadOverlay) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _showLocationOverlay(saved);
      });
    }
  }

  void _cycleInterval(int delta) {
    if (_intervalePredefinite.isEmpty) return;
    var next = _intervalScrollIndex + delta;
    while (next < 0) {
      next += _intervalePredefinite.length;
    }
    next %= _intervalePredefinite.length;
    _intervalScrollIndex = next;
    final value = _intervalePredefinite[_intervalScrollIndex];
    setState(() {
      _suppressIntervalListener = true;
      interval.text = value;
      interval.selection = TextSelection.fromPosition(
        TextPosition(offset: value.length),
      );
      _suppressIntervalListener = false;
      _presetHours = null;
      _recalc();
    });
  }

  void _updateBreak(String label, int minutes) {
    setState(() {
      brk = label;
      brkMin = minutes;
    });
    _recalc();
  }

  @override
  Widget build(BuildContext context) {
    final locatiiSugestii = appStore.locatii;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.adminMode ? 'Pontaj (Admin)' : 'Pontaj Ore Muncă'),
        actions: [
          if (widget.adminMode)
            IconButton(
              tooltip: 'Toate pontajele',
              icon: const Icon(Icons.table_chart),
              onPressed: () => Navigator.pushNamed(context, '/entries'),
            ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _submit,
        icon: const Icon(Icons.save_outlined),
        label: const Text('Salvează pontaj'),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Logo JR animat în background
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _logoController,
                builder: (context, child) {
                  return Center(
                    child: Transform.scale(
                      scale: 1.0 + (sin(_logoController.value * 2 * pi) * 0.05),
                      child: Transform.rotate(
                        angle: _logoController.value * pi / 4,
                        child: Opacity(
                          opacity: 0.03,
                          child: _BackgroundJrLogo(),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Conținut
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor:
                            Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
                        child: Icon(
                          widget.adminMode ? Icons.manage_history : Icons.person,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.userName,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.adminMode
                                  ? 'Mod administrator'
                                  : 'Utilizator standard',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: date,
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) setState(() => date = picked);
                        },
                        icon: const Icon(Icons.event),
                        label: Text('${date.day}/${date.month}/${date.year}'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _SectionCard(
                title: 'Detalii utilizator',
                child: Column(
                  children: [
                    TextField(
                      controller: nume,
                      enabled: widget.adminMode && !widget.lockName,
                      decoration: const InputDecoration(
                        labelText: 'Nume muncitor',
                      ),
                    ),
                    const SizedBox(height: 16),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        _locFieldWidth = constraints.maxWidth;
                        return Listener(
                          onPointerSignal: (event) {
                            if (event is PointerScrollEvent &&
                                _locatieFocus.hasFocus &&
                                event.scrollDelta.dy != 0) {
                              final direction = event.scrollDelta.dy > 0 ? 1 : -1;
                              _cycleLocation(locatiiSugestii, direction);
                            }
                          },
                          child: CompositedTransformTarget(
                            link: _locatieLink,
                            child: TextField(
                              controller: locatie,
                              focusNode: _locatieFocus,
                              decoration: InputDecoration(
                                labelText: 'Locație',
                                suffixIcon: IconButton(
                                  tooltip: 'Locații salvate',
                                  icon: const Icon(Icons.list_alt),
                                  onPressed: () => _locatieOverlay == null
                                      ? _showLocationOverlay(locatiiSugestii)
                                      : _removeLocationOverlay(),
                                ),
                              ),
                              textInputAction: TextInputAction.next,
                              onTap: () {
                                if (locatiiSugestii.isNotEmpty) {
                                  // Auto-select prima opțiune la click
                                  if (locatie.text.trim().isEmpty) {
                                    setState(() {
                                      locatie.text = locatiiSugestii[0];
                                      locatie.selection = TextSelection.fromPosition(
                                        TextPosition(offset: locatiiSugestii[0].length),
                                      );
                                      _locScrollIndex = 0;
                                    });
                                  } else {
                                    _syncLocationIndex(locatiiSugestii);
                                  }
                                }
                                _showLocationOverlay(locatiiSugestii);
                              },
                              onChanged: (_) => _syncLocationIndex(locatiiSugestii),
                            ),
                          ),
                        );
                      },
                    ),
                    if (locatiiSugestii.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: locatiiSugestii
                            .take(6)
                            .map(
                              (loc) => ChoiceChip(
                                label: Text(loc),
                                selected: locatie.text.trim().toLowerCase() ==
                                    loc.toLowerCase(),
                                onSelected: (_) => setState(() {
                                  locatie.text = loc;
                                  locatie.selection = TextSelection.fromPosition(
                                    TextPosition(offset: loc.length),
                                  );
                                }),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ],
                ),
              ),
              _SectionCard(
                title: 'Programul zilei',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Listener(
                      onPointerSignal: (event) {
                        if (event is PointerScrollEvent &&
                            _intervalFocus.hasFocus &&
                            event.scrollDelta.dy != 0) {
                          final direction = event.scrollDelta.dy > 0 ? 1 : -1;
                          _cycleInterval(direction);
                        }
                      },
                      child: TextField(
                        controller: interval,
                        focusNode: _intervalFocus,
                        decoration: const InputDecoration(
                          labelText: 'Interval ore',
                          hintText: 'Ex: 08:00 - 17:00',
                        ),
                        keyboardType: TextInputType.datetime,
                        onTap: () {
                          // Auto-select primul interval (08:00 - 09:00) la click dacă e gol
                          if (interval.text.trim().isEmpty && _intervalePredefinite.isNotEmpty) {
                            setState(() {
                              _suppressIntervalListener = true;
                              interval.text = _intervalePredefinite[0];
                              interval.selection = TextSelection.fromPosition(
                                TextPosition(offset: _intervalePredefinite[0].length),
                              );
                              _intervalScrollIndex = 0;
                              _suppressIntervalListener = false;
                              _presetHours = null;
                              _recalc();
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Ore lucrate rapide',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      children: [5, 8, 10, 12]
                          .map(
                            (hours) => ChoiceChip(
                              label: Text('$hours ore'),
                              selected: _presetHours == hours,
                              onSelected: (_) => _applyPresetHours(hours),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                    Text('Pauză',
                        style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      children: [
                        _BreakChip(
                          label: 'Fără pauză',
                          selected: brk == 'Fără pauză',
                          onTap: () => _updateBreak('Fără pauză', 0),
                        ),
                        _BreakChip(
                          label: '30 min',
                          selected: brk == '30m',
                          onTap: () => _updateBreak('30m', 30),
                        ),
                        _BreakChip(
                          label: '1 oră',
                          selected: brk == '1h',
                          onTap: () => _updateBreak('1h', 60),
                        ),
                        _BreakChip(
                          label: 'Custom',
                          selected: brk == 'Custom',
                          onTap: () => _updateBreak('Custom', 0),
                        ),
                      ],
                    ),
                    if (brk == 'Custom') ...[
                      const SizedBox(height: 10),
                      TextField(
                        controller: customBreak,
                        keyboardType: TextInputType.number,
                        decoration:
                            const InputDecoration(labelText: 'Minute pauză'),
                      ),
                    ],
                  ],
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(vertical: 12),
                child: ListTile(
                  leading: const Icon(Icons.timer_outlined),
                  title: const Text('Total lucrat'),
                  subtitle: Text(appStore.fmt(total)),
                ),
              ),
              const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget pentru logo-ul JR în background
class _BackgroundJrLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 300,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            painter: _JrLogoPainter(progress: 1.0),
            size: const Size.square(250),
          ),
          const Text(
            'JR',
            style: TextStyle(
              color: Colors.black26,
              fontSize: 80,
              fontWeight: FontWeight.w900,
              letterSpacing: 6,
            ),
          ),
        ],
      ),
    );
  }
}

// Painter pentru cercul segmentat JR
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

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _BreakChip extends StatelessWidget {
  const _BreakChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
    );
  }
}

class _LocationSuggestionList extends StatelessWidget {
  final TextEditingController controller;
  final ScrollController scrollController;
  final double width;
  final List<String> items;
  final ValueChanged<String> onSelected;

  const _LocationSuggestionList({
    required this.controller,
    required this.scrollController,
    required this.width,
    required this.items,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(12),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: width,
          maxWidth: width,
          maxHeight: 280,
        ),
        child: ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (_, value, __) {
            final query = value.text.trim().toLowerCase();
            final filtered = query.isEmpty
                ? items
                : items
                    .where((loc) => loc.toLowerCase().contains(query))
                    .toList();
            if (filtered.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(12),
                child: Text('Nu există locații salvate încă.'),
              );
            }
            return Scrollbar(
              controller: scrollController,
              thumbVisibility: true,
              child: ListView.separated(
                controller: scrollController,
                padding: EdgeInsets.zero,
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final loc = filtered[index];
                  return ListTile(
                    dense: true,
                    title: Text(loc),
                    onTap: () => onSelected(loc),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
