import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/service_locator.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../data/models/membership_plan.dart';
import '../domain/repositories/membership_repository.dart';

class MembershipScreen extends ConsumerStatefulWidget {
  const MembershipScreen({super.key});

  @override
  ConsumerState<MembershipScreen> createState() => _MembershipScreenState();
}

class _MembershipScreenState extends ConsumerState<MembershipScreen> {
  MembershipTier _selected = MembershipTier.monthly;
  bool _loading = false;

  Future<void> _activate() async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;
    setState(() => _loading = true);
    try {
      // In production this would open a Stripe checkout session.
      // For the MVP we record the membership as activated directly.
      await serviceLocator<MembershipRepository>().recordMembershipActivated(
        memberId: user.uid,
        stripeCustomerId: 'cus_placeholder_${user.uid}',
        tier: _selected,
      );
      if (mounted) context.go('/home');
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choose a Membership')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Select a plan to begin training.', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 20),
            ...MembershipTier.values.map((tier) => _PlanCard(
              tier: tier,
              isSelected: _selected == tier,
              onSelect: () => setState(() => _selected = tier),
            )),
            const Spacer(),
            FilledButton(
              onPressed: _loading ? null : _activate,
              child: _loading
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Text('Continue with ${_selected.displayName}'),
            ),
            const SizedBox(height: 8),
            Text(
              'You will be redirected to Stripe to complete payment.',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({required this.tier, required this.isSelected, required this.onSelect});
  final MembershipTier tier;
  final bool isSelected;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.brandRed.withOpacity(0.12) : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.brandRed : Theme.of(context).colorScheme.outline,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Radio<MembershipTier>(
              value: tier,
              groupValue: isSelected ? tier : null,
              onChanged: (_) => onSelect(),
              activeColor: AppTheme.brandRed,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tier.displayName, style: Theme.of(context).textTheme.titleMedium),
                  Text(tier.description, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            Text(tier.price, style: TextStyle(color: AppTheme.brandRed, fontWeight: FontWeight.w700, fontSize: 15)),
          ],
        ),
      ),
    );
  }
}
