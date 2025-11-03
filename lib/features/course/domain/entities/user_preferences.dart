// user_preferences.dart
// Entity representing user preferences for personalized content generation.
// This combines the user's English level and selected learning focus areas.
//
// Usage:
//   final preferences = UserPreferences(
//     level: Level.intermediate,
//     focusAreas: ['business', 'travel', 'social']
//   );
//   final prompt = AiPrompts.getPersonalizedVocabularyPrompt(preferences);

import 'package:equatable/equatable.dart';
import '../../data/models/level_type.dart';

/// Entity representing user preferences for personalized content generation
/// Combines English level and selected learning focus areas
class UserPreferences extends Equatable {
  final UserLevel level;
  final List<String> focusAreas;

  const UserPreferences({required this.level, required this.focusAreas});

  /// Creates UserPreferences with default values
  /// Used when user preferences are not available
  factory UserPreferences.defaultPreferences() {
    return const UserPreferences(
      level: UserLevel.intermediate,
      focusAreas: ['general'],
    );
  }

  /// Checks if user has specific focus areas selected
  bool hasFocusArea(String focusArea) {
    return focusAreas.contains(focusArea);
  }

  /// Gets a comma-separated string of focus areas for prompt generation
  String get focusAreasString {
    if (focusAreas.isEmpty) return 'general';
    return focusAreas.join(', ');
  }

  /// Gets level description for prompt generation
  String get levelDescription {
    switch (level) {
      case UserLevel.beginner:
        return 'beginner';
      case UserLevel.elementary:
        return 'elementary';
      case UserLevel.intermediate:
        return 'intermediate';
      case UserLevel.advanced:
        return 'advanced';
    }
  }

  /// Creates a copy of UserPreferences with updated fields
  UserPreferences copyWith({UserLevel? level, List<String>? focusAreas}) {
    return UserPreferences(
      level: level ?? this.level,
      focusAreas: focusAreas ?? this.focusAreas,
    );
  }

  @override
  List<Object?> get props => [level, focusAreas];

  @override
  String toString() {
    return 'UserPreferences(level: $level, focusAreas: $focusAreas)';
  }
}
