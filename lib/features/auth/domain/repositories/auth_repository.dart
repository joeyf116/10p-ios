import '../../data/models/app_user.dart';

abstract class AuthRepository {
  Stream<AppUser?> authStateChanges();
  Future<void> signInWithGoogle();
  Future<void> signInWithApple();
  Future<void> signInWithEmail({required String email, required String password});
  Future<void> signOut();
}
