import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/repositories/schedule_repository.dart';
import '../models/schedule_class.dart';

class FirestoreScheduleRepository implements ScheduleRepository {
  FirestoreScheduleRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  final FirebaseFirestore _firestore;

  @override
  Stream<List<ScheduleClass>> watchSchedule() {
    return _firestore
        .collection('schedules')
        .orderBy('start_time')
        .snapshots()
        .map((snapshot) => snapshot.docs.map(_mapClass).toList());
  }

  @override
  Future<void> reserveSpot(
      {required String classId, required String userId}) async {
    final classRef = _firestore.collection('schedules').doc(classId);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(classRef);
      if (!snapshot.exists) {
        throw StateError('Schedule class not found.');
      }

      final data = snapshot.data()!;
      final attendees =
          List<String>.from(data['attendees'] as List<dynamic>? ?? <dynamic>[]);
      final capacityLimit = (data['capacity_limit'] as num?)?.toInt() ?? 0;

      if (attendees.contains(userId)) {
        return;
      }

      if (attendees.length >= capacityLimit) {
        throw StateError('Class is full.');
      }

      transaction.update(classRef, {
        'attendees': FieldValue.arrayUnion([userId])
      });
    });
  }

  ScheduleClass _mapClass(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    final rawStart = data['start_time'];
    final startTime = rawStart is Timestamp
        ? rawStart.toDate()
        : (rawStart is String ? DateTime.tryParse(rawStart) : null) ??
            DateTime.now();

    return ScheduleClass(
      classId: doc.id,
      title: data['title'] as String? ?? 'Untitled Class',
      coachName: data['coach_name'] as String? ?? 'Unknown Coach',
      startTime: startTime,
      capacityLimit: (data['capacity_limit'] as num?)?.toInt() ?? 0,
      attendees:
          List<String>.from(data['attendees'] as List<dynamic>? ?? <dynamic>[]),
    );
  }
}
