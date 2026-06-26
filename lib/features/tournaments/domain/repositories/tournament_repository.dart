import '../../data/models/competition.dart';

abstract class TournamentRepository {
  Stream<List<Competition>> watchUpcomingCompetitions();

  Future<void> toggleCompeting({
    required String competitionId,
    required String memberId,
    required bool isCompeting,
  });
}
