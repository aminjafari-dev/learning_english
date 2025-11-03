// course_content_local_data_source.dart
// Local data source for storing individual course content using Hive.
// This class handles persistence of course-specific vocabularies and phrases.
// Usage: Use this class to store, retrieve, and manage course content data locally.

import 'package:hive_flutter/hive_flutter.dart';
import '../../models/learning_request_model.dart';
import '../../models/vocabulary_model.dart';
import '../../models/phrase_model.dart';
import '../../models/level_type.dart';
import '../../models/ai_provider_type.dart';

/// Local data source for course content storage using Hive
/// This class focuses on storing course-specific content to avoid regenerating the same content
/// Usage: Initialize once, then use methods to manage course content data
class CourseContentLocalDataSource {
  static const String _boxName = 'course_content';

  late Box<LearningRequestModel> _box;

  /// Initialize Hive box for course content storage
  /// This method should be called before using any other methods
  /// Example: await dataSource.initialize();
  Future<void> initialize() async {
    try {
      _box = await Hive.openBox<LearningRequestModel>(_boxName);
      print('✅ [COURSE_CONTENT] Hive box initialized: $_boxName');
    } catch (e) {
      throw Exception(
        'Failed to initialize course content box: ${e.toString()}',
      );
    }
  }

  /// Saves course content for a specific course in a learning path
  /// Stores vocabularies and phrases with course context
  /// Example: await dataSource.saveCourseContent(pathId, courseNumber, vocabularies, phrases);
  Future<void> saveCourseContent(
    String pathId,
    int courseNumber,
    List<VocabularyModel> vocabularies,
    List<PhraseModel> phrases,
  ) async {
    try {
      final courseKey = _getCourseKey(pathId, courseNumber);

      final courseContent = LearningRequestModel(
        requestId: courseKey,
        userId: 'current_user', // TODO: Replace with actual user ID
        userLevel: UserLevel.intermediate, // TODO: Get from user preferences
        focusAreas: ['general'], // TODO: Get from user preferences
        aiProvider:
            AiProviderType.gemini, // TODO: Get from actual provider used
        aiModel: 'gemini-1.5-flash', // TODO: Get from actual model used
        vocabularies: vocabularies,
        phrases: phrases,
        totalTokensUsed: 0, // TODO: Calculate actual tokens used
        estimatedCost: 0.0, // TODO: Calculate actual cost
        requestTimestamp: DateTime.now(),
        createdAt: DateTime.now(),
        systemPrompt:
            'Course content generation', // TODO: Get actual system prompt
        userPrompt: 'Generate course content', // TODO: Get actual user prompt
        metadata: {
          'source': 'course_content',
          'pathId': pathId,
          'courseNumber': courseNumber,
          'generatedAt': DateTime.now().toIso8601String(),
        },
      );

      await _box.put(courseKey, courseContent);
      print(
        '✅ [COURSE_CONTENT] Course content saved: $pathId - Course $courseNumber',
      );
    } catch (e) {
      throw Exception('Failed to save course content: ${e.toString()}');
    }
  }

  /// Retrieves course content for a specific course
  /// Returns the stored content if it exists, null otherwise
  /// Example: final content = await dataSource.getCourseContent(pathId, courseNumber);
  Future<LearningRequestModel?> getCourseContent(
    String pathId,
    int courseNumber,
  ) async {
    try {
      final courseKey = _getCourseKey(pathId, courseNumber);
      final content = _box.get(courseKey);

      if (content != null) {
        print(
          '✅ [COURSE_CONTENT] Course content found: $pathId - Course $courseNumber',
        );
      } else {
        print(
          'ℹ️ [COURSE_CONTENT] No course content found: $pathId - Course $courseNumber',
        );
      }

      return content;
    } catch (e) {
      throw Exception('Failed to get course content: ${e.toString()}');
    }
  }

  /// Checks if course content exists for a specific course
  /// Returns true if content exists, false otherwise
  /// Example: final exists = await dataSource.hasCourseContent(pathId, courseNumber);
  Future<bool> hasCourseContent(String pathId, int courseNumber) async {
    try {
      final courseKey = _getCourseKey(pathId, courseNumber);
      return _box.containsKey(courseKey);
    } catch (e) {
      throw Exception('Failed to check course content: ${e.toString()}');
    }
  }

  /// Deletes course content for a specific course
  /// Example: await dataSource.deleteCourseContent(pathId, courseNumber);
  Future<void> deleteCourseContent(String pathId, int courseNumber) async {
    try {
      final courseKey = _getCourseKey(pathId, courseNumber);
      await _box.delete(courseKey);
      print(
        '✅ [COURSE_CONTENT] Course content deleted: $pathId - Course $courseNumber',
      );
    } catch (e) {
      throw Exception('Failed to delete course content: ${e.toString()}');
    }
  }

  /// Deletes all course content for a specific learning path
  /// Example: await dataSource.deletePathContent(pathId);
  Future<void> deletePathContent(String pathId) async {
    try {
      final keysToDelete = <String>[];

      for (final key in _box.keys) {
        if (key.toString().startsWith('${pathId}_course_')) {
          keysToDelete.add(key.toString());
        }
      }

      for (final key in keysToDelete) {
        await _box.delete(key);
      }

      print(
        '✅ [COURSE_CONTENT] All course content deleted for path: $pathId (${keysToDelete.length} courses)',
      );
    } catch (e) {
      throw Exception('Failed to delete path content: ${e.toString()}');
    }
  }

  /// Gets all course content for a specific learning path
  /// Returns a map of course number to content
  /// Example: final content = await dataSource.getPathContent(pathId);
  Future<Map<int, LearningRequestModel>> getPathContent(String pathId) async {
    try {
      final content = <int, LearningRequestModel>{};

      for (final key in _box.keys) {
        final keyStr = key.toString();
        if (keyStr.startsWith('${pathId}_course_')) {
          final courseNumber = int.tryParse(keyStr.split('_').last);
          if (courseNumber != null) {
            final courseContent = _box.get(key);
            if (courseContent != null) {
              content[courseNumber] = courseContent;
            }
          }
        }
      }

      print(
        '✅ [COURSE_CONTENT] Retrieved ${content.length} courses for path: $pathId',
      );

      return content;
    } catch (e) {
      throw Exception('Failed to get path content: ${e.toString()}');
    }
  }

  /// Generates a unique key for course content storage
  /// Format: {pathId}_course_{courseNumber}
  String _getCourseKey(String pathId, int courseNumber) {
    return '${pathId}_course_$courseNumber';
  }

  /// Closes the Hive box to free up resources
  /// Should be called when the data source is no longer needed
  /// Example: await dataSource.dispose();
  Future<void> dispose() async {
    try {
      await _box.close();
      print('✅ [COURSE_CONTENT] Hive box closed');
    } catch (e) {
      throw Exception(
        'Failed to dispose course content data source: ${e.toString()}',
      );
    }
  }
}

// Example usage:
// final dataSource = CourseContentLocalDataSource();
// await dataSource.initialize();
// await dataSource.saveCourseContent('path123', 1, vocabularies, phrases);
// final content = await dataSource.getCourseContent('path123', 1);
// await dataSource.dispose();
