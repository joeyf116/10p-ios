// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_class.dart';

ScheduleClass _$ScheduleClassFromJson(Map<String, dynamic> json) => ScheduleClass(
  classId: json['class_id'] as String,
  title: json['title'] as String,
  coachName: json['coach_name'] as String,
  startTime: DateTime.parse(json['start_time'] as String),
  capacityLimit: (json['capacity_limit'] as num).toInt(),
  attendees: (json['attendees'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$ScheduleClassToJson(ScheduleClass instance) => <String, dynamic>{
  'class_id': instance.classId,
  'title': instance.title,
  'coach_name': instance.coachName,
  'start_time': instance.startTime.toIso8601String(),
  'capacity_limit': instance.capacityLimit,
  'attendees': instance.attendees,
};
