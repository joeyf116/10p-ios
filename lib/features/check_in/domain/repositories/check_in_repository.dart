abstract class CheckInRepository {
  Stream<String> rotatingQrPayload();
  Future<void> checkIn({required String userId});
}
