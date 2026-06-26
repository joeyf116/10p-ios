import '../../../memberships/data/models/membership_plan.dart';

abstract class MembershipRepository {
  Future<bool> hasActiveMembership(String memberId);

  Future<void> recordMembershipActivated({
    required String memberId,
    required String stripeCustomerId,
    required MembershipTier tier,
  });
}
