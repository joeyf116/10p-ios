import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/repositories/membership_repository.dart';

class FirestoreMembershipRepository implements MembershipRepository {
  FirestoreMembershipRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  final FirebaseFirestore _firestore;

  @override
  Future<void> updateSubscription(
      {required String userId, required String planId}) async {
    await _firestore.collection('memberships').doc(userId).set({
      'user_id': userId,
      'plan_id': planId,
      'provider': 'stripe',
      'status': 'active',
      'updated_at': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await _firestore.collection('payments').add({
      'user_id': userId,
      'plan_id': planId,
      'event': 'subscription_updated',
      'created_at': FieldValue.serverTimestamp(),
    });
  }
}
