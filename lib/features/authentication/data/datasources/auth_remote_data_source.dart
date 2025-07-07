// auth_remote_data_source.dart
// Remote data source for authentication (Firebase/Google Sign-In).
//
// Usage Example:
//   final userModel = await dataSource.signInWithGoogle();
//
// This class is only used in the data layer.

import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  /// Signs in with Google and returns a UserModel.
  Future<UserModel> signInWithGoogle();

  /// Returns the currently signed-in user, or null if not signed in.
  Future<UserModel?> getCurrentUser();

  /// Signs out the current user.
  Future<void> signOut();
}

/// Implementation using Firebase/Google Sign-In (pseudo code)
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
    await googleSignIn.initialize(clientId: _serverClientId);
    final googleUser = await googleSignIn.authenticate();
    final googleAuth = googleUser.authentication;
    final credential = fb_auth.GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );
    final userCredential = await firebaseAuth.signInWithCredential(credential);
    if (userCredential.user == null) throw Exception('No user returned');
    return UserModel.fromFirebase(userCredential.user!);
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = firebaseAuth.currentUser;
    return user != null ? UserModel.fromFirebase(user) : null;
  }

  @override
  Future<void> signOut() async {
    await firebaseAuth.signOut();
    await googleSignIn.signOut();
  }
}
