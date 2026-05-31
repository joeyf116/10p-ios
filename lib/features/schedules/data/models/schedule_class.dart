import 'package:json_annotation/json_annotation.dart';

import '../../../../core/models/serializable_model.dart';

part 'schedule_class.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ScheduleClass extends SerializableModel {
  ScheduleClass({
    required this.classId,
    required this.title,
    required this.coachName,
    required this.startTime,
    required this.capacityLimit,
    required this.attendees,
  });

  factory ScheduleClass.fromJson(Map<String, dynamic> json) => _$ScheduleClassFromJson(json);

  final String classId;
  final String title;
  final String coachName;
  final DateTime startTime;
  final int capacityLimit;
  final List<String> attendees;

  int get slotsRemaining => capacityLimit - attendees.length;

  @override
  Map<String, dynamic> toJson() => _$ScheduleClassToJson(this);
}
