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
      if (firebaseUser == null) return null;
      return _syncAndReadUser(firebaseUser);
    });
  }

  @override
  Future<void> signInWithGoogle() async {
    final googleAccount = await GoogleSignIn(scopes: const ['email']).signIn();
    if (googleAccount == null) return;

    final auth = await googleAccount.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: auth.accessToken,
      idToken: auth.idToken,
    );
    await _firebaseAuth.signInWithCredential(credential);
    final user = _firebaseAuth.currentUser;
    if (user != null) await _syncAndReadUser(user);
  }

  @override
  Future<void> signInWithApple() {
    throw UnsupportedError('Apple sign-in not configured.');
  }

  @override
  Future<void> signInWithEmail({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      } else {
        rethrow;
      }
    }
    final user = _firebaseAuth.currentUser;
    if (user != null) await _syncAndReadUser(user);
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await GoogleSignIn().signOut();
  }

  Future<AppUser> _syncAndReadUser(User firebaseUser) async {
    final ref = _firestore.collection('users').doc(firebaseUser.uid);
    final snap = await ref.get();

    if (!snap.exists || snap.data() == null) {
      final newUser = AppUser(
        uid: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        displayName: firebaseUser.displayName ?? _nameFromEmail(firebaseUser.email),
        role: UserRole.member,
        beltRank: BeltRank.white,
        waiverSigned: false,
      );
      await ref.set(newUser.toJson());
      return newUser;
    }

    final data = snap.data()!;
    return AppUser(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? data['email'] as String? ?? '',
      displayName: data['display_name'] as String? ?? _nameFromEmail(firebaseUser.email),
      role: _parseEnum(UserRole.values, data['role'] as String?, UserRole.member),
      beltRank: _parseEnum(BeltRank.values, data['belt_rank'] as String?, BeltRank.white),
      waiverSigned: data['waiver_signed'] as bool? ?? false,
      stripeCustomerId: data['stripe_customer_id'] as String?,
      membershipActive: data['membership_active'] as bool? ?? false,
    );
  }

  static String _nameFromEmail(String? email) {
    if (email == null || !email.contains('@')) return 'Member';
    return email.split('@').first;
  }

  static T _parseEnum<T extends Enum>(List<T> values, String? name, T fallback) {
    return values.where((v) => v.name == name).firstOrNull ?? fallback;
  }
}
