// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'competition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Competition _$CompetitionFromJson(Map<String, dynamic> json) => Competition(
      id: json['id'] as String,
      name: json['name'] as String,
      date: DateTime.parse(json['date'] as String),
      location: json['location'] as String,
      registrationDeadline: json['registration_deadline'] == null
          ? null
          : DateTime.parse(json['registration_deadline'] as String),
      registrationUrl: json['registration_url'] as String?,
      competitorUids: (json['competitor_uids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$CompetitionToJson(Competition instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'date': instance.date.toIso8601String(),
      'location': instance.location,
      'registration_deadline': instance.registrationDeadline?.toIso8601String(),
      'registration_url': instance.registrationUrl,
      'competitor_uids': instance.competitorUids,
      'notes': instance.notes,
    };
