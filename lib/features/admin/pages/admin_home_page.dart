import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/responsive/responsive.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_event.dart';
import '../../auth/bloc/auth_state.dart';
import '../../time_entry/bloc/time_entry_bloc.dart';
import '../../time_entry/bloc/time_entry_event.dart';
import '../../time_entry/pages/pontaj_page.dart';
import 'all_entries_page.dart';
import 'dashboard_page.dart';
import 'salary_page.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<TimeEntryBloc>().add(const LoadEntries(isAdmin: true));
  }

  Future<void> _showLogoutConfirmation(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.logoutConfirmation),
        content: Text(l10n.logoutConfirmationMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: Text(l10n.logout),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      context.read<AuthBloc>().add(const AuthLogoutRequested());
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authState = context.watch<AuthBloc>().state;
    final adminName = authState is AuthAuthenticated
        ? authState.user.displayNameOrEmail
        : l10n.administrator;

    final destinations = [
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
        icon: Icons.add_circle_outline,
        selectedIcon: Icons.add_circle,
        label: l10n.addEntry,
      ),
    ];

    final pages = [
      const DashboardPage(embedded: true),
      const AllEntriesPage(embedded: true),
      const SalaryPage(embedded: true),
      PontajPage(userName: adminName, lockName: true, embedded: true),
    ];

    if (context.isMobile) {
      return Scaffold(
        appBar: _buildAppBar(l10n),
        body: IndexedStack(
          index: _selectedIndex,
          children: pages,
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) {
            setState(() => _selectedIndex = index);
          },
          destinations: destinations
              .map((d) => NavigationDestination(
                    icon: Icon(d.icon),
                    selectedIcon: Icon(d.selectedIcon),
                    label: d.label,
                  ))
              .toList(),
        ),
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
            leading: context.isDesktop
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: _AppLogo(),
                  )
                : const SizedBox(height: 16),
            destinations: destinations
                .map((d) => NavigationRailDestination(
                      icon: Icon(d.icon),
                      selectedIcon: Icon(d.selectedIcon),
                      label: Text(d.label),
                    ))
                .toList(),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: pages,
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(AppLocalizations l10n) {
    return AppBar(
      title: Text(l10n.pontajAdmin),
      centerTitle: true,
      actions: [
        IconButton(
          tooltip: l10n.settings,
          icon: const Icon(Icons.settings),
          onPressed: () => context.push('/settings'),
        ),
        IconButton(
          tooltip: l10n.logout,
          icon: const Icon(Icons.logout),
          onPressed: () => _showLogoutConfirmation(context),
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
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}
