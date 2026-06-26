// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'technique.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Technique _$TechniqueFromJson(Map<String, dynamic> json) => Technique(
      id: json['id'] as String,
      system: json['system'] as String,
      position: json['position'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      videoUrl: json['video_url'] as String?,
      thumbnailUrl: json['thumbnail_url'] as String?,
      beltLevel: $enumDecodeNullable(_$BeltRankEnumMap, json['belt_level']) ??
          BeltRank.white,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
    );

Map<String, dynamic> _$TechniqueToJson(Technique instance) => <String, dynamic>{
      'id': instance.id,
      'system': instance.system,
      'position': instance.position,
      'title': instance.title,
      'description': instance.description,
      'video_url': instance.videoUrl,
      'thumbnail_url': instance.thumbnailUrl,
      'belt_level': _$BeltRankEnumMap[instance.beltLevel]!,
      'tags': instance.tags,
    };

const _$BeltRankEnumMap = {
  BeltRank.white: 'white',
  BeltRank.blue: 'blue',
  BeltRank.purple: 'purple',
  BeltRank.brown: 'brown',
  BeltRank.black: 'black',
};
