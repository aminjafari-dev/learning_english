/// VocabularyHistoryLocalDataSource handles local storage operations for vocabulary history.
/// This data source leverages the existing Hive storage from the daily lessons feature
/// to retrieve vocabulary and phrase data for history display.
/// Now uses the comprehensive LearningRequest structure for better data organization.
/// Reuses daily lessons models to avoid duplication.
///
/// Usage Example:
///   final dataSource = VocabularyHistoryLocalDataSource();
///   await dataSource.initialize();
///   final requests = await dataSource.getHistoryRequests();
///   final requestDetails = await dataSource.getRequestDetails('req_123');
///
/// This data source provides a clean interface for accessing stored learning data
/// and grouping it by request for history display.
import 'package:hive_flutter/hive_flutter.dart';
import '../../../domain/entities/vocabulary_history_item.dart';
import '../../../domain/entities/phrase_history_item.dart';
import '../../../domain/entities/history_request.dart';
// Import the daily lessons models to reuse them instead of duplicating
import '../../../../course/data/models/learning_request_model.dart';

/// Local data source for vocabulary history using Hive storage
/// Leverages existing daily lessons storage to provide history functionality
/// Now uses the comprehensive LearningRequest structure for better data organization
/// Reuses daily lessons models to avoid duplication
class VocabularyHistoryLocalDataSource {
  static const String _learningRequestsBoxName = 'learning_requests';

  late Box<LearningRequestModel> _learningRequestsBox;

  /// Initialize Hive boxes for learning request storage
  /// This method should be called before using any other methods
  /// Uses the same boxes as the daily lessons feature
  Future<void> initialize() async {
    try {
      _learningRequestsBox = await Hive.openBox<LearningRequestModel>(
        _learningRequestsBoxName,
      );
    } catch (e) {
      throw Exception('Failed to initialize Hive boxes: ${e.toString()}');
    }
  }

  /// Retrieves all history requests from local storage
  /// Converts stored LearningRequestModel data to domain entities for the history feature
  /// Reuses daily lessons models to avoid duplication
  Future<List<HistoryRequest>> getHistoryRequests() async {
    try {
      print('🔄 [HISTORY_DS] Getting all history requests from Hive...');
      final requests = <HistoryRequest>[];

      // Read the typed LearningRequestModel objects from Hive
      final allValues = _learningRequestsBox.values.toList();
      print(
        '🔄 [HISTORY_DS] Found ${allValues.length} learning requests in Hive',
      );

      for (final learningRequestModel in allValues) {
        print(
          '🔄 [HISTORY_DS] Processing request: ${learningRequestModel.requestId}',
        );

        // Convert LearningRequestModel to HistoryRequest
        // Reuse daily lessons models instead of creating duplicates
        final request = HistoryRequest(
          requestId: learningRequestModel.requestId,
          userId: learningRequestModel.userId,
          userLevel: learningRequestModel.userLevel,
          focusAreas: learningRequestModel.focusAreas,
          aiProvider: learningRequestModel.aiProvider,
          aiModel: learningRequestModel.aiModel,
          totalTokensUsed: learningRequestModel.totalTokensUsed,
          estimatedCost: learningRequestModel.estimatedCost,
          requestTimestamp: learningRequestModel.requestTimestamp,
          createdAt: learningRequestModel.createdAt,
          systemPrompt: learningRequestModel.systemPrompt,
          userPrompt: learningRequestModel.userPrompt,

          errorMessage: learningRequestModel.errorMessage,
          vocabularies:
              learningRequestModel.vocabularies
                  .map(
                    (v) => VocabularyHistoryItem(
                      english: v.english,
                      persian: v.persian,
                      isUsed: v.isUsed,
                    ),
                  )
                  .toList(),
          phrases:
              learningRequestModel.phrases
                  .map(
                    (p) => PhraseHistoryItem(
                      english: p.english,
                      persian: p.persian,
                      isUsed: p.isUsed,
                    ),
                  )
                  .toList(),
          metadata: learningRequestModel.metadata,
        );
        requests.add(request);
      }

      // Sort by creation date (newest first)
      requests.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      print(
        '🔄 [HISTORY_DS] Converted ${requests.length} requests to history items',
      );
      return requests;
    } catch (e) {
      print('❌ [HISTORY_DS] Error getting history requests: $e');
      throw Exception('Failed to get history requests: ${e.toString()}');
    }
  }

  /// Retrieves detailed information for a specific request
  /// Returns a complete HistoryRequest with all vocabularies and phrases
  /// Reuses daily lessons models to avoid duplication
  Future<HistoryRequest> getRequestDetails(String requestId) async {
    try {
      print('🔄 [HISTORY_DS] Getting details for request: $requestId');

      // Find the specific request in the box
      final learningRequestModel =
          _learningRequestsBox.values
              .where((model) => model.requestId == requestId)
              .firstOrNull;

      if (learningRequestModel == null) {
        throw Exception('Request not found: $requestId');
      }

      // Convert LearningRequestModel to HistoryRequest
      // Reuse daily lessons models instead of creating duplicates
      final request = HistoryRequest(
        requestId: learningRequestModel.requestId,
        userId: learningRequestModel.userId,
        userLevel: learningRequestModel.userLevel,
        focusAreas: learningRequestModel.focusAreas,
        aiProvider: learningRequestModel.aiProvider,
        aiModel: learningRequestModel.aiModel,
        totalTokensUsed: learningRequestModel.totalTokensUsed,
        estimatedCost: learningRequestModel.estimatedCost,
        requestTimestamp: learningRequestModel.requestTimestamp,
        createdAt: learningRequestModel.createdAt,
        systemPrompt: learningRequestModel.systemPrompt,
        userPrompt: learningRequestModel.userPrompt,

        errorMessage: learningRequestModel.errorMessage,
        vocabularies:
            learningRequestModel.vocabularies
                .map(
                  (v) => VocabularyHistoryItem(
                    english: v.english,
                    persian: v.persian,
                    isUsed: v.isUsed,
                  ),
                )
                .toList(),
        phrases:
            learningRequestModel.phrases
                .map(
                  (p) => PhraseHistoryItem(
                    english: p.english,
                    persian: p.persian,
                    isUsed: p.isUsed,
                  ),
                )
                .toList(),
        metadata: learningRequestModel.metadata,
      );

      print('✅ [HISTORY_DS] Retrieved details for request: $requestId');
      return request;
    } catch (e) {
      print('❌ [HISTORY_DS] Error getting request details: $e');
      throw Exception('Failed to get request details: ${e.toString()}');
    }
  }

  /// Retrieves all vocabulary history items from local storage
  /// Extracts vocabulary data from all learning requests
  /// Reuses daily lessons models to avoid duplication
  Future<List<VocabularyHistoryItem>> getAllVocabularies() async {
    try {
      print(
        '🔄 [HISTORY_DS] Getting all vocabularies from learning requests...',
      );
      final vocabularies = <VocabularyHistoryItem>[];

      // Read all learning requests and extract vocabularies
      final allRequests = _learningRequestsBox.values.toList();

      for (final learningRequestModel in allRequests) {
        for (final vocabularyModel in learningRequestModel.vocabularies) {
          final vocabulary = VocabularyHistoryItem(
            english: vocabularyModel.english,
            persian: vocabularyModel.persian,
            isUsed: vocabularyModel.isUsed,
          );
          vocabularies.add(vocabulary);
        }
      }

      print(
        '🔄 [HISTORY_DS] Extracted ${vocabularies.length} vocabularies from learning requests',
      );
      return vocabularies;
    } catch (e) {
      print('❌ [HISTORY_DS] Error getting vocabularies: $e');
      throw Exception('Failed to get vocabularies: ${e.toString()}');
    }
  }

  /// Retrieves all phrase history items from local storage
  /// Extracts phrase data from all learning requests
  /// Reuses daily lessons models to avoid duplication
  Future<List<PhraseHistoryItem>> getAllPhrases() async {
    try {
      print('🔄 [HISTORY_DS] Getting all phrases from learning requests...');
      final phrases = <PhraseHistoryItem>[];

      // Read all learning requests and extract phrases
      final allRequests = _learningRequestsBox.values.toList();

      for (final learningRequestModel in allRequests) {
        for (final phraseModel in learningRequestModel.phrases) {
          final phrase = PhraseHistoryItem(
            english: phraseModel.english,
            persian: phraseModel.persian,
            isUsed: phraseModel.isUsed,
          );
          phrases.add(phrase);
        }
      }

      print(
        '🔄 [HISTORY_DS] Extracted ${phrases.length} phrases from learning requests',
      );
      return phrases;
    } catch (e) {
      print('❌ [HISTORY_DS] Error getting phrases: $e');
      throw Exception('Failed to get phrases: ${e.toString()}');
    }
  }

  /// Closes the Hive boxes
  /// Should be called when the data source is no longer needed
  Future<void> close() async {
    try {
      await _learningRequestsBox.close();
      print('✅ [HISTORY_DS] Closed Hive boxes');
    } catch (e) {
      print('❌ [HISTORY_DS] Error closing Hive boxes: $e');
      throw Exception('Failed to close Hive boxes: ${e.toString()}');
    }
  }
}
