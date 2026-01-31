import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/responsive/responsive.dart';
import '../../../data/models/time_entry.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/side_panel.dart';
import '../pages/user_entries_page.dart';
import 'user_avatar.dart';

class EntriesTableView extends StatelessWidget {
  final List<MapEntry<String, List<TimeEntry>>> groupedEntries;
  final AppLocalizations l10n;
  final ScrollController scrollController;

  const EntriesTableView({
    super.key,
    required this.groupedEntries,
    required this.l10n,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    if (groupedEntries.isEmpty) {
      return Center(
        child: GlassCard(
          padding: const .all(40),
          enableBlur: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.table_chart, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                l10n.noPontaj,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    final theme = Theme.of(context);

    return Padding(
      padding: ResponsiveSpacing.pagePadding(context),
      child: GlassCard(
        padding: const .all(20),
        enableBlur: false,
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Row(
              children: [
                Icon(Icons.table_chart, color: theme.colorScheme.primary),
                const SizedBox(width: 12),
                Text(
                  l10n.usersTable,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: .bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Scrollbar(
                    controller: scrollController,
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      controller: scrollController,
                      primary: false,
                      padding: const EdgeInsets.only(bottom: 16),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: constraints.maxWidth,
                          ),
                          child: _EntriesDataTable(
                            groupedEntries: groupedEntries,
                            l10n: l10n,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EntriesDataTable extends StatelessWidget {
  final List<MapEntry<String, List<TimeEntry>>> groupedEntries;
  final AppLocalizations l10n;

  const _EntriesDataTable({required this.groupedEntries, required this.l10n});

  void _showUserDetail(BuildContext context, String userName) {
    if (kIsWeb) {
      showSidePanel(
        context: context,
        width: 500,
        builder: (_) => UserEntriesPage(userName: userName, embedded: true),
      );
    } else {
      context.push('/userEntries', extra: {'user': userName});
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Theme(
      data: theme.copyWith(
        dataTableTheme: DataTableThemeData(
          headingRowColor: WidgetStateProperty.all(
            theme.colorScheme.primary.withValues(alpha: 0.1),
          ),
          dataRowColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return theme.colorScheme.primary.withValues(alpha: 0.15);
            }
            return null;
          }),
        ),
      ),
      child: DataTable(
        showCheckboxColumn: false,
        headingRowHeight: 56,
        dataRowMinHeight: 48,
        dataRowMaxHeight: 64,
        columns: [
          DataColumn(
            label: Row(
              children: [
                Icon(Icons.person, size: 18, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(l10n.user, style: const TextStyle(fontWeight: .bold)),
              ],
            ),
          ),
          DataColumn(
            label: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 18,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(l10n.days, style: const TextStyle(fontWeight: .bold)),
              ],
            ),
          ),
          DataColumn(
            label: Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 18,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.totalHours,
                  style: const TextStyle(fontWeight: .bold),
                ),
              ],
            ),
          ),
        ],
        rows: groupedEntries.map((entry) {
          final user = entry.key;
          final list = entry.value;
          final total = list.fold<Duration>(
            Duration.zero,
            (sum, e) => sum + e.totalWorked,
          );
          return DataRow(
            cells: [
              DataCell(
                Row(
                  children: [
                    UserAvatar(
                      name: user,
                      size: 32,
                      fontSize: 14,
                      showShadow: false,
                    ),
                    const SizedBox(width: 12),
                    Text(user, style: const TextStyle(fontWeight: .w600)),
                  ],
                ),
              ),
              DataCell(
                Container(
                  padding: const .symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: .circular(12),
                  ),
                  child: Text(
                    '${list.length}',
                    style: TextStyle(
                      fontWeight: .bold,
                      color: Colors.blue[700],
                    ),
                  ),
                ),
              ),
              DataCell(
                Container(
                  padding: const .symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: .circular(12),
                  ),
                  child: Text(
                    TimeEntry.formatDuration(total),
                    style: TextStyle(
                      fontWeight: .bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ],
            onSelectChanged: (_) => _showUserDetail(context, user),
          );
        }).toList(),
      ),
    );
  }
}
