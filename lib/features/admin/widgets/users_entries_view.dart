import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/responsive/responsive.dart';
import '../../../data/models/time_entry.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/staggered_animation.dart';
import 'user_avatar.dart';

class UsersEntriesView extends StatelessWidget {
  final List<MapEntry<String, List<TimeEntry>>> groupedEntries;
  final AppLocalizations l10n;

  const UsersEntriesView({
    super.key,
    required this.groupedEntries,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    if (groupedEntries.isEmpty) {
      return Center(
        child: GlassCard(
          padding: const EdgeInsets.all(40),
          enableBlur: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                l10n.noPontaj,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    final userCards = groupedEntries.asMap().entries.map((mapEntry) {
      final index = mapEntry.key;
      final entry = mapEntry.value;
      final user = entry.key;
      final list = entry.value;
      final total = list.fold<Duration>(
        Duration.zero,
        (s, e) => s + e.totalWorked,
      );
      return StaggeredAnimationItem(
        delay: Duration(milliseconds: 50 * index),
        duration: const Duration(milliseconds: 400),
        child: _UserCard(
          user: user,
          entryCount: list.length,
          totalDuration: total,
          l10n: l10n,
        ),
      );
    }).toList();

    return SingleChildScrollView(
      padding: ResponsiveSpacing.pagePadding(context),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: ResponsiveLayout(
            mobile: Column(children: userCards),
            tablet: ResponsiveGrid(
              mobileColumns: 1,
              tabletColumns: 2,
              desktopColumns: 2,
              spacing: 12,
              runSpacing: 0,
              children: userCards,
            ),
          ),
        ),
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  final String user;
  final int entryCount;
  final Duration totalDuration;
  final AppLocalizations l10n;

  const _UserCard({
    required this.user,
    required this.entryCount,
    required this.totalDuration,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GlassCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      enableBlur: false,
      child: InkWell(
        onTap: () => context.push('/userEntries', extra: {'user': user}),
        borderRadius: BorderRadius.circular(16),
        child: Row(
          children: [
            UserAvatar(name: user),
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
                        l10n.nDays(entryCount),
                        style:
                            TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                      const SizedBox(width: 12),
                      Icon(Icons.access_time,
                          size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        TimeEntry.formatDuration(totalDuration),
                        style:
                            TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.chevron_right,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
