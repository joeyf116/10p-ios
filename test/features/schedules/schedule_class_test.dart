import 'package:flutter_test/flutter_test.dart';
import 'package:tenp_member_ecosystem/features/schedules/data/models/schedule_class.dart';

void main() {
  test('computes remaining slots from capacity and attendees', () {
    final schedule = ScheduleClass(
      classId: 'class_1',
      title: 'Advanced Rubber Guard',
      coachName: 'Eddie Bravo',
      startTime: DateTime.parse('2026-05-31T09:00:00.000Z'),
      capacityLimit: 30,
      attendees: List<String>.filled(7, 'u'),
    );

    expect(schedule.slotsRemaining, 23);
  });
}
