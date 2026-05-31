import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/repositories/waiver_repository.dart';

class FirestoreWaiverRepository implements WaiverRepository {
  FirestoreWaiverRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  final FirebaseFirestore _firestore;

  @override
  Future<bool> hasValidWaiver(String userId) async {
    final snapshot = await _firestore
        .collection('waivers')
        .where('user_id', isEqualTo: userId)
        .where('is_active', isEqualTo: true)
        .limit(1)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  @override
  Future<String> uploadSignedWaiver(
      {required String userId, required List<int> pngBytes}) async {
    final docRef = await _firestore.collection('waivers').add({
      'user_id': userId,
      'is_active': true,
      'signed_at': FieldValue.serverTimestamp(),
      'signature_png_base64': base64Encode(pngBytes),
    });

    await _firestore.collection('users').doc(userId).set({
      'waiver_signed': true,
    }, SetOptions(merge: true));

    return docRef.id;
  }
}
