import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/repositories/waiver_repository.dart';

class FirestoreWaiverRepository implements WaiverRepository {
  FirestoreWaiverRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  final FirebaseFirestore _firestore;

  @override
  Future<bool> hasSignedWaiver(String memberId) async {
    final snap = await _firestore.collection('waivers').doc(memberId).get();
    return snap.exists;
  }

  @override
  Future<void> signWaiver({required String memberId}) async {
    await Future.wait([
      _firestore.collection('waivers').doc(memberId).set({
        'member_id': memberId,
        'signed_at': FieldValue.serverTimestamp(),
      }),
      _firestore.collection('users').doc(memberId).update({
        'waiver_signed': true,
      }),
    ]);
  }
}
