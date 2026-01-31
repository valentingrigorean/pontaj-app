import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/time_entry/time_entry_bloc.dart';
import '../blocs/time_entry/time_entry_event.dart';
import '../blocs/time_entry/time_entry_state.dart';
import '../models/time_entry.dart';

class UserEntriesPage extends StatefulWidget {
  final String userName;

  const UserEntriesPage({super.key, required this.userName});

  @override
  State<UserEntriesPage> createState() => _UserEntriesPageState();
}

class _UserEntriesPageState extends State<UserEntriesPage> {
  late final ScrollController _verticalScroll;
  late final ScrollController _horizontalScroll;

  @override
  void initState() {
    super.initState();
    _verticalScroll = ScrollController();
    _horizontalScroll = ScrollController();
    context.read<TimeEntryBloc>().add(LoadEntries(username: widget.userName));
  }

  @override
  void dispose() {
    _verticalScroll.dispose();
    _horizontalScroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pontaje - ${widget.userName}'),
      ),
      body: BlocBuilder<TimeEntryBloc, TimeEntryState>(
        builder: (context, state) {
          if (state is TimeEntryLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is! TimeEntryLoaded) {
            return const Center(child: Text('Nu s-au putut incarca datele'));
          }

          final entries = state.entries
              .where((e) => e.user == widget.userName)
              .toList()
            ..sort((a, b) => b.date.compareTo(a.date));

          final total = entries.fold<Duration>(
            Duration.zero,
            (sum, e) => sum + e.totalWorked,
          );

          if (entries.isEmpty) {
            return const Center(
              child: Text('Nu exista pontaje pentru acest utilizator.'),
            );
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Text(
                      '${entries.length} zile inregistrate',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Spacer(),
                    Text(
                      'Total: ${TimeEntry.formatDuration(total)}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Scrollbar(
                  controller: _verticalScroll,
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    controller: _verticalScroll,
                    primary: false,
                    padding: const EdgeInsets.only(bottom: 16),
                    child: SingleChildScrollView(
                      controller: _horizontalScroll,
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('Data')),
                          DataColumn(label: Text('Locatie')),
                          DataColumn(label: Text('Interval')),
                          DataColumn(label: Text('Pauza')),
                          DataColumn(label: Text('Total')),
                        ],
                        rows: entries
                            .map(
                              (e) => DataRow(
                                cells: [
                                  DataCell(
                                    Text(
                                      '${e.date.day}/${e.date.month}/${e.date.year}',
                                    ),
                                  ),
                                  DataCell(Text(e.location)),
                                  DataCell(Text(e.intervalText)),
                                  DataCell(Text('${e.breakMinutes}m')),
                                  DataCell(
                                      Text(TimeEntry.formatDuration(e.totalWorked))),
                                ],
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
