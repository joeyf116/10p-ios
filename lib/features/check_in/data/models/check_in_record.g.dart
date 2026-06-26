// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_in_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckInRecord _$CheckInRecordFromJson(Map<String, dynamic> json) =>
    CheckInRecord(
      id: json['id'] as String,
      memberId: json['member_id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      classId: json['class_id'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$CheckInRecordToJson(CheckInRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'member_id': instance.memberId,
      'timestamp': instance.timestamp.toIso8601String(),
      'class_id': instance.classId,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
