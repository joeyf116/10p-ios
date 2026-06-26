import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/service_locator.dart';
import '../../data/models/technique.dart';
import '../../domain/repositories/technique_library_repository.dart';

final techniqueRepositoryProvider = Provider<TechniqueLibraryRepository>(
  (ref) => serviceLocator<TechniqueLibraryRepository>(),
);

final selectedSystemProvider = StateProvider<String>(
  (ref) => TechniqueSystems.rubberGuard,
);

final selectedPositionProvider = StateProvider<String?>((ref) => null);

final techniquesBySystemProvider = StreamProvider.family<List<Technique>, String>(
  (ref, system) => ref.watch(techniqueRepositoryProvider).watchTechniquesBySystem(system),
);

final positionsForSystemProvider = Provider.family<List<String>, String>((ref, system) {
  final techniques = ref.watch(techniquesBySystemProvider(system)).valueOrNull ?? [];
  final positions = techniques.map((t) => t.position).toSet().toList()..sort();
  return positions;
});

final techniquesByPositionProvider = StreamProvider.family<List<Technique>, ({String system, String position})>(
  (ref, args) => ref.watch(techniqueRepositoryProvider).watchTechniquesByPosition(
        system: args.system,
        position: args.position,
      ),
);
