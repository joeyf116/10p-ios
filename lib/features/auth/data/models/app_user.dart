import 'package:json_annotation/json_annotation.dart';

import '../../../../core/models/serializable_model.dart';

part 'app_user.g.dart';

enum UserRole {
  @JsonValue('member') member,
  @JsonValue('coach') coach,
  @JsonValue('owner') owner,
}

enum BeltRank {
  @JsonValue('white') white,
  @JsonValue('blue') blue,
  @JsonValue('purple') purple,
  @JsonValue('brown') brown,
  @JsonValue('black') black,
}

@JsonSerializable(fieldRename: FieldRename.snake)
class AppUser extends SerializableModel {
  AppUser({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.role,
    required this.beltRank,
    required this.waiverSigned,
    this.stripeCustomerId,
    this.membershipActive = false,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) => _$AppUserFromJson(json);

  final String uid;
  final String email;
  final String displayName;
  final UserRole role;
  final BeltRank beltRank;
  final bool waiverSigned;
  final String? stripeCustomerId;
  final bool membershipActive;

  bool get isCoachOrOwner => role == UserRole.coach || role == UserRole.owner;
  bool get isOwner => role == UserRole.owner;

  @override
  Map<String, dynamic> toJson() => _$AppUserToJson(this);

  AppUser copyWith({
    String? displayName,
    UserRole? role,
    BeltRank? beltRank,
    bool? waiverSigned,
    String? stripeCustomerId,
    bool? membershipActive,
  }) {
    return AppUser(
      uid: uid,
      email: email,
      displayName: displayName ?? this.displayName,
      role: role ?? this.role,
      beltRank: beltRank ?? this.beltRank,
      waiverSigned: waiverSigned ?? this.waiverSigned,
      stripeCustomerId: stripeCustomerId ?? this.stripeCustomerId,
      membershipActive: membershipActive ?? this.membershipActive,
    );
  }
}
