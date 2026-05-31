abstract class TechniqueLibraryRepository {
  Future<void> cacheForOffline({required String videoId});
  Future<void> removeOfflineCopy({required String videoId});
}
