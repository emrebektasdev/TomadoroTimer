import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

// A simple StateNotifier to hold the auth state
final authStateProvider = StateNotifierProvider<AuthStateNotifier, User?>((
  ref,
) {
  final authService = ref.watch(authServiceProvider);
  return AuthStateNotifier(authService);
});

class AuthStateNotifier extends StateNotifier<User?> {
  final AuthService _authService;
  late final StreamSubscription<User?> _subscription;

  AuthStateNotifier(this._authService)
    : super(FirebaseAuth.instance.currentUser) {
    _subscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (mounted) state = user;
    });
  }
  @override
  void dispose() {
    unawaited(_subscription.cancel());
    super.dispose();
  }

  Future<void> signInWithGoogle() async {
    try {
      await _authService.signInWithGoogle();
      // the authStateChanges listener will handle updating state and syncing
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }
}

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);

  AuthService();

  Future<User?> signInWithGoogle() async {
    try {
      // Step 1: Start Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('User canceled the login process');
      }

      // Step 2: Obtain auth details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      return userCredential.user;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
  }
}
