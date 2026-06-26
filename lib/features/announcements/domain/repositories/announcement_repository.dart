import '../../data/models/announcement.dart';

abstract class AnnouncementRepository {
  Stream<List<Announcement>> watchAnnouncements();

  Future<void> publish({
    required String title,
    required String body,
    required String authorUid,
    required String authorDisplayName,
    AnnouncementAudience targetAudience = AnnouncementAudience.all,
  });

  Future<void> markRead({required String announcementId, required String memberId});

  Stream<Set<String>> watchReadIds(String memberId);
}
