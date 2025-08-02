// daily_lessons_local_data_source.dart
// Main coordinator local data source for daily lessons feature using composition pattern.
// This class combines specialized data sources for learning requests, conversation threads, and analytics.
// Usage: Use this class as the main entry point for all daily lessons local data operations.

import 'package:learning_english/features/daily_lessons/data/models/level_type.dart';
import '../../models/learning_request_model.dart';
import '../../models/vocabulary_model.dart';
import '../../models/phrase_model.dart';
import '../../models/ai_provider_type.dart';
import '../../models/conversation_thread_model.dart';
import 'learning_requests_local_data_source.dart';
import 'conversation_threads_local_data_source.dart';
import 'analytics_local_data_source.dart';

/// Main coordinator local data source for daily lessons using composition pattern
/// This class delegates operations to specialized data sources for better maintainability
/// Usage: Use this as the main interface for all daily lessons local data operations
class DailyLessonsLocalDataSource {
  late LearningRequestsLocalDataSource _learningRequestsDataSource;
  late ConversationThreadsLocalDataSource _conversationThreadsDataSource;
  late AnalyticsLocalDataSource _analyticsDataSource;

  /// Initialize all specialized data sources
  /// This method should be called before using any other methods
  /// Example: await dataSource.initialize();
  Future<void> initialize() async {
    try {
      // Initialize learning requests data source
      _learningRequestsDataSource = LearningRequestsLocalDataSource();
      await _learningRequestsDataSource.initialize();

      // Initialize conversation threads data source
      _conversationThreadsDataSource = ConversationThreadsLocalDataSource();
      await _conversationThreadsDataSource.initialize();

      // Initialize analytics data source
      _analyticsDataSource = AnalyticsLocalDataSource();
      await _analyticsDataSource.initialize();
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

  /// Retrieves unused vocabulary for the current user
  /// Delegates to specialized learning requests data source
  /// Example: final unused = await dataSource.getUnusedVocabularies('user123');
  Future<List<VocabularyModel>> getUnusedVocabularies(String userId) async {
    return _learningRequestsDataSource.getUnusedVocabularies(userId);
  }

  /// Retrieves unused phrases for the current user
  /// Delegates to specialized learning requests data source
  /// Example: final unused = await dataSource.getUnusedPhrases('user123');
  Future<List<PhraseModel>> getUnusedPhrases(String userId) async {
    return _learningRequestsDataSource.getUnusedPhrases(userId);
  }

  /// Marks vocabulary as used for the current user
  /// Delegates to specialized learning requests data source
  /// Example: await dataSource.markVocabularyAsUsed('req123', 'hello');
  Future<void> markVocabularyAsUsed(String requestId, String english) async {
    return _learningRequestsDataSource.markVocabularyAsUsed(requestId, english);
  }

  /// Marks phrase as used for the current user
  /// Delegates to specialized learning requests data source
  /// Example: await dataSource.markPhraseAsUsed('req123', 'Good morning');
  Future<void> markPhraseAsUsed(String requestId, String english) async {
    return _learningRequestsDataSource.markPhraseAsUsed(requestId, english);
  }

  /// Retrieves request data by AI provider for analytics
  /// Delegates to specialized learning requests data source
  /// Example: final requests = await dataSource.getRequestsByProvider(AiProviderType.openai);
  Future<List<LearningRequestModel>> getRequestsByProvider(
    AiProviderType provider,
  ) async {
    return _learningRequestsDataSource.getRequestsByProvider(provider);
  }

  /// Clears all learning request data for the current user
  /// Delegates to specialized learning requests data source
  /// Example: await dataSource.clearUserData('user123');
  Future<void> clearUserData(String userId) async {
    return _learningRequestsDataSource.clearUserData(userId);
  }

  // ===== CONVERSATION THREAD DELEGATION =====

  /// Saves a conversation thread to Hive
  /// Delegates to specialized conversation threads data source
  /// Example: await dataSource.saveConversationThread(threadModel);
  Future<void> saveConversationThread(ConversationThreadModel thread) async {
    return _conversationThreadsDataSource.saveConversationThread(thread);
  }

  /// Retrieves all conversation threads for a specific user
  /// Delegates to specialized conversation threads data source
  /// Example: final threads = await dataSource.getUserConversationThreads('user123');
  Future<List<ConversationThreadModel>> getUserConversationThreads(
    String userId,
  ) async {
    return _conversationThreadsDataSource.getUserConversationThreads(userId);
  }

  /// Retrieves a specific conversation thread by ID
  /// Delegates to specialized conversation threads data source
  /// Example: final thread = await dataSource.getConversationThreadById('thread123');
  Future<ConversationThreadModel?> getConversationThreadById(
    String threadId,
  ) async {
    return _conversationThreadsDataSource.getConversationThreadById(threadId);
  }

  /// Updates a conversation thread with new messages
  /// Delegates to specialized conversation threads data source
  /// Example: await dataSource.updateConversationThread(updatedThread);
  Future<void> updateConversationThread(
    ConversationThreadModel updatedThread,
  ) async {
    return _conversationThreadsDataSource.updateConversationThread(
      updatedThread,
    );
  }

  /// Deletes a conversation thread
  /// Delegates to specialized conversation threads data source
  /// Example: await dataSource.deleteConversationThread('thread123');
  Future<void> deleteConversationThread(String threadId) async {
    return _conversationThreadsDataSource.deleteConversationThread(threadId);
  }

  /// Clears all conversation threads for a user
  /// Delegates to specialized conversation threads data source
  /// Example: await dataSource.clearUserConversationThreads('user123');
  Future<void> clearUserConversationThreads(String userId) async {
    return _conversationThreadsDataSource.clearUserConversationThreads(userId);
  }

  /// Find conversation thread by user preferences
  /// Delegates to specialized conversation threads data source
  /// Example: final thread = await dataSource.findThreadByPreferences('user123', UserLevel.intermediate, ['vocabulary']);
  Future<ConversationThreadModel?> findThreadByPreferences(
    String userId,
    UserLevel level,
    List<String> focusAreas,
  ) async {
    return _conversationThreadsDataSource.findThreadByPreferences(
      userId,
      level,
      focusAreas,
    );
  }

  /// Get all threads for a user with their preference descriptions
  /// Delegates to specialized conversation threads data source
  /// Example: final threadsInfo = await dataSource.getUserThreadsWithPreferences('user123');
  Future<List<Map<String, dynamic>>> getUserThreadsWithPreferences(
    String userId,
  ) async {
    return _conversationThreadsDataSource.getUserThreadsWithPreferences(userId);
  }

  /// Gets conversation analytics for a user
  /// Delegates to specialized conversation threads data source
  /// Example: final analytics = await dataSource.getConversationAnalytics('user123');
  Future<Map<String, dynamic>> getConversationAnalytics(String userId) async {
    return _conversationThreadsDataSource.getConversationAnalytics(userId);
  }

  // ===== ANALYTICS DELEGATION =====

  /// Gets comprehensive analytics data for the current user
  /// Delegates to specialized analytics data source
  /// Example: final analytics = await dataSource.getUserAnalytics('user123');
  Future<Map<String, dynamic>> getUserAnalytics(String userId) async {
    return _analyticsDataSource.getUserAnalytics(userId);
  }

  /// Gets learning progress analytics for a user
  /// Delegates to specialized analytics data source
  /// Example: final progress = await dataSource.getLearningProgressAnalytics('user123');
  Future<Map<String, dynamic>> getLearningProgressAnalytics(
    String userId,
  ) async {
    return _analyticsDataSource.getLearningProgressAnalytics(userId);
  }

  /// Closes all specialized data sources to free up resources
  /// Should be called when the main data source is no longer needed
  /// Example: await dataSource.dispose();
  Future<void> dispose() async {
    try {
      // Dispose all specialized data sources
      await _learningRequestsDataSource.dispose();
      await _conversationThreadsDataSource.dispose();
      await _analyticsDataSource.dispose();
    } catch (e) {
      throw Exception(
        'Failed to dispose daily lessons data sources: ${e.toString()}',
      );
    }
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
// // Conversation thread operations
// await localDataSource.saveConversationThread(threadModel);
// final threads = await localDataSource.getUserConversationThreads('user123');
// 
// // Analytics operations
// final analytics = await localDataSource.getUserAnalytics('user123');
// final progress = await localDataSource.getLearningProgressAnalytics('user123');
// 
// await localDataSource.dispose();
