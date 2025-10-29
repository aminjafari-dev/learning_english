// daily_lessons_local_data_source.dart
// Main coordinator local data source for daily lessons feature using composition pattern.
// This class combines specialized data sources for learning requests, conversation threads, and analytics.
// Usage: Use this class as the main entry point for all daily lessons local data operations.

import '../../models/learning_request_model.dart';
import '../../models/vocabulary_model.dart';
import '../../models/phrase_model.dart';
import 'learning_requests_local_data_source.dart';
import 'course_content_local_data_source.dart';

/// Main coordinator local data source for daily lessons using composition pattern
/// This class delegates operations to specialized data sources for better maintainability
/// Usage: Use this as the main interface for all daily lessons local data operations
class DailyLessonsLocalDataSource {
  late LearningRequestsLocalDataSource _learningRequestsDataSource;
  late CourseContentLocalDataSource _courseContentDataSource;

  /// Initialize all specialized data sources
  /// This method should be called before using any other methods
  /// Example: await dataSource.initialize();
  Future<void> initialize() async {
    try {
      // Initialize learning requests data source
      _learningRequestsDataSource = LearningRequestsLocalDataSource();
      await _learningRequestsDataSource.initialize();

      // Initialize course content data source
      _courseContentDataSource = CourseContentLocalDataSource();
      await _courseContentDataSource.initialize();
    } catch (e) {
      throw Exception(
        'Failed to initialize daily lessons data sources: ${e.toString()}',
      );
    }
  }

  // ===== LEARNING REQUESTS DELEGATION =====

  /// Saves complete learning request data
  /// Delegates to specialized learning requests data source
  /// Example: await dataSource.saveLearningRequest(requestModel);
  Future<void> saveLearningRequest(LearningRequestModel request) async {
    return _learningRequestsDataSource.saveLearningRequest(request);
  }

  /// Retrieves all learning requests for a specific user
  /// Delegates to specialized learning requests data source
  /// Example: final requests = await dataSource.getUserRequests('user123');
  Future<List<LearningRequestModel>> getUserRequests(String userId) async {
    return _learningRequestsDataSource.getUserRequests(userId);
  }

  /// Retrieves a specific learning request by ID
  /// Delegates to specialized learning requests data source
  /// Example: final request = await dataSource.getRequestById('req123');
  Future<LearningRequestModel?> getRequestById(String requestId) async {
    return _learningRequestsDataSource.getRequestById(requestId);
  }

  /// Retrieves all vocabulary from user's requests
  /// Delegates to specialized learning requests data source
  /// Example: final vocabularies = await dataSource.getUserVocabularies('user123');
  Future<List<VocabularyModel>> getUserVocabularies(String userId) async {
    return _learningRequestsDataSource.getUserVocabularies(userId);
  }

  /// Retrieves all phrases from user's requests
  /// Delegates to specialized learning requests data source
  /// Example: final phrases = await dataSource.getUserPhrases('user123');
  Future<List<PhraseModel>> getUserPhrases(String userId) async {
    return _learningRequestsDataSource.getUserPhrases(userId);
  }

  // ===== COURSE CONTENT DELEGATION =====

  /// Saves course content for a specific course
  /// Delegates to specialized course content data source
  /// Example: await dataSource.saveCourseContent(pathId, courseNumber, vocabularies, phrases);
  Future<void> saveCourseContent(
    String pathId,
    int courseNumber,
    List<VocabularyModel> vocabularies,
    List<PhraseModel> phrases,
  ) async {
    return _courseContentDataSource.saveCourseContent(
      pathId,
      courseNumber,
      vocabularies,
      phrases,
    );
  }

  /// Retrieves course content for a specific course
  /// Delegates to specialized course content data source
  /// Example: final content = await dataSource.getCourseContent(pathId, courseNumber);
  Future<LearningRequestModel?> getCourseContent(
    String pathId,
    int courseNumber,
  ) async {
    return _courseContentDataSource.getCourseContent(pathId, courseNumber);
  }

  /// Checks if course content exists for a specific course
  /// Delegates to specialized course content data source
  /// Example: final exists = await dataSource.hasCourseContent(pathId, courseNumber);
  Future<bool> hasCourseContent(String pathId, int courseNumber) async {
    return _courseContentDataSource.hasCourseContent(pathId, courseNumber);
  }

  /// Deletes course content for a specific course
  /// Delegates to specialized course content data source
  /// Example: await dataSource.deleteCourseContent(pathId, courseNumber);
  Future<void> deleteCourseContent(String pathId, int courseNumber) async {
    return _courseContentDataSource.deleteCourseContent(pathId, courseNumber);
  }

  /// Deletes all course content for a specific learning path
  /// Delegates to specialized course content data source
  /// Example: await dataSource.deletePathContent(pathId);
  Future<void> deletePathContent(String pathId) async {
    return _courseContentDataSource.deletePathContent(pathId);
  }

  /// Gets all course content for a specific learning path
  /// Delegates to specialized course content data source
  /// Example: final content = await dataSource.getPathContent(pathId);
  Future<Map<int, LearningRequestModel>> getPathContent(String pathId) async {
    return _courseContentDataSource.getPathContent(pathId);
  }
}

// Example usage:
// final localDataSource = DailyLessonsLocalDataSource();
// await localDataSource.initialize();
// 
// // Learning requests operations
// await localDataSource.saveLearningRequest(learningRequestModel);
// final userRequests = await localDataSource.getUserRequests('user123');
// 
// await localDataSource.dispose();
