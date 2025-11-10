// lesson_prompts.dart
// Prompts for generating daily lessons using Gemini AI
// This file contains all prompt templates for lesson generation

import '../../../../learning_paths/domain/entities/learning_path.dart';

/// Prompts for lesson generation
/// Provides structured prompts based on learning path information (level, focus areas, and subcategory)
class LessonPrompts {
  /// Get lesson prompt based on learning path information
  /// Returns a structured prompt that generates vocabularies and phrases
  ///
  /// Parameters:
  /// - learningPath: Learning path containing level, focus areas, and subcategory
  /// - subCategoryOverride: Optional subcategory title override for more specific content
  /// - previousVocabularies: List of English vocabulary words used in previous courses of this learning path (to avoid duplicates)
  /// - previousPhrases: List of English phrases used in previous courses of this learning path (to avoid duplicates)
  ///
  /// Returns: Prompt string for AI generation
  static String getLessonPrompt(
    LearningPath learningPath, {
    String? subCategoryOverride,
    List<String> previousVocabularies = const [],
    List<String> previousPhrases = const [],
  }) {
    final level = _getLevelDescription(learningPath.level);
    final focusAreas = learningPath.focusAreas.join(', ');

    // Use subcategory from learning path or override if provided
    final subCategory = subCategoryOverride ?? learningPath.subCategory.title;
    final subCategoryContext =
        subCategory.isNotEmpty ? ' for the "$subCategory" subcategory' : '';

    // Build the exclusion section if there are previous vocabularies/phrases
    final exclusionSection = _buildExclusionSection(
      previousVocabularies,
      previousPhrases,
    );

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
3. Focus on topics: $focusAreas
4. Specifically tailor content for the "$subCategory" subcategory
5. Ensure all Persian translations are accurate and natural
6. Choose practical and commonly used words and phrases
7. Make sure the content is suitable for $level level learners
$exclusionSection

Return ONLY the JSON response without any additional text or explanation.
''';
  }

  /// Get course-specific lesson prompt
  /// Returns a structured prompt for course-specific content
  ///
  /// Parameters:
  /// - learningPath: Learning path containing level and focus areas
  /// - courseTitle: Title of the course
  /// - courseNumber: Number of the course
  /// - previousVocabularies: List of English vocabulary words used in previous courses of this learning path (to avoid duplicates)
  /// - previousPhrases: List of English phrases used in previous courses of this learning path (to avoid duplicates)
  ///
  /// Returns: Prompt string for AI generation
  static String getCourseLessonPrompt(
    LearningPath learningPath,
    String courseTitle,
    int courseNumber, {
    List<String> previousVocabularies = const [],
    List<String> previousPhrases = const [],
  }) {
    final level = _getLevelDescription(learningPath.level);
    final focusAreas = learningPath.focusAreas.join(', ');
    final subCategory = learningPath.subCategory.title;

    // Build the exclusion section if there are previous vocabularies/phrases
    final exclusionSection = _buildExclusionSection(
      previousVocabularies,
      previousPhrases,
    );

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
$exclusionSection

Return ONLY the JSON response without any additional text or explanation.
''';
  }

  /// Get level description string
  /// Converts Level enum to human-readable description
  ///
  /// Parameters:
  /// - level: User's English level from learning path
  ///
  /// Returns: Human-readable level description
  static String _getLevelDescription(dynamic level) {
    // Handle domain entity level (Level enum from learning_paths)
    final levelStr = level.toString();
    if (levelStr.contains('beginner')) return 'beginner';
    if (levelStr.contains('elementary')) return 'elementary';
    if (levelStr.contains('intermediate')) return 'intermediate';
    if (levelStr.contains('advanced')) return 'advanced';

    return 'intermediate'; // default
  }

  /// Builds the exclusion section for the prompt
  /// Creates instructions to avoid previously used vocabularies and phrases
  ///
  /// Parameters:
  /// - previousVocabularies: List of English vocabulary words to avoid
  /// - previousPhrases: List of English phrases to avoid
  ///
  /// Returns: Exclusion instructions string (empty if no previous content)
  static String _buildExclusionSection(
    List<String> previousVocabularies,
    List<String> previousPhrases,
  ) {
    // Only include exclusion section if there are previous vocabularies or phrases
    if (previousVocabularies.isEmpty && previousPhrases.isEmpty) {
      return '';
    }

    final buffer = StringBuffer();
    buffer.writeln();

    // Add vocabulary exclusion
    if (previousVocabularies.isNotEmpty) {
      final vocabList = previousVocabularies.join(', ');
      buffer.writeln(
        '10. AVOID using these vocabulary words that were already used in previous courses of this learning path: $vocabList',
      );
    }

    // Add phrase exclusion
    if (previousPhrases.isNotEmpty) {
      final phraseList = previousPhrases.join(', ');
      buffer.writeln(
        '11. AVOID using these phrases that were already used in previous courses of this learning path: $phraseList',
      );
    }

    buffer.writeln(
      '12. Generate completely NEW vocabulary words and phrases that are different from the ones listed above',
    );

    return buffer.toString();
  }
}
