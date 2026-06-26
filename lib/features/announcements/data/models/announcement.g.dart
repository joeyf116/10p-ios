// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Announcement _$AnnouncementFromJson(Map<String, dynamic> json) => Announcement(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      authorUid: json['author_uid'] as String,
      authorDisplayName: json['author_display_name'] as String,
      postedAt: DateTime.parse(json['posted_at'] as String),
      targetAudience: $enumDecodeNullable(
              _$AnnouncementAudienceEnumMap, json['target_audience']) ??
          AnnouncementAudience.all,
    );

Map<String, dynamic> _$AnnouncementToJson(Announcement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'author_uid': instance.authorUid,
      'author_display_name': instance.authorDisplayName,
      'posted_at': instance.postedAt.toIso8601String(),
      'target_audience':
          _$AnnouncementAudienceEnumMap[instance.targetAudience]!,
    };

const _$AnnouncementAudienceEnumMap = {
  AnnouncementAudience.all: 'all',
  AnnouncementAudience.members: 'members',
  AnnouncementAudience.coaches: 'coaches',
};
