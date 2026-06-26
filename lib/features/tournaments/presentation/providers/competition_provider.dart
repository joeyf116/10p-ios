import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/service_locator.dart';
import '../../data/models/competition.dart';
import '../../domain/repositories/tournament_repository.dart';

final tournamentRepositoryProvider = Provider<TournamentRepository>(
  (ref) => serviceLocator<TournamentRepository>(),
);

final competitionsProvider = StreamProvider<List<Competition>>(
  (ref) => ref.watch(tournamentRepositoryProvider).watchUpcomingCompetitions(),
);
