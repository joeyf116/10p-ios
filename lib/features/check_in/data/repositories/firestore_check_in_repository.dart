import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/repositories/check_in_repository.dart';
import '../models/check_in_record.dart';

class FirestoreCheckInRepository implements CheckInRepository {
  FirestoreCheckInRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  final FirebaseFirestore _firestore;

  @override
  Future<void> checkIn({
    required String memberId,
    required double latitude,
    required double longitude,
    String? classId,
  }) async {
    final ref = _firestore.collection('check_ins').doc();
    await ref.set({
      'id': ref.id,
      'member_id': memberId,
      'timestamp': FieldValue.serverTimestamp(),
      'class_id': classId,
      'latitude': latitude,
      'longitude': longitude,
    });
  }

  @override
  Stream<List<CheckInRecord>> watchMemberCheckIns(String memberId) {
    return _firestore
        .collection('check_ins')
        .where('member_id', isEqualTo: memberId)
        .orderBy('timestamp', descending: true)
        .limit(30)
        .snapshots()
        .map((snap) => snap.docs.map(_map).toList());
  }

  CheckInRecord _map(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    final ts = data['timestamp'];
    final timestamp = ts is Timestamp ? ts.toDate() : DateTime.now();
    return CheckInRecord(
      id: doc.id,
      memberId: data['member_id'] as String? ?? '',
      timestamp: timestamp,
      classId: data['class_id'] as String?,
      latitude: (data['latitude'] as num?)?.toDouble(),
      longitude: (data['longitude'] as num?)?.toDouble(),
    );
  }
}
