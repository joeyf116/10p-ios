import 'package:json_annotation/json_annotation.dart';

import '../../../../core/models/serializable_model.dart';

part 'check_in_record.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CheckInRecord extends SerializableModel {
  CheckInRecord({
    required this.id,
    required this.memberId,
    required this.timestamp,
    this.classId,
    this.latitude,
    this.longitude,
  });

  factory CheckInRecord.fromJson(Map<String, dynamic> json) =>
      _$CheckInRecordFromJson(json);

  final String id;
  final String memberId;
  final DateTime timestamp;
  final String? classId;
  final double? latitude;
  final double? longitude;

  @override
  Map<String, dynamic> toJson() => _$CheckInRecordToJson(this);
}
