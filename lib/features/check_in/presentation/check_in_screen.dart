import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../core/di/service_locator.dart';
import '../domain/repositories/check_in_repository.dart';

class CheckInScreen extends StatelessWidget {
  const CheckInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = serviceLocator<CheckInRepository>();

    return Scaffold(
      appBar: AppBar(title: const Text('Attendance & Check-In')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder<String>(
          stream: repository.rotatingQrPayload(),
          builder: (context, snapshot) {
            final payload = snapshot.data ?? 'Loading QR payload...';
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        QrImageView(data: payload, size: 220),
                        const SizedBox(height: 12),
                        Text(payload, textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () => _checkIn(context, repository),
                  child: const Text('Check In Now'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _checkIn(
      BuildContext context, CheckInRepository repository) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be signed in to check in.')),
      );
      return;
    }

    try {
      await repository.checkIn(userId: userId);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Check-in complete.')),
      );
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Check-in failed: $error')),
      );
    }
  }
}
