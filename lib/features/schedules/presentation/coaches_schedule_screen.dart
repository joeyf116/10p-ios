import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/di/service_locator.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../data/models/schedule_class.dart';
import '../domain/repositories/schedule_repository.dart';
import 'providers/schedule_provider.dart';

class CoachesScheduleScreen extends ConsumerWidget {
  const CoachesScheduleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheduleAsync = ref.watch(scheduleProvider);
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Coaches Schedule')),
      body: scheduleAsync.when(
        data: (classes) {
          if (classes.isEmpty) {
            return const Center(child: Text('No upcoming class slots.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: classes.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (ctx, i) => _CoachSlotCard(cls: classes[i], currentUid: user?.uid ?? ''),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.brandRed)),
        error: (e, _) => Center(child: Text('$e')),
      ),
    );
  }
}

class _CoachSlotCard extends ConsumerStatefulWidget {
  const _CoachSlotCard({required this.cls, required this.currentUid});
  final ScheduleClass cls;
  final String currentUid;

  @override
  ConsumerState<_CoachSlotCard> createState() => _CoachSlotCardState();
}

class _CoachSlotCardState extends ConsumerState<_CoachSlotCard> {
  bool _loading = false;

  Future<void> _claim() async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;
    setState(() => _loading = true);
    try {
      await serviceLocator<ScheduleRepository>().claimCoachSlot(
        classId: widget.cls.classId,
        coachUid: user.uid,
        coachDisplayName: user.displayName,
      );
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _unclaim() async {
    setState(() => _loading = true);
    try {
      await serviceLocator<ScheduleRepository>().unclaimCoachSlot(widget.cls.classId);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cls = widget.cls;
    final isMe = cls.coachUid == widget.currentUid;
    final isOpen = cls.isOpen;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(cls.title, style: Theme.of(context).textTheme.titleMedium),
                      Text(
                        DateFormat('EEE, MMM d · h:mm a').format(cls.startTime),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                if (isOpen)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('Open', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.w600, fontSize: 12)),
                  )
                else if (isMe)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.brandRed.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('You', style: TextStyle(color: AppTheme.brandRed, fontWeight: FontWeight.w600, fontSize: 12)),
                  )
                else
                  Text(cls.coachDisplayName, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
            if (isOpen || isMe) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (isOpen)
                    FilledButton(
                      onPressed: _loading ? null : _claim,
                      child: _loading
                          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Text("I'm teaching this"),
                    ),
                  if (isMe) ...[
                    OutlinedButton(
                      onPressed: _loading ? null : _unclaim,
                      child: const Text('Remove myself'),
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
