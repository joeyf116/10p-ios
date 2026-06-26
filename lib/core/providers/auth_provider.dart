import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/data/models/app_user.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../di/service_locator.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => serviceLocator<AuthRepository>(),
);

final authStateProvider = StreamProvider<AppUser?>(
  (ref) => ref.watch(authRepositoryProvider).authStateChanges(),
);

final currentUserProvider = Provider<AppUser?>((ref) {
  return ref.watch(authStateProvider).valueOrNull;
});
