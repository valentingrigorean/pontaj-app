import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../shared/widgets/gradient_background.dart';
import '../../time_entry/bloc/time_entry_bloc.dart';
import '../../time_entry/bloc/time_entry_event.dart';
import '../../time_entry/bloc/time_entry_state.dart';
import '../widgets/entries_table_view.dart';
import '../widgets/users_entries_view.dart';

enum EntriesViewMode { users, table }

class AllEntriesPage extends StatefulWidget {
  final bool embedded;

  const AllEntriesPage({super.key, this.embedded = false});

  @override
  State<AllEntriesPage> createState() => _AllEntriesPageState();
}

class _AllEntriesPageState extends State<AllEntriesPage> {
  late final ScrollController _tableScroll;
  EntriesViewMode _viewMode = EntriesViewMode.users;

  @override
  void initState() {
    super.initState();
    _tableScroll = ScrollController();
    if (widget.embedded) {
      context.read<TimeEntryBloc>().add(const LoadEntries(isAdmin: true));
    }
  }

  @override
  void dispose() {
    _tableScroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<TimeEntryBloc, TimeEntryState>(
      builder: (context, state) {
        if (state is TimeEntryLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is! TimeEntryLoaded) {
          return Center(child: Text(l10n.couldNotLoadData));
        }

        final entriesByUser = state.entriesByUser;
        final groupedEntries = entriesByUser.entries.toList()
          ..sort(
              (a, b) => a.key.toLowerCase().compareTo(b.key.toLowerCase()));

        final content = Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SegmentedButton<EntriesViewMode>(
                segments: [
                  ButtonSegment(
                    value: EntriesViewMode.users,
                    icon: const Icon(Icons.people, size: 20),
                    label: Text(l10n.users),
                  ),
                  ButtonSegment(
                    value: EntriesViewMode.table,
                    icon: const Icon(Icons.table_chart, size: 20),
                    label: Text(l10n.table),
                  ),
                ],
                selected: {_viewMode},
                onSelectionChanged: (Set<EntriesViewMode> selection) {
                  setState(() => _viewMode = selection.first);
                },
              ),
            ),
            Expanded(
              child: _viewMode == EntriesViewMode.users
                  ? UsersEntriesView(
                      groupedEntries: groupedEntries,
                      l10n: l10n,
                    )
                  : EntriesTableView(
                      groupedEntries: groupedEntries,
                      l10n: l10n,
                      scrollController: _tableScroll,
                    ),
            ),
          ],
        );

        if (widget.embedded) {
          return GradientBackground(
            animated: false,
            child: content,
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.entriesTab),
          ),
          body: GradientBackground(
            animated: false,
            child: content,
          ),
        );
      },
    );
  }
}
