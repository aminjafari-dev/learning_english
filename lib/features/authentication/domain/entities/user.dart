// user.dart
// Entity representing a user in the authentication domain.
//
// Usage Example:
//   final user = User(id: '123', name: 'Ali', email: 'ali@email.com', photoUrl: '...');
//
// This entity is used throughout the domain and presentation layers.

import 'package:equatable/equatable.dart';

class User extends Equatable {
  /// Unique user ID (from Firebase)
  final String id;

  /// User's display name
  final String? name;

  /// User's email address
  final String? email;

  /// User's profile photo URL
  final String? photoUrl;

  const User({required this.id, this.name, this.email, this.photoUrl});

  @override
  List<Object?> get props => [id, name, email, photoUrl];
}
