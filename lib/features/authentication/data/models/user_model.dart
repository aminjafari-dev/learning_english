// user_model.dart
// Data model for user, used for mapping Google Sign-In and Supabase user data.
//
// Usage Example:
//   final userModel = UserModel.fromGoogleSignIn(googleUser);
//   final userModel = UserModel.fromSupabaseUser(supabaseUser);
//   final user = userModel.toEntity();
//
// This model is used in the data layer only.

import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../../domain/entities/user.dart';

class UserModel {
  final String id;
  final String? name;
  final String? email;
  final String? photoUrl;

  UserModel({required this.id, this.name, this.email, this.photoUrl});

  /// Create UserModel from Google Sign-In User
  factory UserModel.fromGoogleSignIn(GoogleSignInAccount googleUser) {
    return UserModel(
      id: googleUser.id,
      name: googleUser.displayName,
      email: googleUser.email,
      photoUrl: googleUser.photoUrl,
    );
  }

  /// Create UserModel from Supabase User
  factory UserModel.fromSupabaseUser(supabase.User supabaseUser) {
    return UserModel(
      id: supabaseUser.id,
      name:
          supabaseUser.userMetadata?['full_name'] as String? ??
          supabaseUser.userMetadata?['name'] as String?,
      email: supabaseUser.email,
      photoUrl: supabaseUser.userMetadata?['avatar_url'] as String?,
    );
  }

  /// Convert UserModel to domain User entity
  User toEntity() => User(id: id, name: name, email: email, photoUrl: photoUrl);
}
