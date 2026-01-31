import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/responsive/responsive.dart';
import '../../../core/theme/theme_cubit.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/gradient_background.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_event.dart';
import '../../auth/bloc/auth_state.dart';
import '../widgets/admin_upgrade_card.dart';

class SettingsPage extends StatelessWidget {
  final bool embedded;

  const SettingsPage({super.key, this.embedded = false});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final authState = context.watch<AuthBloc>().state;
    final user = authState is AuthAuthenticated ? authState.user : null;

    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        return Scaffold(
          appBar: embedded
              ? null
              : AppBar(title: Text(l10n.settings), centerTitle: true),
          body: GradientBackground(
            animated: false,
            child: SingleChildScrollView(
              padding: ResponsiveSpacing.pagePadding(context),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: Column(
                    crossAxisAlignment: .stretch,
                    children: [
                      GlassCard(
                        padding: const .all(20),
                        enableBlur: false,
                        child: Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
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
                                    color: Theme.of(context).colorScheme.primary
                                        .withValues(alpha: 0.3),
                                    blurRadius: 15,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Text(
                                  'JR',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: .w900,
                                    color: Colors.white,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: .start,
                                children: [
                                  ShaderMask(
                                    shaderCallback: (bounds) => LinearGradient(
                                      colors: [
                                        Theme.of(context).colorScheme.primary,
                                        Theme.of(context).colorScheme.secondary,
                                      ],
                                    ).createShader(bounds),
                                    child: Text(
                                      l10n.appTitle.toUpperCase(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            fontWeight: .bold,
                                            color: Colors.white,
                                          ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    l10n.appSubtitle,
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      _SectionHeader(title: l10n.appearance),
                      _ThemeModeSelector(themeState: themeState, l10n: l10n),
                      const SizedBox(height: 12),
                      _ColorSelector(themeState: themeState, l10n: l10n),
                      const SizedBox(height: 12),
                      _LanguageSelector(themeState: themeState, l10n: l10n),
                      if (user != null) ...[
                        const SizedBox(height: 32),
                        _SectionHeader(title: l10n.account),
                        AdminUpgradeCard(user: user),
                      ],
                      const SizedBox(height: 32),
                      _SectionHeader(title: l10n.information),
                      GlassCard(
                        padding: .zero,
                        enableBlur: false,
                        child: Column(
                          children: [
                            ListTile(
                              leading: Container(
                                padding: const .all(8),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withValues(alpha: 0.1),
                                  borderRadius: .circular(8),
                                ),
                                child: const Icon(
                                  Icons.info_outline,
                                  color: Colors.blue,
                                ),
                              ),
                              title: Text(
                                l10n.version,
                                style: const TextStyle(fontWeight: .w600),
                              ),
                              subtitle: Text('1.0.0 • ${l10n.appSubtitle}'),
                              trailing: Container(
                                padding: const .symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Theme.of(context).colorScheme.primary,
                                      Theme.of(context).colorScheme.secondary,
                                    ],
                                  ),
                                  borderRadius: .circular(12),
                                ),
                                child: const Text(
                                  'PRO',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: .bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                            const Divider(height: 1),
                            ListTile(
                              leading: Container(
                                padding: const .all(8),
                                decoration: BoxDecoration(
                                  color: Colors.purple.withValues(alpha: 0.1),
                                  borderRadius: .circular(8),
                                ),
                                child: const Icon(
                                  Icons.code,
                                  color: Colors.purple,
                                ),
                              ),
                              title: Text(
                                l10n.developedBy,
                                style: const TextStyle(fontWeight: .w600),
                              ),
                              subtitle: const Text('Claude Code x JR Team'),
                            ),
                            const Divider(height: 1),
                            ListTile(
                              leading: Container(
                                padding: const .all(8),
                                decoration: BoxDecoration(
                                  color: Colors.green.withValues(alpha: 0.1),
                                  borderRadius: .circular(8),
                                ),
                                child: const Icon(
                                  Icons.verified,
                                  color: Colors.green,
                                ),
                              ),
                              title: Text(
                                l10n.status,
                                style: const TextStyle(fontWeight: .w600),
                              ),
                              subtitle: Text(l10n.allSystemsOperational),
                              trailing: const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      _LogoutSection(l10n: l10n),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _LogoutSection extends StatelessWidget {
  final AppLocalizations l10n;

  const _LogoutSection({required this.l10n});

  Future<void> _showLogoutConfirmation(BuildContext context) async {
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
            style: TextButton.styleFrom(foregroundColor: Colors.red),
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
    return GlassCard(
      padding: .zero,
      enableBlur: false,
      child: ListTile(
        leading: Container(
          padding: const .all(8),
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: 0.1),
            borderRadius: .circular(8),
          ),
          child: const Icon(Icons.logout, color: Colors.red),
        ),
        title: Text(
          l10n.logout,
          style: const TextStyle(fontWeight: .w600, color: Colors.red),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.red),
        onTap: () => _showLogoutConfirmation(context),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: .bold,
        ),
      ),
    );
  }
}

class _ThemeModeSelector extends StatelessWidget {
  final ThemeState themeState;
  final AppLocalizations l10n;

  const _ThemeModeSelector({required this.themeState, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const .all(20),
      enableBlur: false,
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            children: [
              Container(
                padding: const .all(8),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: .circular(8),
                ),
                child: Icon(
                  Icons.brightness_6,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                l10n.darkMode,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: .bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SegmentedButton<AppThemeMode>(
            segments: [
              ButtonSegment(
                value: .light,
                icon: const Icon(Icons.light_mode, size: 20),
                label: Text(l10n.light),
              ),
              ButtonSegment(
                value: .dark,
                icon: const Icon(Icons.dark_mode, size: 20),
                label: Text(l10n.dark),
              ),
              ButtonSegment(
                value: .system,
                icon: const Icon(Icons.settings_suggest, size: 20),
                label: Text(l10n.auto),
              ),
            ],
            selected: {themeState.themeMode},
            onSelectionChanged: (Set<AppThemeMode> selection) {
              context.read<ThemeCubit>().setThemeMode(selection.first);
            },
          ),
        ],
      ),
    );
  }
}

class _ColorSelector extends StatelessWidget {
  final ThemeState themeState;
  final AppLocalizations l10n;

  const _ColorSelector({required this.themeState, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const .all(20),
      enableBlur: false,
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            children: [
              Container(
                padding: const .all(8),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: .circular(8),
                ),
                child: Icon(
                  Icons.palette,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                l10n.accentColor,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: .bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: AppColors.allColors.map((color) {
              final isSelected = color == themeState.accentColor;
              return GestureDetector(
                onTap: () => context.read<ThemeCubit>().setAccentColor(color),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? Colors.white : Colors.transparent,
                      width: 3,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: color.withValues(alpha: 0.6),
                              blurRadius: 16,
                              spreadRadius: 4,
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: color.withValues(alpha: 0.2),
                              blurRadius: 4,
                              spreadRadius: 1,
                            ),
                          ],
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, color: Colors.white, size: 32)
                      : null,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const .all(12),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.surface.withValues(alpha: 0.3),
              borderRadius: .circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: themeState.accentColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${l10n.current}: ${AppColors.getColorName(themeState.accentColor)}',
                  style: const TextStyle(fontWeight: .w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageSelector extends StatelessWidget {
  final ThemeState themeState;
  final AppLocalizations l10n;

  const _LanguageSelector({required this.themeState, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final currentLocale = themeState.locale.languageCode;

    return GlassCard(
      padding: const .all(20),
      enableBlur: false,
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            children: [
              Container(
                padding: const .all(8),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: .circular(8),
                ),
                child: Icon(
                  Icons.language,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                l10n.language,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: .bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SegmentedButton<String>(
            segments: [
              ButtonSegment(value: 'ro', label: Text(l10n.romanian)),
              ButtonSegment(value: 'en', label: Text(l10n.english)),
              ButtonSegment(value: 'it', label: Text(l10n.italian)),
            ],
            selected: {currentLocale},
            onSelectionChanged: (Set<String> selection) {
              context.read<ThemeCubit>().setLocale(Locale(selection.first));
            },
          ),
        ],
      ),
    );
  }
}
