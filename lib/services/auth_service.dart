import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Authentication service encapsulating Firebase Auth and Google OAuth operations.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Stream listening to real-time authentication state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Returns the currently authenticated user or null
  User? get currentUser => _auth.currentUser;

  /// Signs in a user using email and password credentials
  Future<UserCredential> signIn(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } on FirebaseAuthException catch (e) {
      throw _getAuthErrorMessage(e.code);
    } catch (_) {
      throw 'An unexpected error occurred during sign-in. Please try again.';
    }
  }

  /// Registers a new user account with email and password
  Future<UserCredential> signUp(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } on FirebaseAuthException catch (e) {
      throw _getAuthErrorMessage(e.code);
    } catch (_) {
      throw 'An unexpected error occurred during registration. Please try again.';
    }
  }

  /// Initiates Google OAuth sign-in flow
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // Sign-in cancelled by user
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw _getAuthErrorMessage(e.code);
    } catch (e) {
      throw 'Google sign-in could not be completed: $e';
    }
  }

  /// Signs out the current user from both Google and Firebase sessions
  Future<void> signOut() async {
    try {
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }
    } catch (_) {
      // Ignore Google sign out errors if not signed in via Google
    }
    await _auth.signOut();
  }

  /// Maps Firebase Auth Exception codes to user-friendly status strings
  String _getAuthErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No user found registered with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-email':
        return 'The email address format is invalid.';
      case 'email-already-in-use':
        return 'An account already exists with this email address.';
      case 'weak-password':
        return 'Password should be at least 6 characters.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'invalid-credential':
        return 'Invalid credentials provided. Check your email and password.';
      default:
        return 'Authentication failed (${code.replaceAll('-', ' ')}).';
    }
  }
}
