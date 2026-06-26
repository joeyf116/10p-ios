import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/providers/auth_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../announcements/presentation/providers/announcements_provider.dart';
import '../../auth/data/models/app_user.dart';
import '../../schedules/presentation/providers/schedule_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final scheduleAsync = ref.watch(scheduleProvider);
    final announcementsAsync = ref.watch(announcementsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('10P', style: TextStyle(color: AppTheme.brandRed, fontWeight: FontWeight.w900, fontSize: 22)),
            const Text(' GREENVILLE'),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.person_outline), onPressed: () {}),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (user != null) ...[
            Text('Welcome back,', style: Theme.of(context).textTheme.bodyMedium),
            Text(user.displayName, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 6),
            Row(
              children: [
                _BeltChip(rank: user.beltRank),
                const SizedBox(width: 8),
                Chip(
                  label: Text(user.role.name.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white)),
                  backgroundColor: Colors.grey[800],
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
          _CheckInCard(),
          const SizedBox(height: 20),
          Text('Next Class', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          scheduleAsync.when(
            data: (classes) {
              if (classes.isEmpty) return const _EmptyCard('No upcoming classes scheduled.');
              final next = classes.first;
              return Card(
                child: ListTile(
                  title: Text(next.title),
                  subtitle: Text('${DateFormat('EEE, MMM d · h:mm a').format(next.startTime)} · ${next.coachDisplayName}'),
                  trailing: Text(
                    next.isFull ? 'Full' : '${next.slotsRemaining} spots',
                    style: TextStyle(
                      color: next.isFull ? Colors.red : Colors.green,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                  onTap: () => context.go('/schedule'),
                ),
              );
            },
            loading: () => const LinearProgressIndicator(color: AppTheme.brandRed),
            error: (_, __) => const _EmptyCard('Could not load schedule.'),
          ),
          const SizedBox(height: 20),
          Text('Latest News', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          announcementsAsync.when(
            data: (list) {
              if (list.isEmpty) return const _EmptyCard('No announcements yet.');
              final a = list.first;
              return Card(
                child: ListTile(
                  title: Text(a.title),
                  subtitle: Text(a.body, maxLines: 2, overflow: TextOverflow.ellipsis),
                  trailing: Text(DateFormat('MMM d').format(a.postedAt), style: Theme.of(context).textTheme.bodySmall),
                  onTap: () => context.go('/announcements'),
                ),
              );
            },
            loading: () => const LinearProgressIndicator(color: AppTheme.brandRed),
            error: (_, __) => const _EmptyCard('Could not load announcements.'),
          ),
        ],
      ),
    );
  }
}

class _CheckInCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.brandRed,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.go('/check-in'),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              const Icon(Icons.qr_code_scanner, color: Colors.white, size: 36),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Check In', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white)),
                    const Text('Record your attendance', style: TextStyle(color: Colors.white70, fontSize: 13)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _BeltChip extends StatelessWidget {
  const _BeltChip({required this.rank});
  final BeltRank rank;

  @override
  Widget build(BuildContext context) {
    final colors = {
      BeltRank.white: Colors.grey[300]!,
      BeltRank.blue: Colors.blue,
      BeltRank.purple: Colors.purple,
      BeltRank.brown: Colors.brown,
      BeltRank.black: Colors.black,
    };
    return Chip(
      label: Text(rank.name.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white)),
      backgroundColor: colors[rank] ?? Colors.grey,
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
    );
  }
}

class _EmptyCard extends StatelessWidget {
  const _EmptyCard(this.message);
  final String message;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(message, style: Theme.of(context).textTheme.bodySmall),
      ),
    );
  }
}
