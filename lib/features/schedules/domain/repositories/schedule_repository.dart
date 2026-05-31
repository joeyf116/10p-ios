import '../../data/models/schedule_class.dart';

abstract class ScheduleRepository {
  Stream<List<ScheduleClass>> watchSchedule();
  Future<void> reserveSpot({required String classId, required String userId});
}
