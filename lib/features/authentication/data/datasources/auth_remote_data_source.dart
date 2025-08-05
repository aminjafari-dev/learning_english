// auth_remote_data_source.dart
// Remote data source for authentication (Firebase/Google Sign-In).
//
// Usage Example:
//   final userModel = await dataSource.signInWithGoogle();
//
// This class is only used in the data layer.

import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:learning_english/core/error/firebase_failure.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  /// Signs in with Google and returns a UserModel.
  /// Throws FirebaseAuthFailure, FirebaseNetworkFailure, or FirebaseRegionalFailure on error.
  Future<UserModel> signInWithGoogle();

  /// Returns the currently signed-in user, or null if not signed in.
  /// Throws FirebaseAuthFailure on error.
  Future<UserModel?> getCurrentUser();

  /// Signs out the current user.
  /// Throws FirebaseAuthFailure on error.
  Future<void> signOut();
}

/// Implementation using Firebase/Google Sign-In with comprehensive error handling
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final fb_auth.FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;

  /// IMPORTANT: The serverClientId (Web client ID) is required for Google Sign-In on Android.
  /// If you change your Google Cloud project, update the serverClientId below.
  /// See: https://console.cloud.google.com/apis/credentials
  static const String _serverClientId =
      '155679880321-bjnh1f85ut01o13crs2556b87erd0jnu.apps.googleusercontent.com';

  AuthRemoteDataSourceImpl({
    fb_auth.FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  }) : firebaseAuth = firebaseAuth ?? fb_auth.FirebaseAuth.instance,
       // Use GoogleSignIn.instance because the constructor is not public in this version.
       // The serverClientId is set via google-services.json.
       googleSignIn = googleSignIn ?? GoogleSignIn.instance;

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      // Initialize Google Sign-In
      await googleSignIn.initialize(clientId: _serverClientId);

      // Attempt Google Sign-In
      final googleUser = await googleSignIn.authenticate();

      if (googleUser == null) {
        throw FirebaseAuthFailure(
          'Google Sign-In was cancelled or failed',
          code: 'google-signin-cancelled',
          details: 'User cancelled the Google Sign-In process',
        );
      }

      // Get authentication details
      final googleAuth = googleUser.authentication;

      if (googleAuth.idToken == null) {
        throw FirebaseAuthFailure(
          'Failed to get authentication token from Google',
          code: 'google-auth-token-failed',
          details: 'Google authentication did not provide a valid ID token',
        );
      }

      // Create Firebase credential
      final credential = fb_auth.GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with Google credential
      final userCredential = await firebaseAuth.signInWithCredential(
        credential,
      );

      if (userCredential.user == null) {
        throw FirebaseAuthFailure(
          'Firebase authentication failed - no user returned',
          code: 'firebase-auth-failed',
          details:
              'Firebase did not return a valid user after Google authentication',
        );
      }

      return UserModel.fromFirebase(userCredential.user!);
    } on fb_auth.FirebaseAuthException catch (e) {
      // Handle Firebase Auth specific errors
      throw FirebaseAuthFailure.fromException(e);
    } on Exception catch (e) {
      // Handle network and regional restrictions
      final errorMessage = e.toString().toLowerCase();

      if (errorMessage.contains('network') ||
          errorMessage.contains('connection') ||
          errorMessage.contains('timeout')) {
        throw FirebaseNetworkFailure.forNetworkError(
          'Network error during Google Sign-In: ${e.toString()}',
          null,
        );
      }

      if (errorMessage.contains('iran') ||
          errorMessage.contains('regional') ||
          errorMessage.contains('restricted') ||
          errorMessage.contains('blocked')) {
        throw FirebaseRegionalFailure.forRegion(
          'Unknown',
          'authentication',
          e.toString(),
        );
      }

      // Handle Google Sign-In specific errors
      if (errorMessage.contains('popup') ||
          errorMessage.contains('cancelled')) {
        throw FirebaseAuthFailure(
          'Google Sign-In was cancelled or popup was blocked',
          code: 'google-signin-cancelled',
          details: e.toString(),
          originalError: e,
        );
      }

      // Generic error fallback
      throw FirebaseGenericFailure(
        'Google Sign-In failed: ${e.toString()}',
        code: 'google-signin-error',
        details: e.toString(),
        originalError: e,
      );
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = firebaseAuth.currentUser;
      return user != null ? UserModel.fromFirebase(user) : null;
    } on fb_auth.FirebaseAuthException catch (e) {
      // Handle Firebase Auth specific errors when getting current user
      throw FirebaseAuthFailure.fromException(e);
    } on Exception catch (e) {
      // Handle other errors
      final errorMessage = e.toString().toLowerCase();

      if (errorMessage.contains('network') ||
          errorMessage.contains('connection')) {
        throw FirebaseNetworkFailure.forNetworkError(
          'Network error while getting current user: ${e.toString()}',
          null,
        );
      }

      throw FirebaseGenericFailure(
        'Failed to get current user: ${e.toString()}',
        code: 'get-current-user-error',
        details: e.toString(),
        originalError: e,
      );
    }
  }

  @override
  Future<void> signOut() async {
    try {
      // Sign out from Firebase
      await firebaseAuth.signOut();

      // Sign out from Google Sign-In
      await googleSignIn.signOut();
    } on fb_auth.FirebaseAuthException catch (e) {
      // Handle Firebase Auth specific errors during sign out
      throw FirebaseAuthFailure.fromException(e);
    } on Exception catch (e) {
      // Handle other errors during sign out
      final errorMessage = e.toString().toLowerCase();

      if (errorMessage.contains('network') ||
          errorMessage.contains('connection')) {
        throw FirebaseNetworkFailure.forNetworkError(
          'Network error during sign out: ${e.toString()}',
          null,
        );
      }

      throw FirebaseGenericFailure(
        'Sign out failed: ${e.toString()}',
        code: 'signout-error',
        details: e.toString(),
        originalError: e,
      );
    }
  }
}
