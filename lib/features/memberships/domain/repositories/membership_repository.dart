abstract class MembershipRepository {
  Future<void> updateSubscription({required String userId, required String planId});
}
