import 'package:flutter/material.dart';

import '../../../core/layout/adaptive_scaffold.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdaptiveScaffold(
      title: '10th Planet Member Ecosystem',
      body: _HomeContent(),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        _FeatureTile(title: 'Authentication & Profiles', subtitle: 'Firebase Auth with member/coach/admin roles'),
        _FeatureTile(title: 'Attendance & Check-In', subtitle: 'QR check-in and location-aware mobile entry'),
        _FeatureTile(title: 'Class Scheduling', subtitle: 'Realtime Firestore-backed reservations and slot caps'),
        _FeatureTile(title: 'Technique Library', subtitle: 'Structured 10th Planet systems with adaptive video playback'),
        _FeatureTile(title: 'Tournament Hub', subtitle: 'Roster tracking and weight-class conversions'),
        _FeatureTile(title: 'Waivers', subtitle: 'Signature capture and immutable PDF references'),
        _FeatureTile(title: 'Membership Payments', subtitle: 'Stripe-backed subscriptions with secure updates'),
        _FeatureTile(title: 'Announcements', subtitle: 'In-app feed, push notifications, and email broadcast support'),
      ],
    );
  }
}

class _FeatureTile extends StatelessWidget {
  const _FeatureTile({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }
}
