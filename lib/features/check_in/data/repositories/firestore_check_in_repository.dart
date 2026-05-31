import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/repositories/check_in_repository.dart';

class FirestoreCheckInRepository implements CheckInRepository {
  FirestoreCheckInRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  final FirebaseFirestore _firestore;

  @override
  Stream<String> rotatingQrPayload() async* {
    while (true) {
      final slot = DateTime.now().millisecondsSinceEpoch ~/ 30000;
      yield 'TENP-CHECKIN:$slot';
      await Future<void>.delayed(const Duration(seconds: 30));
    }
  }

  @override
  Future<void> checkIn({required String userId}) {
    return _firestore.collection('check_ins').add({
      'user_id': userId,
      'checked_in_at': FieldValue.serverTimestamp(),
    });
  }
}
