import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/repositories/tournament_repository.dart';
import '../models/competition.dart';

class FirestoreTournamentRepository implements TournamentRepository {
  FirestoreTournamentRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  final FirebaseFirestore _firestore;

  @override
  Stream<List<Competition>> watchUpcomingCompetitions() {
    final now = DateTime.now();
    return _firestore
        .collection('competitions')
        .where('date', isGreaterThan: Timestamp.fromDate(now))
        .orderBy('date')
        .snapshots()
        .map((snap) => snap.docs.map(_map).toList());
  }

  @override
  Future<void> toggleCompeting({
    required String competitionId,
    required String memberId,
    required bool isCompeting,
  }) async {
    await _firestore.collection('competitions').doc(competitionId).update({
      'competitor_uids': isCompeting
          ? FieldValue.arrayUnion([memberId])
          : FieldValue.arrayRemove([memberId]),
    });
  }

  Competition _map(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return Competition(
      id: doc.id,
      name: data['name'] as String? ?? '',
      date: _ts(data['date']),
      location: data['location'] as String? ?? '',
      registrationDeadline: data['registration_deadline'] != null
          ? _ts(data['registration_deadline'])
          : null,
      registrationUrl: data['registration_url'] as String?,
      competitorUids: List<String>.from(data['competitor_uids'] as List? ?? []),
      notes: data['notes'] as String?,
    );
  }

  static DateTime _ts(dynamic v) =>
      v is Timestamp ? v.toDate() : DateTime.now();
}
