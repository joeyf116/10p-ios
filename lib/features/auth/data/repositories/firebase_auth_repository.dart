import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../domain/repositories/auth_repository.dart';
import '../models/app_user.dart';

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
  })  : _firebaseAuth = firebaseAuth,
        _firestore = firestore;

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  @override
  Stream<AppUser?> authStateChanges() {
    return _firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) {
        return null;
      }

      return _syncAndReadUser(firebaseUser);
    });
  }

  @override
  Future<void> signInWithApple() {
    throw UnsupportedError('Apple sign-in is not configured yet.');
  }

  @override
  Future<void> signInWithEmail(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (error) {
      if (error.code == 'user-not-found') {
        await _firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password);
      } else {
        rethrow;
      }
    }

    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser != null) {
      await _syncAndReadUser(firebaseUser);
    }
  }

  @override
  Future<void> signInWithGoogle() async {
    final googleAccount = await GoogleSignIn(scopes: const ['email']).signIn();
    if (googleAccount == null) {
      return;
    }

    final auth = await googleAccount.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: auth.accessToken,
      idToken: auth.idToken,
    );

    await _firebaseAuth.signInWithCredential(credential);

    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser != null) {
      await _syncAndReadUser(firebaseUser);
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await GoogleSignIn().signOut();
  }

  Future<AppUser> _syncAndReadUser(User firebaseUser) async {
    final documentRef = _firestore.collection('users').doc(firebaseUser.uid);
    final snapshot = await documentRef.get();

    if (!snapshot.exists) {
      final newUser = AppUser(
        uid: firebaseUser.uid,
        displayName:
            firebaseUser.displayName ?? _fallbackName(firebaseUser.email),
        role: UserRole.member,
        beltRank: BeltRank.white,
        waiverSigned: false,
      );
      await documentRef.set(newUser.toJson());
      return newUser;
    }

    final data = snapshot.data();
    if (data == null) {
      final repaired = AppUser(
        uid: firebaseUser.uid,
        displayName:
            firebaseUser.displayName ?? _fallbackName(firebaseUser.email),
        role: UserRole.member,
        beltRank: BeltRank.white,
        waiverSigned: false,
      );
      await documentRef.set(repaired.toJson());
      return repaired;
    }

    return AppUser(
      uid: firebaseUser.uid,
      displayName:
          data['display_name'] as String? ?? _fallbackName(firebaseUser.email),
      role: _parseUserRole(data['role'] as String?),
      beltRank: _parseBeltRank(data['belt_rank'] as String?),
      waiverSigned: data['waiver_signed'] as bool? ?? false,
      stripeCustomerId: data['stripe_customer_id'] as String?,
    );
  }

  static String _fallbackName(String? email) {
    if (email == null || !email.contains('@')) {
      return 'Member';
    }

    return email.split('@').first;
  }

  static UserRole _parseUserRole(String? value) {
    return UserRole.values.where((role) => role.name == value).firstOrNull ??
        UserRole.member;
  }

  static BeltRank _parseBeltRank(String? value) {
    return BeltRank.values.where((rank) => rank.name == value).firstOrNull ??
        BeltRank.white;
  }
}
