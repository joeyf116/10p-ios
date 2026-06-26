import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../data/models/announcement.dart';
import '../../domain/repositories/announcement_repository.dart';

final announcementRepositoryProvider = Provider<AnnouncementRepository>(
  (ref) => serviceLocator<AnnouncementRepository>(),
);

final announcementsProvider = StreamProvider<List<Announcement>>(
  (ref) => ref.watch(announcementRepositoryProvider).watchAnnouncements(),
);

final readAnnouncementIdsProvider = StreamProvider<Set<String>>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return const Stream.empty();
  return ref.watch(announcementRepositoryProvider).watchReadIds(user.uid);
});

final unreadCountProvider = Provider<int>((ref) {
  final announcements = ref.watch(announcementsProvider).valueOrNull ?? [];
  final readIds = ref.watch(readAnnouncementIdsProvider).valueOrNull ?? {};
  return announcements.where((a) => !readIds.contains(a.id)).length;
});
