// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

AppUser _$AppUserFromJson(Map<String, dynamic> json) => AppUser(
  uid: json['uid'] as String,
  displayName: json['display_name'] as String,
  role: $enumDecode(_$UserRoleEnumMap, json['role']),
  beltRank: $enumDecode(_$BeltRankEnumMap, json['belt_rank']),
  waiverSigned: json['waiver_signed'] as bool,
  stripeCustomerId: json['stripe_customer_id'] as String?,
);

Map<String, dynamic> _$AppUserToJson(AppUser instance) => <String, dynamic>{
  'uid': instance.uid,
  'display_name': instance.displayName,
  'role': _$UserRoleEnumMap[instance.role]!,
  'belt_rank': _$BeltRankEnumMap[instance.beltRank]!,
  'waiver_signed': instance.waiverSigned,
  'stripe_customer_id': instance.stripeCustomerId,
};

const _$UserRoleEnumMap = {
  UserRole.member: 'member',
  UserRole.coach: 'coach',
  UserRole.owner: 'owner',
};

const _$BeltRankEnumMap = {
  BeltRank.white: 'white',
  BeltRank.blue: 'blue',
  BeltRank.purple: 'purple',
  BeltRank.brown: 'brown',
  BeltRank.black: 'black',
};
