import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/service_locator.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../domain/repositories/waiver_repository.dart';

const _waiverText = '''
ASSUMPTION OF RISK AND LIABILITY WAIVER

By signing below, I acknowledge that Brazilian Jiu-Jitsu and related martial arts activities involve inherent risks including, but not limited to, physical injury, broken bones, sprains, strains, bruising, and in rare cases more serious injuries.

I voluntarily choose to participate in training at 10th Planet Jiu Jitsu Greenville knowing these risks exist.

I agree to hold harmless 10th Planet Jiu Jitsu Greenville, its instructors, staff, and affiliates from any and all liability arising from my participation.

I represent that I am in good physical health and have no medical conditions that would prevent my safe participation. I agree to inform instructors of any injuries or medical conditions before training.

I have read this waiver in its entirety and understand its contents.
''';

class WaiversScreen extends ConsumerStatefulWidget {
  const WaiversScreen({super.key});

  @override
  ConsumerState<WaiversScreen> createState() => _WaiversScreenState();
}

class _WaiversScreenState extends ConsumerState<WaiversScreen> {
  bool _agreed = false;
  bool _submitting = false;

  Future<void> _submit() async {
    final user = ref.read(currentUserProvider);
    if (user == null || !_agreed) return;
    setState(() => _submitting = true);
    try {
      await serviceLocator<WaiverRepository>().signWaiver(memberId: user.uid);
      if (mounted) context.go('/onboarding/membership');
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Liability Waiver')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.sports_martial_arts, color: AppTheme.brandRed, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Before training, please read and sign the liability waiver.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SingleChildScrollView(
                  child: Text(_waiverText, style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.6)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              value: _agreed,
              onChanged: _submitting ? null : (v) => setState(() => _agreed = v ?? false),
              title: const Text('I have read and agree to the terms above'),
              activeColor: AppTheme.brandRed,
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: (_agreed && !_submitting) ? _submit : null,
              child: _submitting
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Sign Waiver & Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
