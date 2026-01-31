import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/time_entry/time_entry_bloc.dart';
import '../blocs/time_entry/time_entry_event.dart';
import '../blocs/time_entry/time_entry_state.dart';
import '../models/time_entry.dart';
import '../widgets/glass_card.dart';
import '../widgets/gradient_background.dart';
import '../widgets/staggered_animation.dart';
import 'dashboard_page.dart';
import 'salary_page.dart';

class AllEntriesPage extends StatefulWidget {
  const AllEntriesPage({super.key});

  @override
  State<AllEntriesPage> createState() => _AllEntriesPageState();
}

class _AllEntriesPageState extends State<AllEntriesPage>
    with SingleTickerProviderStateMixin {
  late TabController tab;
  late final ScrollController _tableScroll;

  @override
  void initState() {
    super.initState();
    tab = TabController(length: 4, vsync: this);
    _tableScroll = ScrollController();
    context.read<TimeEntryBloc>().add(const LoadEntries());
  }

  @override
  void dispose() {
    _tableScroll.dispose();
    tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pontaje - Administrator'),
        bottom: TabBar(
          controller: tab,
          tabs: const [
            Tab(icon: Icon(Icons.dashboard), text: 'Tablou de Bord'),
            Tab(icon: Icon(Icons.people), text: 'Utilizatori'),
            Tab(icon: Icon(Icons.table_chart), text: 'Tabel'),
            Tab(icon: Icon(Icons.attach_money), text: 'Salarii'),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Setari',
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
          ),
          IconButton(
            tooltip: 'Deconectare',
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(const AuthLogoutRequested());
            },
          ),
        ],
      ),
      body: BlocBuilder<TimeEntryBloc, TimeEntryState>(
        builder: (context, state) {
          if (state is TimeEntryLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is! TimeEntryLoaded) {
            return const Center(child: Text('Nu s-au putut incarca datele'));
          }

          final entriesByUser = state.entriesByUser;
          final groupedEntries = entriesByUser.entries.toList()
            ..sort(
                (a, b) => a.key.toLowerCase().compareTo(b.key.toLowerCase()));

          return TabBarView(
            controller: tab,
            children: [
              const DashboardPage(),
              _buildUsersTab(groupedEntries),
              _buildTableTab(groupedEntries),
              const SalaryPage(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildUsersTab(List<MapEntry<String, List<TimeEntry>>> groupedEntries) {
    if (groupedEntries.isEmpty) {
      return GradientBackground(
        animated: true,
        child: Center(
          child: GlassCard(
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'Niciun pontaj',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return GradientBackground(
      animated: true,
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: groupedEntries.length,
        itemBuilder: (context, index) {
          final entry = groupedEntries[index];
          final user = entry.key;
          final list = entry.value;
          final total = list.fold<Duration>(
            Duration.zero,
            (s, e) => s + e.totalWorked,
          );
          return StaggeredAnimationItem(
            delay: Duration(milliseconds: 50 * index),
            duration: const Duration(milliseconds: 400),
            child: GlassCard(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              child: InkWell(
                onTap: () =>
                    context.push('/userEntries', extra: {'user': user}),
                borderRadius: BorderRadius.circular(16),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
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
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          user[0].toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
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
                            user,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.calendar_today,
                                  size: 14, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Text(
                                '${list.length} zile',
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 13),
                              ),
                              const SizedBox(width: 12),
                              Icon(Icons.access_time,
                                  size: 14, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Text(
                                TimeEntry.formatDuration(total),
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 13),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.chevron_right,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTableTab(
      List<MapEntry<String, List<TimeEntry>>> groupedEntries) {
    if (groupedEntries.isEmpty) {
      return GradientBackground(
        animated: true,
        child: Center(
          child: GlassCard(
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.table_chart, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'Niciun pontaj',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return GradientBackground(
      animated: true,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: GlassCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.table_chart,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Tabel Utilizatori',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Scrollbar(
                  controller: _tableScroll,
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    controller: _tableScroll,
                    primary: false,
                    padding: const EdgeInsets.only(bottom: 16),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          dataTableTheme: DataTableThemeData(
                            headingRowColor: WidgetStateProperty.all(
                              Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withValues(alpha: 0.1),
                            ),
                            dataRowColor:
                                WidgetStateProperty.resolveWith((states) {
                              if (states.contains(WidgetState.selected)) {
                                return Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withValues(alpha: 0.15);
                              }
                              return null;
                            }),
                          ),
                        ),
                        child: DataTable(
                          headingRowHeight: 56,
                          dataRowMinHeight: 48,
                          dataRowMaxHeight: 64,
                          columns: [
                            DataColumn(
                              label: Row(
                                children: [
                                  Icon(Icons.person,
                                      size: 18,
                                      color:
                                          Theme.of(context).colorScheme.primary),
                                  const SizedBox(width: 8),
                                  const Text('Utilizator',
                                      style:
                                          TextStyle(fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            DataColumn(
                              label: Row(
                                children: [
                                  Icon(Icons.calendar_today,
                                      size: 18,
                                      color:
                                          Theme.of(context).colorScheme.primary),
                                  const SizedBox(width: 8),
                                  const Text('Zile',
                                      style:
                                          TextStyle(fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            DataColumn(
                              label: Row(
                                children: [
                                  Icon(Icons.access_time,
                                      size: 18,
                                      color:
                                          Theme.of(context).colorScheme.primary),
                                  const SizedBox(width: 8),
                                  const Text('Total ore',
                                      style:
                                          TextStyle(fontWeight: FontWeight.bold)),
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
                                      Container(
                                        width: 32,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                            ],
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(
                                            user[0].toUpperCase(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        user,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '${list.length}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue[700],
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      TimeEntry.formatDuration(total),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                              onSelectChanged: (_) => context.push(
                                '/userEntries',
                                extra: {'user': user},
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
