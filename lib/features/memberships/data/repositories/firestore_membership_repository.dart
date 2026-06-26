import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/repositories/membership_repository.dart';
import '../models/membership_plan.dart';

class FirestoreMembershipRepository implements MembershipRepository {
  FirestoreMembershipRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  final FirebaseFirestore _firestore;

  @override
  Future<bool> hasActiveMembership(String memberId) async {
    final snap = await _firestore
        .collection('memberships')
        .where('member_id', isEqualTo: memberId)
        .where('active', isEqualTo: true)
        .limit(1)
        .get();
    return snap.docs.isNotEmpty;
  }

  @override
  Future<void> recordMembershipActivated({
    required String memberId,
    required String stripeCustomerId,
    required MembershipTier tier,
  }) async {
    await Future.wait([
      _firestore.collection('memberships').doc(memberId).set({
        'member_id': memberId,
        'stripe_customer_id': stripeCustomerId,
        'tier': tier.name,
        'active': true,
        'activated_at': FieldValue.serverTimestamp(),
      }),
      _firestore.collection('users').doc(memberId).update({
        'stripe_customer_id': stripeCustomerId,
        'membership_active': true,
      }),
    ]);
  }
}
