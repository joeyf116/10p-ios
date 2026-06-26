import 'package:flutter_test/flutter_test.dart';
import 'package:tenp_member_ecosystem/features/schedules/data/models/schedule_class.dart';

void main() {
  test('computes remaining slots from capacity and attendees', () {
    final schedule = ScheduleClass(
      classId: 'class_1',
      title: 'Advanced Rubber Guard',
      coachUid: 'coach_uid_1',
      coachDisplayName: 'Eddie Bravo',
      startTime: DateTime.parse('2026-05-31T09:00:00.000Z'),
      durationMinutes: 60,
      capacityLimit: 30,
      attendees: List<String>.filled(7, 'u'),
    );

    expect(schedule.slotsRemaining, 23);
    expect(schedule.isFull, false);
  });

  test('isOpen when coachUid is empty', () {
    final schedule = ScheduleClass(
      classId: 'class_2',
      title: 'Open Mat',
      coachUid: '',
      coachDisplayName: 'Open',
      startTime: DateTime.now(),
      durationMinutes: 90,
      capacityLimit: 20,
      attendees: [],
    );

    expect(schedule.isOpen, true);
  });
}
