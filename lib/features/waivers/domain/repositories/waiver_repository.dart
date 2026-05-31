abstract class WaiverRepository {
  Future<String> uploadSignedWaiver({required String userId, required List<int> pngBytes});
  Future<bool> hasValidWaiver(String userId);
}
