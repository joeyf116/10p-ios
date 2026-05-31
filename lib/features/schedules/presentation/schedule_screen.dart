import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../core/di/service_locator.dart';
import '../data/models/schedule_class.dart';
import '../domain/repositories/schedule_repository.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = serviceLocator<ScheduleRepository>();

    return Scaffold(
      appBar: AppBar(title: const Text('Class Scheduling')),
      body: StreamBuilder<List<ScheduleClass>>(
        stream: repository.watchSchedule(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Text('Failed to load schedule: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final classes = snapshot.data!;
          if (classes.isEmpty) {
            return const Center(
              child: Text(
                  'No classes found. Add documents to the schedules collection.'),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) => _ClassTile(
              scheduleClass: classes[index],
              repository: repository,
            ),
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemCount: classes.length,
          );
        },
      ),
    );
  }
}

class _ClassTile extends StatefulWidget {
  const _ClassTile({required this.scheduleClass, required this.repository});

  final ScheduleClass scheduleClass;
  final ScheduleRepository repository;

  @override
  State<_ClassTile> createState() => _ClassTileState();
}

class _ClassTileState extends State<_ClassTile> {
  bool _reserving = false;

  @override
  Widget build(BuildContext context) {
    final classData = widget.scheduleClass;
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final canReserve = userId != null && classData.slotsRemaining > 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(classData.title,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text('Coach: ${classData.coachName}'),
            Text('Start: ${classData.startTime.toLocal()}'),
            Text('Slots remaining: ${classData.slotsRemaining}'),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _reserving || !canReserve
                  ? null
                  : () => _reserveSpot(userId, context),
              child: Text(_reserving ? 'Reserving...' : 'Reserve Spot'),
            ),
            if (userId == null)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text('Sign in to reserve classes.'),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _reserveSpot(String userId, BuildContext context) async {
    setState(() => _reserving = true);
    try {
      await widget.repository
          .reserveSpot(classId: widget.scheduleClass.classId, userId: userId);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reservation complete.')),
      );
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not reserve spot: $error')),
      );
    } finally {
      if (mounted) {
        setState(() => _reserving = false);
      }
    }
  }
}
