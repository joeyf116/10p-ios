import 'package:json_annotation/json_annotation.dart';

import '../../../../core/models/serializable_model.dart';
import '../../../auth/data/models/app_user.dart';

part 'technique.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Technique extends SerializableModel {
  Technique({
    required this.id,
    required this.system,
    required this.position,
    required this.title,
    required this.description,
    this.videoUrl,
    this.thumbnailUrl,
    this.beltLevel = BeltRank.white,
    this.tags = const [],
  });

  factory Technique.fromJson(Map<String, dynamic> json) =>
      _$TechniqueFromJson(json);

  final String id;

  /// Top-level 10th Planet system (e.g. "Rubber Guard", "Lockdown")
  final String system;

  /// Position within the system (e.g. "Mission Control", "Electric Chair")
  final String position;

  final String title;
  final String description;
  final String? videoUrl;
  final String? thumbnailUrl;
  final BeltRank beltLevel;
  final List<String> tags;

  @override
  Map<String, dynamic> toJson() => _$TechniqueToJson(this);
}

/// Canonical 10th Planet systems used for library navigation.
class TechniqueSystems {
  static const rubberGuard = 'Rubber Guard';
  static const lockdown = 'Lockdown';
  static const electricChair = 'Electric Chair';
  static const truck = 'Truck';
  static const coyoteGuard = 'Coyote Guard';
  static const halfGuard = 'Half Guard';
  static const closedGuard = 'Closed Guard';
  static const backAttacks = 'Back Attacks';

  static const all = [
    rubberGuard,
    lockdown,
    electricChair,
    truck,
    coyoteGuard,
    halfGuard,
    closedGuard,
    backAttacks,
  ];
}
