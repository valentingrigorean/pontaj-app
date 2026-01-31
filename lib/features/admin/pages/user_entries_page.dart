import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/responsive/responsive.dart';
import '../../../data/models/time_entry.dart';
import '../../time_entry/bloc/time_entry_bloc.dart';
import '../../time_entry/bloc/time_entry_event.dart';
import '../../time_entry/bloc/time_entry_state.dart';

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
    _verticalScroll = .new();
    _horizontalScroll = .new();
    context.read<TimeEntryBloc>().add(const LoadEntries(isAdmin: true));
  }

  @override
  void dispose() {
    _verticalScroll.dispose();
    _horizontalScroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.pontajUser(widget.userName))),
      body: BlocBuilder<TimeEntryBloc, TimeEntryState>(
        builder: (context, state) {
          if (state is TimeEntryLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is! TimeEntryLoaded) {
            return Center(child: Text(l10n.couldNotLoadData));
          }

          final entries =
              state.entries.where((e) => e.user == widget.userName).toList()
                ..sort((a, b) => b.date.compareTo(a.date));

          final total = entries.fold<Duration>(
            Duration.zero,
            (sum, e) => sum + e.totalWorked,
          );

          if (entries.isEmpty) {
            return Center(child: Text(l10n.noPontajForUser));
          }

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Column(
                children: [
                  Padding(
                    padding: ResponsiveSpacing.pagePadding(context),
                    child: Row(
                      children: [
                        Text(
                          l10n.nDaysRegistered(entries.length),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const Spacer(),
                        Text(
                          '${l10n.total}: ${TimeEntry.formatDuration(total)}',
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
                            columns: [
                              DataColumn(label: Text(l10n.date)),
                              DataColumn(label: Text(l10n.location)),
                              DataColumn(label: Text(l10n.interval)),
                              DataColumn(label: Text(l10n.breakTime)),
                              DataColumn(label: Text(l10n.total)),
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
                                        Text(
                                          TimeEntry.formatDuration(
                                            e.totalWorked,
                                          ),
                                        ),
                                      ),
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
              ),
            ),
          );
        },
      ),
    );
  }
}
