// daily_lessons_local_data_source.dart
// Main coordinator local data source for daily lessons feature using composition pattern.
// This class combines specialized data sources for learning requests, conversation threads, and analytics.
// Usage: Use this class as the main entry point for all daily lessons local data operations.

import '../../models/learning_request_model.dart';
import '../../models/vocabulary_model.dart';
import '../../models/phrase_model.dart';
import 'learning_requests_local_data_source.dart';

/// Main coordinator local data source for daily lessons using composition pattern
/// This class delegates operations to specialized data sources for better maintainability
/// Usage: Use this as the main interface for all daily lessons local data operations
class DailyLessonsLocalDataSource {
  late LearningRequestsLocalDataSource _learningRequestsDataSource;

  /// Initialize all specialized data sources
  /// This method should be called before using any other methods
  /// Example: await dataSource.initialize();
  Future<void> initialize() async {
    try {
      // Initialize learning requests data source
      _learningRequestsDataSource = LearningRequestsLocalDataSource();
      await _learningRequestsDataSource.initialize();
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
