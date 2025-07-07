// This file defines the UserProfile entity and Level enum for the level selection feature.
// Usage: Used in domain and data layers to represent user profile and selected level.
// Example:
//   final profile = UserProfile(id: 'user123', level: Level.beginner);

import 'package:equatable/equatable.dart';

/// Enum representing English proficiency levels
enum Level { beginner, elementary, intermediate, advanced }

/// Entity representing a user's profile
class UserProfile extends Equatable {
  final String id;
  final Level level;

  const UserProfile({required this.id, required this.level});

  @override
  List<Object?> get props => [id, level];
}
