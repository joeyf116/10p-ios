import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../core/constants/gym_location.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../domain/repositories/check_in_repository.dart';

enum _CheckInState { idle, locating, success, tooFar, error }

class CheckInScreen extends ConsumerStatefulWidget {
  const CheckInScreen({super.key});

  @override
  ConsumerState<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends ConsumerState<CheckInScreen> {
  _CheckInState _state = _CheckInState.idle;
  String? _errorMessage;

  Future<void> _checkIn() async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;
    setState(() { _state = _CheckInState.locating; _errorMessage = null; });
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        setState(() { _state = _CheckInState.error; _errorMessage = 'Location permission required.'; });
        return;
      }
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
      final dist = _haversine(pos.latitude, pos.longitude, GymLocation.latitude, GymLocation.longitude);
      if (dist > GymLocation.checkInRadiusMeters) {
        setState(() => _state = _CheckInState.tooFar);
        return;
      }
      await serviceLocator<CheckInRepository>().checkIn(
        memberId: user.uid,
        latitude: pos.latitude,
        longitude: pos.longitude,
      );
      setState(() => _state = _CheckInState.success);
    } catch (e) {
      setState(() { _state = _CheckInState.error; _errorMessage = e.toString(); });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Check In')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Center(
                child: switch (_state) {
                  _CheckInState.idle => _IdleView(onCheckIn: _checkIn),
                  _CheckInState.locating => const _LocatingView(),
                  _CheckInState.success => _SuccessView(onReset: () => setState(() => _state = _CheckInState.idle)),
                  _CheckInState.tooFar => _TooFarView(onReset: () => setState(() => _state = _CheckInState.idle)),
                  _CheckInState.error => _ErrorView(message: _errorMessage, onReset: () => setState(() => _state = _CheckInState.idle)),
                },
              ),
            ),
            const Divider(),
            const SizedBox(height: 12),
            Text('Your QR Code', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 12),
            if (user != null)
              Center(
                child: QrImageView(
                  data: 'TENP:${user.uid}',
                  size: 160,
                  backgroundColor: Colors.white,
                ),
              ),
            const SizedBox(height: 8),
            Text(
              'Show to a coach if location check-in fails.',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  static double _haversine(double lat1, double lon1, double lat2, double lon2) {
    const r = 6371000.0;
    final dLat = (lat2 - lat1) * pi / 180;
    final dLon = (lon2 - lon1) * pi / 180;
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * pi / 180) * cos(lat2 * pi / 180) *
        sin(dLon / 2) * sin(dLon / 2);
    return r * 2 * atan2(sqrt(a), sqrt(1 - a));
  }
}

class _IdleView extends StatelessWidget {
  const _IdleView({required this.onCheckIn});
  final VoidCallback onCheckIn;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(Icons.location_on_outlined, size: 80, color: AppTheme.brandRed),
      const SizedBox(height: 16),
      Text('Ready to train?', style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 8),
      Text('You must be at the gym to check in.', style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center),
      const SizedBox(height: 32),
      FilledButton.icon(onPressed: onCheckIn, icon: const Icon(Icons.check_circle_outline), label: const Text('Check In Now')),
    ],
  );
}

class _LocatingView extends StatelessWidget {
  const _LocatingView();

  @override
  Widget build(BuildContext context) => const Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      CircularProgressIndicator(color: AppTheme.brandRed),
      SizedBox(height: 16),
      Text('Getting your location…'),
    ],
  );
}

class _SuccessView extends StatelessWidget {
  const _SuccessView({required this.onReset});
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      const Icon(Icons.check_circle, size: 80, color: Colors.green),
      const SizedBox(height: 16),
      Text('Checked In!', style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 8),
      Text('Get on the mats. OSS!', style: Theme.of(context).textTheme.bodySmall),
      const SizedBox(height: 24),
      OutlinedButton(onPressed: onReset, child: const Text('Done')),
    ],
  );
}

class _TooFarView extends StatelessWidget {
  const _TooFarView({required this.onReset});
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      const Icon(Icons.location_off, size: 80, color: Colors.orange),
      const SizedBox(height: 16),
      Text("You're not at the gym", style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 8),
      Text(
        'Must be within ${GymLocation.checkInRadiusMeters.toInt()} m.\nUse your QR code below instead.',
        style: Theme.of(context).textTheme.bodySmall,
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 24),
      OutlinedButton(onPressed: onReset, child: const Text('Try Again')),
    ],
  );
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({this.message, required this.onReset});
  final String? message;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(Icons.error_outline, size: 80, color: Theme.of(context).colorScheme.error),
      const SizedBox(height: 16),
      Text('Something went wrong', style: Theme.of(context).textTheme.titleLarge),
      if (message != null) ...[const SizedBox(height: 8), Text(message!, style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center)],
      const SizedBox(height: 24),
      OutlinedButton(onPressed: onReset, child: const Text('Try Again')),
    ],
  );
}
