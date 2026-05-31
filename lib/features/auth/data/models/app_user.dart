import 'package:json_annotation/json_annotation.dart';

import '../../../../core/models/serializable_model.dart';

part 'app_user.g.dart';

enum UserRole { member, coach, owner }
enum BeltRank { white, blue, purple, brown, black }

@JsonSerializable(fieldRename: FieldRename.snake)
class AppUser extends SerializableModel {
  AppUser({
    required this.uid,
    required this.displayName,
    required this.role,
    required this.beltRank,
    required this.waiverSigned,
    this.stripeCustomerId,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) => _$AppUserFromJson(json);

  final String uid;
  final String displayName;
  final UserRole role;
  final BeltRank beltRank;
  final bool waiverSigned;
  final String? stripeCustomerId;

  @override
  Map<String, dynamic> toJson() => _$AppUserToJson(this);
}
