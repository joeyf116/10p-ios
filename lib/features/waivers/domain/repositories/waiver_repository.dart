abstract class WaiverRepository {
  Future<bool> hasSignedWaiver(String memberId);
  Future<void> signWaiver({required String memberId});
}
