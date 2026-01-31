import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/responsive/responsive.dart';
import '../../admin/pages/all_entries_page.dart';
import '../../admin/pages/dashboard_page.dart';
import '../../admin/pages/salary_page.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_state.dart';
import '../../dashboard/pages/user_dashboard_page.dart';
import '../../invoice/bloc/invoice_bloc.dart';
import '../../invoice/bloc/invoice_event.dart';
import '../../invoice/pages/invoice_list_page.dart';
import '../../invoice/widgets/invoice_bottom_sheet.dart';
import '../../time_entry/bloc/time_entry_bloc.dart';
import '../../time_entry/bloc/time_entry_event.dart';
import '../../time_entry/pages/my_entries_page.dart';
import '../widgets/entry_bottom_sheet.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadEntries();
    _loadInvoices();
  }

  void _loadEntries() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<TimeEntryBloc>().add(
        LoadEntries(userId: authState.user.id, isAdmin: authState.user.isAdmin),
      );
    }
  }

  void _loadInvoices() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<InvoiceBloc>().add(
        LoadInvoices(
          userId: authState.user.id,
          isAdmin: authState.user.isAdmin,
        ),
      );
    }
  }

  void _showEntryBottomSheet() {
    final authState = context.read<AuthBloc>().state;
    if (authState is! AuthAuthenticated) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EntryBottomSheet(
        userName: authState.user.displayNameOrEmail,
        isAdmin: authState.user.isAdmin,
      ),
    );
  }

  void _showInvoiceBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const InvoiceBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authState = context.watch<AuthBloc>().state;

    if (authState is! AuthAuthenticated) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final isAdmin = authState.user.isAdmin;
    final destinations = _getDestinations(l10n, isAdmin);
    final pages = _getPages(isAdmin);

    if (context.isMobile) {
      return Scaffold(
        appBar: _buildAppBar(l10n),
        body: IndexedStack(index: _selectedIndex, children: pages),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) {
            setState(() => _selectedIndex = index);
          },
          destinations: destinations
              .map(
                (d) => NavigationDestination(
                  icon: Icon(d.icon),
                  selectedIcon: Icon(d.selectedIcon),
                  label: d.label,
                ),
              )
              .toList(),
        ),
        floatingActionButton: _buildFab(l10n, isAdmin),
      );
    }

    return Scaffold(
      appBar: _buildAppBar(l10n),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() => _selectedIndex = index);
            },
            extended: context.isDesktop,
            minExtendedWidth: 200,
            labelType: context.isDesktop
                ? NavigationRailLabelType.none
                : NavigationRailLabelType.all,
            leading: Column(
              children: [
                if (context.isDesktop)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: _AppLogo(),
                  )
                else
                  const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: FloatingActionButton.small(
                    onPressed: isAdmin && _selectedIndex == 3
                        ? _showInvoiceBottomSheet
                        : _showEntryBottomSheet,
                    child: const Icon(Icons.add),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
            destinations: destinations
                .map(
                  (d) => NavigationRailDestination(
                    icon: Icon(d.icon),
                    selectedIcon: Icon(d.selectedIcon),
                    label: Text(d.label),
                  ),
                )
                .toList(),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: IndexedStack(index: _selectedIndex, children: pages),
          ),
        ],
      ),
    );
  }

  List<_NavigationDestination> _getDestinations(
    AppLocalizations l10n,
    bool isAdmin,
  ) {
    if (isAdmin) {
      return [
        _NavigationDestination(
          icon: Icons.dashboard_outlined,
          selectedIcon: Icons.dashboard,
          label: l10n.dashboard,
        ),
        _NavigationDestination(
          icon: Icons.people_outline,
          selectedIcon: Icons.people,
          label: l10n.entriesTab,
        ),
        _NavigationDestination(
          icon: Icons.attach_money_outlined,
          selectedIcon: Icons.attach_money,
          label: l10n.salaries,
        ),
        _NavigationDestination(
          icon: Icons.receipt_long_outlined,
          selectedIcon: Icons.receipt_long,
          label: l10n.invoices,
        ),
      ];
    }

    return [
      _NavigationDestination(
        icon: Icons.dashboard_outlined,
        selectedIcon: Icons.dashboard,
        label: l10n.dashboard,
      ),
      _NavigationDestination(
        icon: Icons.list_alt_outlined,
        selectedIcon: Icons.list_alt,
        label: l10n.myEntries,
      ),
    ];
  }

  List<Widget> _getPages(bool isAdmin) {
    if (isAdmin) {
      return const [
        DashboardPage(embedded: true),
        AllEntriesPage(embedded: true),
        SalaryPage(embedded: true),
        InvoiceListPage(isAdmin: true, embedded: true),
      ];
    }

    return const [UserDashboardPage(), MyEntriesPage(embedded: true)];
  }

  Widget? _buildFab(AppLocalizations l10n, bool isAdmin) {
    final isInvoicesTab = isAdmin && _selectedIndex == 3;

    if (isInvoicesTab) {
      return FloatingActionButton.extended(
        onPressed: _showInvoiceBottomSheet,
        icon: const Icon(Icons.add),
        label: Text(l10n.createInvoice),
      );
    }

    return FloatingActionButton.extended(
      onPressed: _showEntryBottomSheet,
      icon: const Icon(Icons.add),
      label: Text(l10n.addEntry),
    );
  }

  PreferredSizeWidget _buildAppBar(AppLocalizations l10n) {
    return AppBar(
      title: Text(l10n.appTitle),
      centerTitle: true,
      actions: [
        IconButton(
          tooltip: l10n.settings,
          icon: const Icon(Icons.settings),
          onPressed: () => context.push('/settings'),
        ),
      ],
    );
  }
}

class _NavigationDestination {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const _NavigationDestination({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}

class _AppLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
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
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: const Center(
        child: Text(
          'JR',
          style: TextStyle(
            fontSize: 18,
            fontWeight: .w900,
            color: Colors.white,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}
