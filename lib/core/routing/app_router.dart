import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/announcements/presentation/announcements_screen.dart';
import '../../features/auth/presentation/auth_screen.dart';
import '../../features/check_in/presentation/check_in_screen.dart';
import '../../features/content/presentation/technique_detail_screen.dart';
import '../../features/content/presentation/technique_library_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/memberships/presentation/membership_screen.dart';
import '../../features/schedules/presentation/coaches_schedule_screen.dart';
import '../../features/schedules/presentation/schedule_screen.dart';
import '../../features/tournaments/presentation/competitions_screen.dart';
import '../../features/waivers/presentation/waivers_screen.dart';
import '../providers/auth_provider.dart';
import '../widgets/app_shell.dart';

final routerNotifierProvider =
    AsyncNotifierProvider.autoDispose<RouterNotifier, void>(RouterNotifier.new);

class RouterNotifier extends AutoDisposeAsyncNotifier<void> implements Listenable {
  final List<VoidCallback> _listeners = [];

  @override
  Future<void> build() async {
    ref.listen(authStateProvider, (_, __) => notifyListeners());
  }

  String? redirect(BuildContext context, GoRouterState state) {
    final user = ref.read(authStateProvider).valueOrNull;
    final loc = state.matchedLocation;

    if (user == null) {
      return loc == '/auth' ? null : '/auth';
    }

    if (!user.waiverSigned) {
      return loc == '/onboarding/waiver' ? null : '/onboarding/waiver';
    }

    if (!user.membershipActive) {
      return loc == '/onboarding/membership' ? null : '/onboarding/membership';
    }

    if (loc == '/auth' || loc.startsWith('/onboarding')) {
      return '/home';
    }

    if (loc == '/coaches' && !user.isCoachOrOwner) return '/home';

    return null;
  }

  @override
  void addListener(VoidCallback listener) => _listeners.add(listener);

  @override
  void removeListener(VoidCallback listener) => _listeners.remove(listener);

  void notifyListeners() {
    for (final l in _listeners) {
      l();
    }
  }
}

final routerProvider = Provider.autoDispose<GoRouter>((ref) {
  final notifier = ref.watch(routerNotifierProvider.notifier);
  return GoRouter(
    initialLocation: '/home',
    refreshListenable: notifier,
    redirect: notifier.redirect,
    routes: [
      GoRoute(path: '/auth', builder: (_, __) => const AuthScreen()),
      GoRoute(path: '/onboarding/waiver', builder: (_, __) => const WaiversScreen()),
      GoRoute(path: '/onboarding/membership', builder: (_, __) => const MembershipScreen()),
      StatefulShellRoute.indexedStack(
        builder: (_, __, shell) => AppShell(navigationShell: shell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/schedule', builder: (_, __) => const ScheduleScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/check-in', builder: (_, __) => const CheckInScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/library',
              builder: (_, __) => const TechniqueLibraryScreen(),
              routes: [
                GoRoute(
                  path: ':id',
                  builder: (_, state) => TechniqueDetailScreen(
                    techniqueId: state.pathParameters['id']!,
                  ),
                ),
              ],
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/announcements', builder: (_, __) => const AnnouncementsScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/coaches', builder: (_, __) => const CoachesScheduleScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/competitions', builder: (_, __) => const CompetitionsScreen()),
          ]),
        ],
      ),
    ],
  );
});

// Keep a top-level reference so app.dart can access it without autoDispose issues.
// app.dart uses ConsumerWidget and watches routerProvider directly.
GoRouter get appRouter => throw UnimplementedError('Use routerProvider via Riverpod');
