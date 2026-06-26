import '../../data/models/technique.dart';

abstract class TechniqueLibraryRepository {
  Stream<List<Technique>> watchTechniquesBySystem(String system);

  Stream<List<Technique>> watchTechniquesByPosition({
    required String system,
    required String position,
  });

  Future<Technique?> getTechnique(String id);
}
