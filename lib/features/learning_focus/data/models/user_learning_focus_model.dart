// user_learning_focus_model.dart
// Data model for user learning focus that extends the domain entity.
//
// Usage Example:
//   final model = UserLearningFocusModel.fromJson(json);
//   final entity = model.toEntity();
//
// This model handles JSON serialization/deserialization for user learning focus data.

import '../../domain/entities/learning_focus.dart';
import '../../domain/entities/user_learning_focus.dart';

class UserLearningFocusModel extends UserLearningFocus {
  const UserLearningFocusModel({
    required super.userId,
    required super.selectedFocuses,
    super.createdAt,
    super.updatedAt,
  });

  /// Creates a UserLearningFocusModel from JSON
  factory UserLearningFocusModel.fromJson(Map<String, dynamic> json) {
    return UserLearningFocusModel(
      userId: json['userId'] as String,
      selectedFocuses: (json['selectedFocuses'] as List<dynamic>)
          .map((e) => LearningFocusType.values.firstWhere(
                (type) => type.toString().split('.').last == e,
              ))
          .toList(),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  /// Converts this model to JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'selectedFocuses': selectedFocuses
          .map((e) => e.toString().split('.').last)
          .toList(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Converts this model to domain entity
  UserLearningFocus toEntity() {
    return UserLearningFocus(
      userId: userId,
      selectedFocuses: selectedFocuses,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Creates a model from domain entity
  factory UserLearningFocusModel.fromEntity(UserLearningFocus entity) {
    return UserLearningFocusModel(
      userId: entity.userId,
      selectedFocuses: entity.selectedFocuses,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  /// Creates a model with updated timestamp
  UserLearningFocusModel withUpdatedTimestamp() {
    return UserLearningFocusModel(
      userId: userId,
      selectedFocuses: selectedFocuses,
      createdAt: createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}
