import 'package:json_annotation/json_annotation.dart';

import '../../../../core/models/serializable_model.dart';

part 'competition.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Competition extends SerializableModel {
  Competition({
    required this.id,
    required this.name,
    required this.date,
    required this.location,
    this.registrationDeadline,
    this.registrationUrl,
    this.competitorUids = const [],
    this.notes,
  });

  factory Competition.fromJson(Map<String, dynamic> json) =>
      _$CompetitionFromJson(json);

  final String id;
  final String name;
  final DateTime date;
  final String location;
  final DateTime? registrationDeadline;
  final String? registrationUrl;
  final List<String> competitorUids;
  final String? notes;

  bool isCompeting(String uid) => competitorUids.contains(uid);

  @override
  Map<String, dynamic> toJson() => _$CompetitionToJson(this);
}
