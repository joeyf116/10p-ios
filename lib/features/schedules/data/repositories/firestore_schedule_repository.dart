import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/repositories/schedule_repository.dart';
import '../models/schedule_class.dart';

class FirestoreScheduleRepository implements ScheduleRepository {
  FirestoreScheduleRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  final FirebaseFirestore _firestore;

  @override
  Stream<List<ScheduleClass>> watchSchedule() {
    final now = DateTime.now().subtract(const Duration(hours: 2));
    return _firestore
        .collection('schedules')
        .where('start_time', isGreaterThan: Timestamp.fromDate(now))
        .orderBy('start_time')
        .snapshots()
        .map((snap) => snap.docs.map(_map).toList());
  }

  @override
  Future<void> reserveSpot({required String classId, required String userId}) async {
    final ref = _firestore.collection('schedules').doc(classId);
    await _firestore.runTransaction((tx) async {
      final snap = await tx.get(ref);
      if (!snap.exists) throw StateError('Class not found.');
      final data = snap.data()!;
      final attendees = List<String>.from(data['attendees'] as List? ?? []);
      final capacity = (data['capacity_limit'] as num?)?.toInt() ?? 0;
      if (attendees.contains(userId)) return;
      if (attendees.length >= capacity) throw StateError('Class is full.');
      tx.update(ref, {'attendees': FieldValue.arrayUnion([userId])});
    });
  }

  @override
  Future<void> claimCoachSlot({required String classId, required String coachUid, required String coachDisplayName}) async {
    await _firestore.collection('schedules').doc(classId).update({
      'coach_uid': coachUid,
      'coach_display_name': coachDisplayName,
    });
  }

  @override
  Future<void> unclaimCoachSlot(String classId) async {
    await _firestore.collection('schedules').doc(classId).update({
      'coach_uid': '',
      'coach_display_name': '',
    });
  }

  ScheduleClass _map(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    final ts = data['start_time'];
    final startTime = ts is Timestamp ? ts.toDate() : DateTime.now();
    return ScheduleClass(
      classId: doc.id,
      title: data['title'] as String? ?? 'Untitled Class',
      coachUid: data['coach_uid'] as String? ?? '',
      coachDisplayName: data['coach_display_name'] as String? ?? 'Open',
      startTime: startTime,
      durationMinutes: (data['duration_minutes'] as num?)?.toInt() ?? 60,
      capacityLimit: (data['capacity_limit'] as num?)?.toInt() ?? 20,
      attendees: List<String>.from(data['attendees'] as List? ?? []),
      isRecurring: data['is_recurring'] as bool? ?? false,
      notes: data['notes'] as String?,
    );
  }
}
