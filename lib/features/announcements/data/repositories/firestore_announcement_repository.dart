import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/repositories/announcement_repository.dart';
import '../models/announcement.dart';

class FirestoreAnnouncementRepository implements AnnouncementRepository {
  FirestoreAnnouncementRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  final FirebaseFirestore _firestore;

  @override
  Stream<List<Announcement>> watchAnnouncements() {
    return _firestore
        .collection('announcements')
        .orderBy('posted_at', descending: true)
        .limit(50)
        .snapshots()
        .map((snap) => snap.docs.map(_map).toList());
  }

  @override
  Future<void> publish({
    required String title,
    required String body,
    required String authorUid,
    required String authorDisplayName,
    AnnouncementAudience targetAudience = AnnouncementAudience.all,
  }) async {
    final ref = _firestore.collection('announcements').doc();
    await ref.set({
      'id': ref.id,
      'title': title,
      'body': body,
      'author_uid': authorUid,
      'author_display_name': authorDisplayName,
      'posted_at': FieldValue.serverTimestamp(),
      'target_audience': targetAudience.name,
    });
  }

  @override
  Future<void> markRead({required String announcementId, required String memberId}) async {
    await _firestore
        .collection('announcements')
        .doc(announcementId)
        .collection('read_by')
        .doc(memberId)
        .set({'read_at': FieldValue.serverTimestamp()});
  }

  @override
  Stream<Set<String>> watchReadIds(String memberId) {
    return _firestore
        .collectionGroup('read_by')
        .where(FieldPath.documentId, isEqualTo: memberId)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => d.reference.parent.parent!.id).toSet());
  }

  Announcement _map(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    final ts = data['posted_at'];
    final postedAt = ts is Timestamp ? ts.toDate() : DateTime.now();
    return Announcement(
      id: doc.id,
      title: data['title'] as String? ?? '',
      body: data['body'] as String? ?? '',
      authorUid: data['author_uid'] as String? ?? '',
      authorDisplayName: data['author_display_name'] as String? ?? 'Staff',
      postedAt: postedAt,
      targetAudience: AnnouncementAudience.values
              .where((a) => a.name == data['target_audience'])
              .firstOrNull ??
          AnnouncementAudience.all,
    );
  }
}
