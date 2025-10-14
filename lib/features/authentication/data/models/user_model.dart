// user_model.dart
// Data model for user, used for mapping Google Sign-In user data and local storage.
// This model supports JSON serialization for Hive storage.
//
// Usage Example:
//   final userModel = UserModel.fromGoogleSignIn(googleUser);
//   final userModel = UserModel.fromJson(jsonMap);
//   final json = userModel.toJson();
//   final user = userModel.toEntity();
//
// This model is used in the data layer only.

import 'package:google_sign_in/google_sign_in.dart';
import '../../domain/entities/user.dart';

class UserModel {
  final String id;
  final String displayName;
  final String email;
  final String? photoUrl;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.displayName,
    required this.email,
    this.photoUrl,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Create UserModel from Google Sign-In User
  factory UserModel.fromGoogleSignIn(GoogleSignInAccount googleUser) {
    return UserModel(
      id: googleUser.id,
      displayName: googleUser.displayName ?? '',
      email: googleUser.email,
      photoUrl: googleUser.photoUrl,
      createdAt: DateTime.now(),
    );
  }

  /// Create UserModel from JSON (for Hive storage)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      displayName:
          json['displayName'] as String? ?? json['name'] as String? ?? '',
      email: json['email'] as String,
      photoUrl: json['photoUrl'] as String?,
      createdAt:
          json['createdAt'] != null
              ? DateTime.parse(json['createdAt'] as String)
              : DateTime.now(),
    );
  }

  /// Convert UserModel to JSON (for Hive storage)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'displayName': displayName,
      'name': displayName, // For backward compatibility
      'email': email,
      'photoUrl': photoUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Convert UserModel to domain User entity
  User toEntity() =>
      User(id: id, name: displayName, email: email, photoUrl: photoUrl);

  /// Create a copy of UserModel with updated fields
  UserModel copyWith({
    String? id,
    String? displayName,
    String? email,
    String? photoUrl,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
