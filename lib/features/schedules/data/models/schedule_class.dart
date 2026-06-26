import 'package:json_annotation/json_annotation.dart';

import '../../../../core/models/serializable_model.dart';

part 'schedule_class.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ScheduleClass extends SerializableModel {
  ScheduleClass({
    required this.classId,
    required this.title,
    required this.coachUid,
    required this.coachDisplayName,
    required this.startTime,
    required this.durationMinutes,
    required this.capacityLimit,
    required this.attendees,
    this.isRecurring = false,
    this.notes,
  });

  factory ScheduleClass.fromJson(Map<String, dynamic> json) =>
      _$ScheduleClassFromJson(json);

  final String classId;
  final String title;
  final String coachUid;
  final String coachDisplayName;
  final DateTime startTime;
  final int durationMinutes;
  final int capacityLimit;
  final List<String> attendees;
  final bool isRecurring;
  final String? notes;

  DateTime get endTime => startTime.add(Duration(minutes: durationMinutes));
  int get slotsRemaining => capacityLimit - attendees.length;
  bool get isFull => slotsRemaining <= 0;
  bool get isOpen => coachUid.isEmpty;

  @override
  Map<String, dynamic> toJson() => _$ScheduleClassToJson(this);
}
