abstract class AnnouncementRepository {
  Future<void> publish({required String title, required String body});
}
