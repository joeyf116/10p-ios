import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FirebaseBootstrap {
  const FirebaseBootstrap._();

  static Future<void> initialize() async {
    if (Firebase.apps.isNotEmpty) {
      return;
    }

    if (kIsWeb) {
      final options = _readWebOptionsFromEnv();
      await Firebase.initializeApp(options: options);
      return;
    }

    await Firebase.initializeApp();
  }

  static FirebaseOptions _readWebOptionsFromEnv() {
    const apiKey = String.fromEnvironment('FIREBASE_API_KEY');
    const appId = String.fromEnvironment('FIREBASE_APP_ID');
    const messagingSenderId =
        String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID');
    const projectId = String.fromEnvironment('FIREBASE_PROJECT_ID');
    const authDomain = String.fromEnvironment('FIREBASE_AUTH_DOMAIN');
    const storageBucket = String.fromEnvironment('FIREBASE_STORAGE_BUCKET');
    const measurementId = String.fromEnvironment('FIREBASE_MEASUREMENT_ID');

    final missing = <String>[];
    if (apiKey.isEmpty) missing.add('FIREBASE_API_KEY');
    if (appId.isEmpty) missing.add('FIREBASE_APP_ID');
    if (messagingSenderId.isEmpty) missing.add('FIREBASE_MESSAGING_SENDER_ID');
    if (projectId.isEmpty) missing.add('FIREBASE_PROJECT_ID');
    if (authDomain.isEmpty) missing.add('FIREBASE_AUTH_DOMAIN');
    if (storageBucket.isEmpty) missing.add('FIREBASE_STORAGE_BUCKET');

    if (missing.isNotEmpty) {
      throw StateError(
        'Missing required Firebase web dart-defines: ${missing.join(', ')}.',
      );
    }

    if (measurementId.isEmpty) {
      return const FirebaseOptions(
        apiKey: apiKey,
        appId: appId,
        messagingSenderId: messagingSenderId,
        projectId: projectId,
        authDomain: authDomain,
        storageBucket: storageBucket,
      );
    }

    return const FirebaseOptions(
      apiKey: apiKey,
      appId: appId,
      messagingSenderId: messagingSenderId,
      projectId: projectId,
      authDomain: authDomain,
      storageBucket: storageBucket,
      measurementId: measurementId,
    );
  }
}
