import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../user/application/user_providers.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

// A simple StateNotifier to hold the auth state
final authStateProvider = StateNotifierProvider<AuthStateNotifier, User?>((
  ref,
) {
  final authService = ref.watch(authServiceProvider);
  final onAuthSuccess = () {
    ref.read(userNotifierProvider.notifier).syncWithBackend();
  };
  return AuthStateNotifier(authService, onAuthSuccess);
});

class AuthStateNotifier extends StateNotifier<User?> {
  final AuthService _authService;
  final void Function() _onAuthSuccess;

  AuthStateNotifier(this._authService, this._onAuthSuccess)
    : super(FirebaseAuth.instance.currentUser) {
    _checkInitialAuth();
  }

  void _checkInitialAuth() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      state = user;
      if (user != null) {
        _onAuthSuccess();
      }
    });
  }

  Future<void> signInWithGoogle() async {
    try {
      await _authService.signInWithGoogle();
      // the authStateChanges listener will handle updating state and syncing
    } catch (e) {
      print('Sign in failed: $e');
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

      print('Login Success with Firebase Auth!');
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
