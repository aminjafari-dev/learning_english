// user_model.dart
// Data model for user, used for mapping Firebase user data.
//
// Usage Example:
//   final userModel = UserModel.fromFirebase(firebaseUser);
//   final user = userModel.toEntity();
//
// This model is used in the data layer only.

import '../../domain/entities/user.dart';

class UserModel {
  final String id;
  final String? name;
  final String? email;
  final String? photoUrl;

  UserModel({required this.id, this.name, this.email, this.photoUrl});

  /// Create UserModel from Firebase User (pseudo code, replace with actual FirebaseUser type)
  factory UserModel.fromFirebase(dynamic firebaseUser) {
    return UserModel(
      id: firebaseUser.uid,
      name: firebaseUser.displayName,
      email: firebaseUser.email,
      photoUrl: firebaseUser.photoURL,
    );
  }

  /// Convert UserModel to domain User entity
  User toEntity() => User(id: id, name: name, email: email, photoUrl: photoUrl);
}
