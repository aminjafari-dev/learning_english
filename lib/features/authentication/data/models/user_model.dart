// user_model.dart
// Data model for user, used for mapping Google Sign-In user data.
//
// Usage Example:
//   final userModel = UserModel.fromGoogleSignIn(googleUser);
//   final user = userModel.toEntity();
//
// This model is used in the data layer only.

import 'package:google_sign_in/google_sign_in.dart';
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

  /// Convert UserModel to domain User entity
  User toEntity() => User(id: id, name: name, email: email, photoUrl: photoUrl);
}
