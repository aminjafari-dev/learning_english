// user_learning_focus.dart
// Entity representing a user's selected learning focus preferences.
//
// Usage Example:
//   final userFocus = UserLearningFocus(
//     userId: 'user123',
//     selectedFocuses: [LearningFocusType.business, LearningFocusType.travel],
//   );
//
// This entity stores the user's learning focus selections.

import 'package:equatable/equatable.dart';
import 'learning_focus.dart';

/// Entity representing a user's learning focus preferences
class UserLearningFocus extends Equatable {
  final String userId;
  final List<LearningFocusType> selectedFocuses;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserLearningFocus({
    required this.userId,
    required this.selectedFocuses,
    this.createdAt,
    this.updatedAt,
  });

  /// Creates a copy of this user learning focus with updated properties
  UserLearningFocus copyWith({
    String? userId,
    List<LearningFocusType>? selectedFocuses,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserLearningFocus(
      userId: userId ?? this.userId,
      selectedFocuses: selectedFocuses ?? this.selectedFocuses,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [userId, selectedFocuses, createdAt, updatedAt];
}
