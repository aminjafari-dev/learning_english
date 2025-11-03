// lesson_prompts.dart
// Prompts for generating daily lessons using Gemini AI
// This file contains all prompt templates for lesson generation

import '../../../domain/entities/user_preferences.dart';
import '../../models/level_type.dart';

/// Prompts for lesson generation
/// Provides structured prompts based on user preferences (level and focus areas)
class LessonPrompts {
  /// Get lesson prompt based on user preferences
  /// Returns a structured prompt that generates vocabularies and phrases
  ///
  /// Parameters:
  /// - preferences: User preferences including level and focus areas
  /// - subCategory: Optional subcategory title for more specific content
  ///
  /// Returns: Prompt string for AI generation
  static String getLessonPrompt(
    UserPreferences preferences, {
    String? subCategory,
  }) {
    final level = _getLevelDescription(preferences.level);
    final focusAreas = preferences.focusAreas.join(', ');

    // Add subcategory context if provided
    final subCategoryContext =
        subCategory != null && subCategory.isNotEmpty
            ? ' for the "$subCategory" subcategory'
            : '';

    return '''
Generate a daily English lesson for a $level level learner focusing on: $focusAreas$subCategoryContext.

Create a JSON response with the following structure:
{
  "vocabularies": [
    {"english": "word", "persian": "معنی فارسی"},
    ...
  ],
  "phrases": [
    {"english": "phrase", "persian": "معنی فارسی عبارت"},
    ...
  ]
}

Requirements:
1. Generate 5 vocabulary words appropriate for $level level
2. Generate 5 useful phrases appropriate for $level level
3. Focus on topics: $focusAreas${subCategory != null && subCategory.isNotEmpty ? '\n4. Specifically tailor content for the "$subCategory" subcategory' : ''}
${subCategory != null && subCategory.isNotEmpty ? '5' : '4'}. Ensure all Persian translations are accurate and natural
${subCategory != null && subCategory.isNotEmpty ? '6' : '5'}. Choose practical and commonly used words and phrases
${subCategory != null && subCategory.isNotEmpty ? '7' : '6'}. Make sure the content is suitable for $level level learners

Return ONLY the JSON response without any additional text or explanation.
''';
  }

  /// Get course-specific lesson prompt
  /// Returns a structured prompt for course-specific content
  ///
  /// Parameters:
  /// - preferences: User preferences including level and focus areas
  /// - courseTitle: Title of the course
  /// - courseNumber: Number of the course
  /// - subCategory: Subcategory title for context
  ///
  /// Returns: Prompt string for AI generation
  static String getCourseLessonPrompt(
    UserPreferences preferences,
    String courseTitle,
    int courseNumber,
    String subCategory,
  ) {
    final level = _getLevelDescription(preferences.level);
    final focusAreas = preferences.focusAreas.join(', ');

    return '''
Generate a daily English lesson for Course $courseNumber: "$courseTitle" in the "$subCategory" subcategory for a $level level learner.

Create a JSON response with the following structure:
{
  "vocabularies": [
    {"english": "word", "persian": "معنی فارسی"},
    ...
  ],
  "phrases": [
    {"english": "phrase", "persian": "معنی فارسی عبارت"},
    ...
  ]
}

Requirements:
1. Generate 5 vocabulary words appropriate for $level level related to "$courseTitle"
2. Generate 5 useful phrases appropriate for $level level related to "$courseTitle"
3. Focus on the course theme: "$courseTitle"
4. Context: This lesson is part of the "$subCategory" subcategory learning path
5. Consider user's learning areas: $focusAreas
6. Ensure all Persian translations are accurate and natural
7. Choose practical and commonly used words and phrases relevant to the course and subcategory
8. Make sure the content is suitable for $level level learners
9. Content should be specific to Course $courseNumber in the "$subCategory" learning path

Return ONLY the JSON response without any additional text or explanation.
''';
  }

  /// Get level description string
  /// Converts UserLevel enum to human-readable description
  ///
  /// Parameters:
  /// - level: User's English level
  ///
  /// Returns: Human-readable level description
  static String _getLevelDescription(dynamic level) {
    if (level is UserLevel) {
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

    // Handle domain entity level (string representation)
    final levelStr = level.toString();
    if (levelStr.contains('beginner')) return 'beginner';
    if (levelStr.contains('elementary')) return 'elementary';
    if (levelStr.contains('intermediate')) return 'intermediate';
    if (levelStr.contains('advanced')) return 'advanced';

    return 'intermediate'; // default
  }
}

// Example usage:
// // General lesson prompt
// final prompt = LessonPrompts.getLessonPrompt(
//   UserPreferences(
//     level: UserLevel.intermediate,
//     focusAreas: ['business', 'technology'],
//   ),
// );
//
// // General lesson prompt with subcategory
// final promptWithSubCategory = LessonPrompts.getLessonPrompt(
//   UserPreferences(
//     level: UserLevel.intermediate,
//     focusAreas: ['business', 'technology'],
//   ),
//   subCategory: 'Business English for Professionals',
// );
//
// // Course-specific lesson prompt
// final coursePrompt = LessonPrompts.getCourseLessonPrompt(
//   UserPreferences(
//     level: UserLevel.intermediate,
//     focusAreas: ['business'],
//   ),
//   'Business Communication',
//   1,
//   'Business English for Professionals',
// );
