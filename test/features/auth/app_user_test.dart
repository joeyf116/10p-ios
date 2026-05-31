import 'package:flutter_test/flutter_test.dart';
import 'package:tenp_member_ecosystem/features/auth/data/models/app_user.dart';

void main() {
  test('serializes and deserializes firestore user schema', () {
    final user = AppUser(
      uid: 'abc123',
      displayName: 'Jane Doe',
      role: UserRole.member,
      beltRank: BeltRank.purple,
      waiverSigned: true,
      stripeCustomerId: 'cus_123',
    );

    final json = user.toJson();
    expect(json['display_name'], 'Jane Doe');
    expect(json['role'], 'member');
    expect(AppUser.fromJson(json).beltRank, BeltRank.purple);
  });
}
