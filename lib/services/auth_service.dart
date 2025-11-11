import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Firebase Authentication Service
/// Handles user authentication for VIP membership
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Check if user is signed in
  bool get isSignedIn => currentUser != null;

  // Get user ID
  String? get userId => currentUser?.uid;

  /// Sign in anonymously (for users who don't want to create account)
  /// This allows them to use the app and potentially upgrade to premium
  Future<UserCredential?> signInAnonymously() async {
    try {
      final result = await _auth.signInAnonymously();
      debugPrint('✅ Signed in anonymously: ${result.user?.uid}');
      return result;
    } catch (e) {
      debugPrint('❌ Error signing in anonymously: $e');
      return null;
    }
  }

  /// Sign in with email and password
  Future<UserCredential?> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      debugPrint('✅ Signed in with email: ${result.user?.email}');
      return result;
    } catch (e) {
      debugPrint('❌ Error signing in with email: $e');
      rethrow;
    }
  }

  /// Create account with email and password
  Future<UserCredential?> createAccountWithEmailPassword(
    String email,
    String password,
  ) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      debugPrint('✅ Created account: ${result.user?.email}');
      return result;
    } catch (e) {
      debugPrint('❌ Error creating account: $e');
      rethrow;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      debugPrint('✅ Signed out');
    } catch (e) {
      debugPrint('❌ Error signing out: $e');
    }
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      debugPrint('✅ Password reset email sent to: $email');
    } catch (e) {
      debugPrint('❌ Error sending password reset email: $e');
      rethrow;
    }
  }

  /// Delete account
  Future<void> deleteAccount() async {
    try {
      await currentUser?.delete();
      debugPrint('✅ Account deleted');
    } catch (e) {
      debugPrint('❌ Error deleting account: $e');
      rethrow;
    }
  }
}
