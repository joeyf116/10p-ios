import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/repositories/technique_library_repository.dart';
import '../models/technique.dart';
import '../../../../features/auth/data/models/app_user.dart';

class FirestoreTechniqueRepository implements TechniqueLibraryRepository {
  FirestoreTechniqueRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  final FirebaseFirestore _firestore;

  @override
  Stream<List<Technique>> watchTechniquesBySystem(String system) {
    return _firestore
        .collection('techniques')
        .where('system', isEqualTo: system)
        .orderBy('position')
        .orderBy('title')
        .snapshots()
        .map((snap) => snap.docs.map(_map).toList());
  }

  @override
  Stream<List<Technique>> watchTechniquesByPosition({
    required String system,
    required String position,
  }) {
    return _firestore
        .collection('techniques')
        .where('system', isEqualTo: system)
        .where('position', isEqualTo: position)
        .orderBy('title')
        .snapshots()
        .map((snap) => snap.docs.map(_map).toList());
  }

  @override
  Future<Technique?> getTechnique(String id) async {
    final snap = await _firestore.collection('techniques').doc(id).get();
    if (!snap.exists || snap.data() == null) return null;
    return _map(snap as QueryDocumentSnapshot<Map<String, dynamic>>);
  }

  Technique _map(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return Technique(
      id: doc.id,
      system: data['system'] as String? ?? '',
      position: data['position'] as String? ?? '',
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      videoUrl: data['video_url'] as String?,
      thumbnailUrl: data['thumbnail_url'] as String?,
      beltLevel: _parseBelt(data['belt_level'] as String?),
      tags: List<String>.from(data['tags'] as List? ?? []),
    );
  }

  static BeltRank _parseBelt(String? v) =>
      BeltRank.values.where((b) => b.name == v).firstOrNull ?? BeltRank.white;
}
