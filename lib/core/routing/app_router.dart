import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/announcements/presentation/announcements_screen.dart';
import '../../features/auth/presentation/auth_screen.dart';
import '../../features/check_in/presentation/check_in_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/memberships/presentation/membership_screen.dart';
import '../../features/schedules/presentation/schedule_screen.dart';
import '../../features/waivers/presentation/waivers_screen.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/auth',
      builder: (context, state) => const AuthScreen(),
    ),
    GoRoute(
      path: '/check-in',
      builder: (context, state) => const CheckInScreen(),
    ),
    GoRoute(
      path: '/schedule',
      builder: (context, state) => const ScheduleScreen(),
    ),
    GoRoute(
      path: '/library',
      builder: (context, state) =>
          const PlaceholderScreen(title: 'Technique Library'),
    ),
    GoRoute(
      path: '/tournaments',
      builder: (context, state) =>
          const PlaceholderScreen(title: 'Tournament Hub'),
    ),
    GoRoute(
      path: '/waivers',
      builder: (context, state) => const WaiversScreen(),
    ),
    GoRoute(
      path: '/membership',
      builder: (context, state) => const MembershipScreen(),
    ),
    GoRoute(
      path: '/announcements',
      builder: (context, state) => const AnnouncementsScreen(),
    ),
  ],
);

class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
          child: Text(title, style: Theme.of(context).textTheme.titleLarge)),
    );
  }
}
