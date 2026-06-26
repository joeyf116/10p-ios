import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FirebaseBootstrap {
  const FirebaseBootstrap._();

  static const FirebaseOptions _defaultWebOptions = FirebaseOptions(
    apiKey: 'AIzaSyD-ccFMsiUTTbOOS0ZbUcEAPDdHFLZNCyA',
    appId: '1:838540800529:web:7ed449e21bf3ca2decb7b0',
    messagingSenderId: '838540800529',
    projectId: 'p-ios-dece4',
    authDomain: 'p-ios-dece4.firebaseapp.com',
    storageBucket: 'p-ios-dece4.firebasestorage.app',
    measurementId: 'G-N99P57B521',
  );

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
      // Keep the app renderable on web even when dart-defines are absent.
      return _defaultWebOptions;
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
