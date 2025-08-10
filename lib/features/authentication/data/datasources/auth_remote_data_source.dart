// auth_remote_data_source.dart
// Remote data source for authentication (Google Sign-In only).
//
// Usage Example:
//   final userModel = await dataSource.signInWithGoogle();
//
// This class is only used in the data layer.

import 'package:google_sign_in/google_sign_in.dart';
import 'package:learning_english/core/error/failure.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  /// Signs in with Google and returns a UserModel.
  /// Throws ServerFailure on error.
  Future<UserModel> signInWithGoogle();

  /// Returns the currently signed-in user, or null if not signed in.
  /// Throws ServerFailure on error.
  Future<UserModel?> getCurrentUser();

  /// Signs out the current user.
  /// Throws ServerFailure on error.
  Future<void> signOut();
}

/// Implementation using Google Sign-In only (without Firebase)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final GoogleSignIn googleSignIn;
  GoogleSignInAccount? _currentUser;

  /// IMPORTANT: The serverClientId (Web client ID) is required for Google Sign-In on Android.
  /// If you change your Google Cloud project, update the serverClientId below.
  /// See: https://console.cloud.google.com/apis/credentials
  static const String _serverClientId =
      '155679880321-bjnh1f85ut01o13crs2556b87erd0jnu.apps.googleusercontent.com';

  AuthRemoteDataSourceImpl({GoogleSignIn? googleSignIn})
    : googleSignIn = googleSignIn ?? GoogleSignIn.instance;

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      // Initialize Google Sign-In
      await googleSignIn.initialize(clientId: _serverClientId);

      // Attempt Google Sign-In
      final googleUser = await googleSignIn.authenticate();

      if (googleUser != null) {
        // Store the current user
        _currentUser = googleUser;
      } else {
        throw ServerFailure('Google Sign-In was cancelled or failed');
      }

      // Get authentication details
      final googleAuth = googleUser!.authentication;

      if (googleAuth.idToken == null) {
        throw ServerFailure('Failed to get authentication token from Google');
      }

      // Store current user
      _currentUser = googleUser;

      // Create UserModel from Google user data
      return UserModel.fromGoogleSignIn(googleUser);
    } on Exception catch (e) {
      // Handle all exceptions as ServerFailure
      throw ServerFailure('Google Sign-In failed: ${e.toString()}');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      // Check if user is signed in with Google
      final currentUser = _currentUser;
      if (currentUser != null) {
        return UserModel.fromGoogleSignIn(currentUser);
      }
      return null;
    } on Exception catch (e) {
      throw ServerFailure('Failed to get current user: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      // Sign out from Google Sign-In
      await googleSignIn.signOut();

      // Clear current user
      _currentUser = null;
    } on Exception catch (e) {
      throw ServerFailure('Sign out failed: ${e.toString()}');
    }
  }
}
