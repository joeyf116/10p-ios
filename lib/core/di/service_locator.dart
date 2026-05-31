import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import '../../features/announcements/data/repositories/firestore_announcement_repository.dart';
import '../../features/announcements/domain/repositories/announcement_repository.dart';
import '../../features/auth/data/repositories/firebase_auth_repository.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/check_in/data/repositories/firestore_check_in_repository.dart';
import '../../features/check_in/domain/repositories/check_in_repository.dart';
import '../../features/memberships/data/repositories/firestore_membership_repository.dart';
import '../../features/memberships/domain/repositories/membership_repository.dart';
import '../../features/schedules/data/repositories/firestore_schedule_repository.dart';
import '../../features/schedules/domain/repositories/schedule_repository.dart';
import '../../features/waivers/data/repositories/firestore_waiver_repository.dart';
import '../../features/waivers/domain/repositories/waiver_repository.dart';

final GetIt serviceLocator = GetIt.instance;

void configureDependencies() {
  if (!serviceLocator.isRegistered<FirebaseAuth>()) {
    serviceLocator
        .registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  }

  if (!serviceLocator.isRegistered<FirebaseFirestore>()) {
    serviceLocator.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance,
    );
  }

  if (!serviceLocator.isRegistered<AuthRepository>()) {
    serviceLocator.registerLazySingleton<AuthRepository>(
      () => FirebaseAuthRepository(
        firebaseAuth: serviceLocator<FirebaseAuth>(),
        firestore: serviceLocator<FirebaseFirestore>(),
      ),
    );
  }

  if (!serviceLocator.isRegistered<ScheduleRepository>()) {
    serviceLocator.registerLazySingleton<ScheduleRepository>(
      () => FirestoreScheduleRepository(
        firestore: serviceLocator<FirebaseFirestore>(),
      ),
    );
  }

  if (!serviceLocator.isRegistered<CheckInRepository>()) {
    serviceLocator.registerLazySingleton<CheckInRepository>(
      () => FirestoreCheckInRepository(
        firestore: serviceLocator<FirebaseFirestore>(),
      ),
    );
  }

  if (!serviceLocator.isRegistered<WaiverRepository>()) {
    serviceLocator.registerLazySingleton<WaiverRepository>(
      () => FirestoreWaiverRepository(
        firestore: serviceLocator<FirebaseFirestore>(),
      ),
    );
  }

  if (!serviceLocator.isRegistered<MembershipRepository>()) {
    serviceLocator.registerLazySingleton<MembershipRepository>(
      () => FirestoreMembershipRepository(
        firestore: serviceLocator<FirebaseFirestore>(),
      ),
    );
  }

  if (!serviceLocator.isRegistered<AnnouncementRepository>()) {
    serviceLocator.registerLazySingleton<AnnouncementRepository>(
      () => FirestoreAnnouncementRepository(
        firestore: serviceLocator<FirebaseFirestore>(),
      ),
    );
  }

  if (!serviceLocator.isRegistered<DateTime>()) {
    serviceLocator.registerFactory<DateTime>(DateTime.now);
  }
}
