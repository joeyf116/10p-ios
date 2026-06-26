import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import '../../features/announcements/data/repositories/firestore_announcement_repository.dart';
import '../../features/announcements/domain/repositories/announcement_repository.dart';
import '../../features/auth/data/repositories/firebase_auth_repository.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/check_in/data/repositories/firestore_check_in_repository.dart';
import '../../features/check_in/domain/repositories/check_in_repository.dart';
import '../../features/content/data/repositories/firestore_technique_repository.dart';
import '../../features/content/domain/repositories/technique_library_repository.dart';
import '../../features/memberships/data/repositories/firestore_membership_repository.dart';
import '../../features/memberships/domain/repositories/membership_repository.dart';
import '../../features/schedules/data/repositories/firestore_schedule_repository.dart';
import '../../features/schedules/domain/repositories/schedule_repository.dart';
import '../../features/tournaments/data/repositories/firestore_tournament_repository.dart';
import '../../features/tournaments/domain/repositories/tournament_repository.dart';
import '../../features/waivers/data/repositories/firestore_waiver_repository.dart';
import '../../features/waivers/domain/repositories/waiver_repository.dart';

final GetIt serviceLocator = GetIt.instance;

void configureDependencies() {
  serviceLocator.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  serviceLocator.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  serviceLocator.registerLazySingleton<AuthRepository>(
    () => FirebaseAuthRepository(
      firebaseAuth: serviceLocator<FirebaseAuth>(),
      firestore: serviceLocator<FirebaseFirestore>(),
    ),
  );

  serviceLocator.registerLazySingleton<ScheduleRepository>(
    () => FirestoreScheduleRepository(firestore: serviceLocator<FirebaseFirestore>()),
  );

  serviceLocator.registerLazySingleton<CheckInRepository>(
    () => FirestoreCheckInRepository(firestore: serviceLocator<FirebaseFirestore>()),
  );

  serviceLocator.registerLazySingleton<AnnouncementRepository>(
    () => FirestoreAnnouncementRepository(firestore: serviceLocator<FirebaseFirestore>()),
  );

  serviceLocator.registerLazySingleton<WaiverRepository>(
    () => FirestoreWaiverRepository(firestore: serviceLocator<FirebaseFirestore>()),
  );

  serviceLocator.registerLazySingleton<MembershipRepository>(
    () => FirestoreMembershipRepository(firestore: serviceLocator<FirebaseFirestore>()),
  );

  serviceLocator.registerLazySingleton<TechniqueLibraryRepository>(
    () => FirestoreTechniqueRepository(firestore: serviceLocator<FirebaseFirestore>()),
  );

  serviceLocator.registerLazySingleton<TournamentRepository>(
    () => FirestoreTournamentRepository(firestore: serviceLocator<FirebaseFirestore>()),
  );
}
