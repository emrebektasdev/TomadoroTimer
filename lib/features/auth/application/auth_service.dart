import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../data/auth_repository.dart';
import 'token_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final tokenService = ref.watch(tokenServiceProvider);
  return AuthService(authRepository, tokenService);
});

// A simple StateNotifier to hold the auth state
final authStateProvider = StateNotifierProvider<AuthStateNotifier, bool>((ref) {
  final authService = ref.watch(authServiceProvider);
  final tokenService = ref.watch(tokenServiceProvider);
  return AuthStateNotifier(authService, tokenService);
});

class AuthStateNotifier extends StateNotifier<bool> {
  final AuthService _authService;
  final TokenService _tokenService;

  AuthStateNotifier(this._authService, this._tokenService) : super(false) {
    _checkInitialAuth();
  }

  Future<void> _checkInitialAuth() async {
    final hasTokens = await _tokenService.hasTokens();
    if (hasTokens) {
      state = true;
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      await _authService.signInWithGoogle();
      // If success, user is logged in
      state = true;
    } catch (e) {
      // ignore: avoid_print
      print('Sign in failed: $e');
      state = false;
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    state = false;
  }
}

class AuthService {
  final AuthRepository _repository;
  final TokenService _tokenService;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    serverClientId:
        '39587895878-8dh4tvqo3ejorj3fudt2ln8qa8nt6dfo.apps.googleusercontent.com', // Web Client ID from backend
  );

  AuthService(this._repository, this._tokenService);

  Future<void> signInWithGoogle() async {
    try {
      // Step 1: Start Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('User canceled the login process');
      }

      // Step 2: Obtain auth details (ID Token)
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final idToken = googleAuth.idToken;

      if (idToken == null) {
        throw Exception('Failed to retrieve ID token from Google');
      }

      // Step 3: Send ID token to our backend
      final authData = await _repository.loginWithGoogle(idToken);

      final accessToken = authData['accessToken'];
      final refreshToken = authData['refreshToken'];

      // Securely store these tokens
      await _tokenService.saveTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );

      // ignore: avoid_print
      print('Login Success! AccessToken is saved.');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    // Clear tokens from secure storage
    await _tokenService.deleteTokens();
  }
}
