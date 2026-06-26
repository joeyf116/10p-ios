import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/di/service_locator.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../data/models/schedule_class.dart';
import '../domain/repositories/schedule_repository.dart';
import 'providers/schedule_provider.dart';

class ScheduleScreen extends ConsumerWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheduleAsync = ref.watch(scheduleProvider);
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Schedule')),
      body: scheduleAsync.when(
        data: (classes) {
          if (classes.isEmpty) return const Center(child: Text('No upcoming classes.'));
          final grouped = <String, List<ScheduleClass>>{};
          for (final c in classes) {
            final key = DateFormat('EEEE, MMMM d').format(c.startTime);
            grouped.putIfAbsent(key, () => []).add(c);
          }
          final dates = grouped.keys.toList();
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: dates.length,
            itemBuilder: (ctx, i) {
              final date = dates[i];
              final dayClasses = grouped[date]!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (i > 0) const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(date, style: Theme.of(context).textTheme.titleSmall),
                  ),
                  ...dayClasses.map((c) => _ClassCard(
                    cls: c,
                    isAttending: user != null && c.attendees.contains(user.uid),
                    userId: user?.uid,
                  )),
                ],
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.brandRed)),
        error: (e, _) => Center(child: Text('$e')),
      ),
    );
  }
}

class _ClassCard extends ConsumerStatefulWidget {
  const _ClassCard({required this.cls, required this.isAttending, this.userId});
  final ScheduleClass cls;
  final bool isAttending;
  final String? userId;

  @override
  ConsumerState<_ClassCard> createState() => _ClassCardState();
}

class _ClassCardState extends ConsumerState<_ClassCard> {
  bool _loading = false;

  Future<void> _reserve() async {
    if (widget.userId == null) return;
    setState(() => _loading = true);
    try {
      await serviceLocator<ScheduleRepository>().reserveSpot(
        classId: widget.cls.classId,
        userId: widget.userId!,
      );
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cls = widget.cls;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            SizedBox(
              width: 52,
              child: Column(
                children: [
                  Text(DateFormat('h:mm').format(cls.startTime), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                  Text(DateFormat('a').format(cls.startTime), style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            const SizedBox(width: 4),
            Container(width: 2, height: 44, color: AppTheme.brandRed),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(cls.title, style: Theme.of(context).textTheme.titleMedium),
                  Text('${cls.coachDisplayName} · ${cls.durationMinutes} min', style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (widget.isAttending)
              const Icon(Icons.check_circle, color: Colors.green, size: 20)
            else if (cls.isFull)
              Text('Full', style: Theme.of(context).textTheme.bodySmall)
            else
              TextButton(
                onPressed: _loading ? null : _reserve,
                child: _loading
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                    : Text('${cls.slotsRemaining} left', style: TextStyle(color: AppTheme.brandRed)),
              ),
          ],
        ),
      ),
    );
  }
}
