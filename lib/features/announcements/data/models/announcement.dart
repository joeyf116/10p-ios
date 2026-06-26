import 'package:json_annotation/json_annotation.dart';

import '../../../../core/models/serializable_model.dart';

part 'announcement.g.dart';

enum AnnouncementAudience {
  @JsonValue('all') all,
  @JsonValue('members') members,
  @JsonValue('coaches') coaches,
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Announcement extends SerializableModel {
  Announcement({
    required this.id,
    required this.title,
    required this.body,
    required this.authorUid,
    required this.authorDisplayName,
    required this.postedAt,
    this.targetAudience = AnnouncementAudience.all,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementFromJson(json);

  final String id;
  final String title;
  final String body;
  final String authorUid;
  final String authorDisplayName;
  final DateTime postedAt;
  final AnnouncementAudience targetAudience;

  @override
  Map<String, dynamic> toJson() => _$AnnouncementToJson(this);
}
