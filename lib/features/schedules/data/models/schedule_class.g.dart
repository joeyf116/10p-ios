// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_class.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduleClass _$ScheduleClassFromJson(Map<String, dynamic> json) =>
    ScheduleClass(
      classId: json['class_id'] as String,
      title: json['title'] as String,
      coachUid: json['coach_uid'] as String,
      coachDisplayName: json['coach_display_name'] as String,
      startTime: DateTime.parse(json['start_time'] as String),
      durationMinutes: (json['duration_minutes'] as num).toInt(),
      capacityLimit: (json['capacity_limit'] as num).toInt(),
      attendees:
          (json['attendees'] as List<dynamic>).map((e) => e as String).toList(),
      isRecurring: json['is_recurring'] as bool? ?? false,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$ScheduleClassToJson(ScheduleClass instance) =>
    <String, dynamic>{
      'class_id': instance.classId,
      'title': instance.title,
      'coach_uid': instance.coachUid,
      'coach_display_name': instance.coachDisplayName,
      'start_time': instance.startTime.toIso8601String(),
      'duration_minutes': instance.durationMinutes,
      'capacity_limit': instance.capacityLimit,
      'attendees': instance.attendees,
      'is_recurring': instance.isRecurring,
      'notes': instance.notes,
    };
