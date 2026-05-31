import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../core/di/service_locator.dart';
import '../domain/repositories/membership_repository.dart';

class MembershipScreen extends StatefulWidget {
  const MembershipScreen({super.key});

  @override
  State<MembershipScreen> createState() => _MembershipScreenState();
}

class _MembershipScreenState extends State<MembershipScreen> {
  final _plans = const [
    'fundamentals_monthly',
    'all_access_monthly',
    'pro_competitor'
  ];
  String _selectedPlan = 'all_access_monthly';
  bool _saving = false;

  MembershipRepository get _repository =>
      serviceLocator<MembershipRepository>();

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(title: const Text('Membership & Payments')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Select a plan to write membership and payment intent records to Firestore.',
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _selectedPlan,
            decoration: const InputDecoration(labelText: 'Plan'),
            items: _plans
                .map(
                  (plan) => DropdownMenuItem<String>(
                    value: plan,
                    child: Text(plan),
                  ),
                )
                .toList(),
            onChanged: _saving
                ? null
                : (value) {
                    if (value == null) return;
                    setState(() => _selectedPlan = value);
                  },
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _saving || userId == null
                ? null
                : () => _saveMembership(userId),
            child: Text(_saving ? 'Saving...' : 'Update Subscription'),
          ),
          if (userId == null)
            const Padding(
              padding: EdgeInsets.only(top: 12),
              child: Text('Sign in to update membership data.'),
            ),
        ],
      ),
    );
  }

  Future<void> _saveMembership(String userId) async {
    setState(() => _saving = true);
    try {
      await _repository.updateSubscription(
          userId: userId, planId: _selectedPlan);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Membership updated.')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not update membership: $error')),
      );
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }
}
