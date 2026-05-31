import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../core/di/service_locator.dart';
import '../domain/repositories/waiver_repository.dart';

class WaiversScreen extends StatefulWidget {
  const WaiversScreen({super.key});

  @override
  State<WaiversScreen> createState() => _WaiversScreenState();
}

class _WaiversScreenState extends State<WaiversScreen> {
  bool _accepted = false;
  bool _submitting = false;

  WaiverRepository get _repository => serviceLocator<WaiverRepository>();

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(title: const Text('Legal Waivers')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: userId == null
            ? const Center(child: Text('Sign in to view and submit waivers.'))
            : FutureBuilder<bool>(
                future: _repository.hasValidWaiver(userId),
                builder: (context, snapshot) {
                  final hasWaiver = snapshot.data ?? false;
                  return ListView(
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            hasWaiver
                                ? 'A valid waiver is on file.'
                                : 'No active waiver found. Please accept and submit a waiver.',
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      CheckboxListTile(
                        value: _accepted,
                        onChanged: _submitting
                            ? null
                            : (value) =>
                                setState(() => _accepted = value ?? false),
                        title: const Text(
                            'I have read and accept the liability waiver.'),
                      ),
                      const SizedBox(height: 8),
                      FilledButton(
                        onPressed: _submitting || !_accepted
                            ? null
                            : () => _submitWaiver(userId),
                        child: Text(_submitting
                            ? 'Submitting...'
                            : 'Submit Signed Waiver'),
                      ),
                    ],
                  );
                },
              ),
      ),
    );
  }

  Future<void> _submitWaiver(String userId) async {
    setState(() => _submitting = true);

    try {
      final signatureBytes = utf8.encode(
        'Signed by $userId on ${DateTime.now().toIso8601String()}',
      );
      await _repository.uploadSignedWaiver(
          userId: userId, pngBytes: signatureBytes);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Waiver saved.')),
      );
      setState(() => _accepted = false);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Waiver submission failed: $error')),
      );
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }
}
