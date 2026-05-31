import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/home_screen.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/auth',
      builder: (context, state) => const PlaceholderScreen(title: 'Authentication'),
    ),
    GoRoute(
      path: '/check-in',
      builder: (context, state) => const PlaceholderScreen(title: 'Attendance & Check-In'),
    ),
    GoRoute(
      path: '/schedule',
      builder: (context, state) => const PlaceholderScreen(title: 'Class Scheduling'),
    ),
    GoRoute(
      path: '/library',
      builder: (context, state) => const PlaceholderScreen(title: 'Technique Library'),
    ),
    GoRoute(
      path: '/tournaments',
      builder: (context, state) => const PlaceholderScreen(title: 'Tournament Hub'),
    ),
    GoRoute(
      path: '/waivers',
      builder: (context, state) => const PlaceholderScreen(title: 'Legal Waivers'),
    ),
    GoRoute(
      path: '/membership',
      builder: (context, state) => const PlaceholderScreen(title: 'Membership & Payments'),
    ),
    GoRoute(
      path: '/announcements',
      builder: (context, state) => const PlaceholderScreen(title: 'Announcements'),
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
      body: Center(child: Text(title, style: Theme.of(context).textTheme.titleLarge)),
    );
  }
}
