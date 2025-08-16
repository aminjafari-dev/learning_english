// auth_remote_data_source.dart
// Remote data source for authentication using Supabase with Google Sign-In.
//
// Usage Example:
//   final userModel = await dataSource.signInWithGoogle();
//   final currentUser = await dataSource.getCurrentUser();
//
// This class integrates Google Sign-In with Supabase authentication for secure user management.

import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:learning_english/core/error/failure.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  /// Signs in with Google through Supabase and returns a UserModel.
  /// Throws ServerFailure on error.
  Future<UserModel> signInWithGoogle();

  /// Returns the currently signed-in user from Supabase, or null if not signed in.
  /// Throws ServerFailure on error.
  Future<UserModel?> getCurrentUser();

  /// Signs out the current user from both Google and Supabase.
  /// Throws ServerFailure on error.
  Future<void> signOut();
}

/// Implementation using Supabase authentication with Google Sign-In
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final GoogleSignIn googleSignIn;
  final SupabaseClient supabaseClient;

  /// IMPORTANT: The serverClientId (Web client ID) is required for Google Sign-In on Android.
  /// This should match the Client ID configured in your Supabase Google OAuth settings.
  /// See: https://console.cloud.google.com/apis/credentials
  static const String _serverClientId =
      '25836737324-k6hi5ppgsi923ve3n115to3pocdv771u.apps.googleusercontent.com';

  AuthRemoteDataSourceImpl({
    GoogleSignIn? googleSignIn,
    SupabaseClient? supabaseClient,
  }) : googleSignIn = googleSignIn ?? GoogleSignIn.instance,
       supabaseClient = supabaseClient ?? Supabase.instance.client;

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      await signIn();
    } catch (e) {
      print('Google Sign-In failed: ${e.toString()}');
      throw ServerFailure('Google Sign-In failed: ${e.toString()}');
    }
  }


  Future<void> signIn() async {
    String iosClientId =
        '25836737324-3jqa1magg1tujgu57c59to8ho46nt4fr.apps.googleusercontent.com';
    String androidClientId =
        '25836737324-p62t9me933469elag764l3tnvcd98ref.apps.googleusercontent.com';
    String webClientId =
        '25836737324-k6hi5ppgsi923ve3n115to3pocdv771u.apps.googleusercontent.com';

    await googleSignIn.initialize(
      clientId: androidClientId,
      serverClientId: webClientId,
    );
    final googleUser = await googleSignIn.authenticate();
    final googleAuth = googleUser.authentication;
    final idToken = googleAuth.idToken;

   final authResponse = await supabaseClient.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken ?? '',
    );
    print('authResponse: ${authResponse.user?.id}');
  }

  /// Listen to authentication state changes
  /// This can be used to react to sign-in/sign-out events
  Stream<UserModel?> get authStateChanges {
    return supabaseClient.auth.onAuthStateChange.map((data) {
      final user = data.session?.user;
      return user != null ? UserModel.fromSupabaseUser(user) : null;
    });
  }
  
  
  @override
  Future<void> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }
}
