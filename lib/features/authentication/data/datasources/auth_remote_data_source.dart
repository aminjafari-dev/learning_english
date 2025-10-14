// auth_remote_data_source.dart
// Remote data source for authentication using Google Sign-In with local Hive storage.
// This implementation no longer uses Supabase - instead it uses Google Sign-In
// and stores user data locally using Hive.
//
// Usage Example:
//   final userModel = await dataSource.signInWithGoogle();
//   final currentUser = await dataSource.getCurrentUser();
//
// This class integrates Google Sign-In with local Hive storage for user management.

import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:learning_english/core/error/failure.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  /// Signs in with Google and returns a UserModel.
  /// Throws ServerFailure on error.
  Future<UserModel> signInWithGoogle();

  /// Returns the currently signed-in user from local storage, or null if not signed in.
  /// Throws ServerFailure on error.
  Future<UserModel?> getCurrentUser();

  /// Signs out the current user from both Google and local storage.
  /// Throws ServerFailure on error.
  Future<void> signOut();
}

/// Implementation using Google Sign-In with local Hive storage
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final GoogleSignIn googleSignIn;
  final Box userBox;

  static const String _currentUserKey = 'current_user';

  /// IMPORTANT: Client IDs for different platforms
  /// These should match the Client IDs from Google Cloud Console
  static const String _iosClientId =
      '25836737324-3jqa1magg1tujgu57c59to8ho46nt4fr.apps.googleusercontent.com';
  static const String _androidClientId =
      '25836737324-p62t9me933469elag764l3tnvcd98ref.apps.googleusercontent.com';
  static const String _webClientId =
      '25836737324-k6hi5ppgsi923ve3n115to3pocdv771u.apps.googleusercontent.com';

  AuthRemoteDataSourceImpl({GoogleSignIn? googleSignIn, required this.userBox})
    : googleSignIn = googleSignIn ?? GoogleSignIn.instance;

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      // Initialize Google Sign-In with platform-specific client IDs
      await googleSignIn.initialize(
        clientId: _androidClientId,
        serverClientId: _webClientId,
      );

      // Authenticate with Google
      final googleUser = await googleSignIn.authenticate();

      if (googleUser == null) {
        throw ServerFailure('Google Sign-In was cancelled by user');
      }

      final googleAuth = googleUser.authentication;

      // Create user model from Google user data
      final userModel = UserModel(
        id: googleUser.id,
        email: googleUser.email ?? '',
        displayName: googleUser.displayName ?? '',
        photoUrl: googleUser.photoUrl,
        createdAt: DateTime.now(),
      );

      // Save user to local storage
      await userBox.put(_currentUserKey, userModel.toJson());

      print('User signed in successfully: ${userModel.email}');
      return userModel;
    } catch (e) {
      print('Google Sign-In failed: ${e.toString()}');
      throw ServerFailure('Google Sign-In failed: ${e.toString()}');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final userMap = userBox.get(_currentUserKey);
      if (userMap != null && userMap is Map) {
        return UserModel.fromJson(Map<String, dynamic>.from(userMap));
      }
      return null;
    } catch (e) {
      print('Failed to get current user: ${e.toString()}');
      throw ServerFailure('Failed to get current user: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      // Sign out from Google
      await googleSignIn.signOut();

      // Remove user from local storage
      await userBox.delete(_currentUserKey);

      print('User signed out successfully');
    } catch (e) {
      print('Sign out failed: ${e.toString()}');
      throw ServerFailure('Sign out failed: ${e.toString()}');
    }
  }
}
