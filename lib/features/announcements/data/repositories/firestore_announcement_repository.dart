import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/repositories/announcement_repository.dart';

class FirestoreAnnouncementRepository implements AnnouncementRepository {
  FirestoreAnnouncementRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  final FirebaseFirestore _firestore;

  @override
  Future<void> publish({required String title, required String body}) {
    return _firestore.collection('announcements').add({
      'title': title,
      'body': body,
      'created_at': FieldValue.serverTimestamp(),
    });
  }
}
