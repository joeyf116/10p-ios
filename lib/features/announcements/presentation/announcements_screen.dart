import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/di/service_locator.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../data/models/announcement.dart';
import '../domain/repositories/announcement_repository.dart';
import 'providers/announcements_provider.dart';

class AnnouncementsScreen extends ConsumerWidget {
  const AnnouncementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final announcementsAsync = ref.watch(announcementsProvider);
    final readIds = ref.watch(readAnnouncementIdsProvider).valueOrNull ?? {};
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Announcements'),
        actions: [
          if (user?.isCoachOrOwner ?? false)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _showPostDialog(context, ref, user!),
            ),
        ],
      ),
      body: announcementsAsync.when(
        data: (list) {
          if (list.isEmpty) {
            return const Center(child: Text('No announcements yet.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (ctx, i) {
              final a = list[i];
              final isUnread = !readIds.contains(a.id);
              return _AnnouncementCard(
                announcement: a,
                isUnread: isUnread,
                onTap: () {
                  if (isUnread && user != null) {
                    serviceLocator<AnnouncementRepository>().markRead(
                      announcementId: a.id,
                      memberId: user.uid,
                    );
                  }
                  _showDetail(context, a);
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.brandRed)),
        error: (e, _) => Center(child: Text('$e')),
      ),
    );
  }

  void _showDetail(BuildContext context, Announcement a) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.95,
        minChildSize: 0.4,
        expand: false,
        builder: (_, ctrl) => ListView(
          controller: ctrl,
          padding: const EdgeInsets.all(24),
          children: [
            Text(a.title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            Text('${a.authorDisplayName} · ${DateFormat('MMM d, yyyy').format(a.postedAt)}', style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 16),
            Text(a.body),
          ],
        ),
      ),
    );
  }

  void _showPostDialog(BuildContext context, WidgetRef ref, dynamic user) {
    final titleCtrl = TextEditingController();
    final bodyCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Post Announcement'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Title')),
            const SizedBox(height: 12),
            TextField(controller: bodyCtrl, decoration: const InputDecoration(labelText: 'Body'), maxLines: 4),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () async {
              if (titleCtrl.text.trim().isEmpty) return;
              await serviceLocator<AnnouncementRepository>().publish(
                title: titleCtrl.text.trim(),
                body: bodyCtrl.text.trim(),
                authorUid: user.uid as String,
                authorDisplayName: user.displayName as String,
              );
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Post'),
          ),
        ],
      ),
    );
  }
}

class _AnnouncementCard extends StatelessWidget {
  const _AnnouncementCard({required this.announcement, required this.isUnread, required this.onTap});
  final Announcement announcement;
  final bool isUnread;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isUnread)
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(top: 6, right: 10),
                  decoration: const BoxDecoration(color: AppTheme.brandRed, shape: BoxShape.circle),
                )
              else
                const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(announcement.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: isUnread ? FontWeight.w700 : FontWeight.w500)),
                    const SizedBox(height: 4),
                    Text(announcement.body, maxLines: 2, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(DateFormat('MMM d').format(announcement.postedAt), style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}
