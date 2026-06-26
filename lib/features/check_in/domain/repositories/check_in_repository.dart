import '../../data/models/check_in_record.dart';

abstract class CheckInRepository {
  Future<void> checkIn({
    required String memberId,
    required double latitude,
    required double longitude,
    String? classId,
  });

  Stream<List<CheckInRecord>> watchMemberCheckIns(String memberId);
}
