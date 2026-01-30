import 'package:flutter/material.dart';

import 'store.dart';

class UserEntriesPage extends StatefulWidget {
  const UserEntriesPage({super.key});

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
  }

  @override
  void dispose() {
    _verticalScroll.dispose();
    _horizontalScroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final userName = args is Map && args['user'] is String
        ? args['user'] as String
        : 'Utilizator';
    final entries = appStore.entries
        .where((e) => e.user == userName)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    final total = entries.fold<Duration>(
      Duration.zero,
      (sum, e) => sum + e.totalWorked,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Pontaje - $userName'),
      ),
      body: entries.isEmpty
          ? const Center(child: Text('Nu există pontaje pentru acest utilizator.'))
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Text(
                        '${entries.length} zile înregistrate',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const Spacer(),
                      Text(
                        'Total: ${appStore.fmt(total)}',
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
                            DataColumn(label: Text('Locație')),
                            DataColumn(label: Text('Interval')),
                            DataColumn(label: Text('Pauză')),
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
                                    DataCell(Text(e.locatie)),
                                    DataCell(Text(e.intervalText)),
                                    DataCell(Text('${e.breakMinutes}m')),
                                    DataCell(Text(appStore.fmt(e.totalWorked))),
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
    );
  }
}
