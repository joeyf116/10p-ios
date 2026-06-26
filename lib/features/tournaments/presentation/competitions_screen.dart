import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/di/service_locator.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../domain/repositories/tournament_repository.dart';
import 'providers/competition_provider.dart';

class CompetitionsScreen extends ConsumerWidget {
  const CompetitionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final competitionsAsync = ref.watch(competitionsProvider);
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Competitions')),
      body: competitionsAsync.when(
        data: (competitions) {
          if (competitions.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.emoji_events_outlined, size: 64, color: Colors.grey),
                  const SizedBox(height: 12),
                  Text('No upcoming competitions.', style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: competitions.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (ctx, i) {
              final comp = competitions[i];
              final isCompeting = user != null && comp.isCompeting(user.uid);
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text(comp.name, style: Theme.of(context).textTheme.titleMedium)),
                          if (isCompeting)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: AppTheme.brandRed.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                              child: Text('Competing', style: TextStyle(color: AppTheme.brandRed, fontSize: 11, fontWeight: FontWeight.w700)),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _InfoRow(icon: Icons.calendar_today, text: DateFormat('EEEE, MMMM d, y').format(comp.date)),
                      _InfoRow(icon: Icons.location_on_outlined, text: comp.location),
                      if (comp.registrationDeadline != null)
                        _InfoRow(
                          icon: Icons.timer_outlined,
                          text: 'Register by ${DateFormat('MMM d').format(comp.registrationDeadline!)}',
                          color: comp.registrationDeadline!.isBefore(DateTime.now().add(const Duration(days: 7)))
                              ? Colors.orange
                              : null,
                        ),
                      if (comp.competitorUids.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        _InfoRow(icon: Icons.group_outlined, text: '${comp.competitorUids.length} team member${comp.competitorUids.length == 1 ? '' : 's'} competing'),
                      ],
                      if (comp.notes != null) ...[
                        const SizedBox(height: 8),
                        Text(comp.notes!, style: Theme.of(context).textTheme.bodySmall),
                      ],
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          if (user != null)
                            OutlinedButton.icon(
                              onPressed: () async {
                                await serviceLocator<TournamentRepository>().toggleCompeting(
                                  competitionId: comp.id,
                                  memberId: user.uid,
                                  isCompeting: !isCompeting,
                                );
                              },
                              icon: Icon(isCompeting ? Icons.remove_circle_outline : Icons.add_circle_outline),
                              label: Text(isCompeting ? "I'm not competing" : "I'm competing"),
                            ),
                          if (comp.registrationUrl != null) ...[
                            const SizedBox(width: 8),
                            FilledButton.icon(
                              onPressed: () => launchUrl(Uri.parse(comp.registrationUrl!)),
                              icon: const Icon(Icons.open_in_new, size: 16),
                              label: const Text('Register'),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
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

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text, this.color});
  final IconData icon;
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 14, color: color ?? Theme.of(context).textTheme.bodySmall?.color),
          const SizedBox(width: 6),
          Text(text, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: color)),
        ],
      ),
    );
  }
}
