// daily_lessons_local_data_source.dart
// Local data source for storing and retrieving learning request data using Hive.
// This handles persistence of complete AI requests with all metadata and generated content.

import 'package:hive_flutter/hive_flutter.dart';
import '../../models/learning_request_model.dart';
import '../../models/vocabulary_model.dart';
import '../../models/phrase_model.dart';
import '../../models/ai_provider_type.dart';

/// Local data source for learning requests storage using Hive
/// Handles persistence of complete AI requests with all metadata and generated content
class DailyLessonsLocalDataSource {
  static const String _learningRequestsBoxName = 'learning_requests';

  late Box<LearningRequestModel> _learningRequestsBox;

  /// Initialize Hive boxes for learning request storage
  /// This method should be called before using any other methods
  Future<void> initialize() async {
    try {
      _learningRequestsBox = await Hive.openBox<LearningRequestModel>(
        _learningRequestsBoxName,
      );
    } catch (e) {
      throw Exception('Failed to initialize Hive boxes: ${e.toString()}');
    }
  }

  /// Saves complete learning request data
  /// Stores all request metadata and generated content
  Future<void> saveLearningRequest(LearningRequestModel request) async {
    try {
      // Use request ID as the key for easy retrieval and updates
      await _learningRequestsBox.put(request.requestId, request);
    } catch (e) {
      throw Exception('Failed to save learning request: ${e.toString()}');
    }
  }

  /// Retrieves all learning requests for a specific user
  /// Returns list of LearningRequestModel with complete metadata
  Future<List<LearningRequestModel>> getUserRequests(String userId) async {
    try {
      return _learningRequestsBox.values
          .where((request) => request.userId == userId)
          .toList();
    } catch (e) {
      throw Exception('Failed to get user requests: ${e.toString()}');
    }
  }

  /// Retrieves a specific learning request by ID
  /// Returns the complete request with all metadata and content
  Future<LearningRequestModel?> getRequestById(String requestId) async {
    try {
      return _learningRequestsBox.get(requestId);
    } catch (e) {
      throw Exception('Failed to get request by ID: ${e.toString()}');
    }
  }

  /// Retrieves all vocabulary from user's requests
  /// Returns flattened list of all vocabulary from all user requests
  Future<List<VocabularyModel>> getUserVocabularies(String userId) async {
    try {
      final userRequests = await getUserRequests(userId);
      final allVocabularies = <VocabularyModel>[];

      for (final request in userRequests) {
        allVocabularies.addAll(request.vocabularies);
      }

      return allVocabularies;
    } catch (e) {
      throw Exception('Failed to get user vocabularies: ${e.toString()}');
    }
  }

  /// Retrieves all phrases from user's requests
  /// Returns flattened list of all phrases from all user requests
  Future<List<PhraseModel>> getUserPhrases(String userId) async {
    try {
      final userRequests = await getUserRequests(userId);
      final allPhrases = <PhraseModel>[];

      for (final request in userRequests) {
        allPhrases.addAll(request.phrases);
      }

      return allPhrases;
    } catch (e) {
      throw Exception('Failed to get user phrases: ${e.toString()}');
    }
  }

  /// Retrieves unused vocabulary for the current user
  /// Used to avoid suggesting previously used content
  Future<List<VocabularyModel>> getUnusedVocabularies(String userId) async {
    try {
      final allVocabularies = await getUserVocabularies(userId);
      return allVocabularies.where((vocab) => !vocab.isUsed).toList();
    } catch (e) {
      throw Exception('Failed to get unused vocabularies: ${e.toString()}');
    }
  }

  /// Retrieves unused phrases for the current user
  /// Used to avoid suggesting previously used content
  Future<List<PhraseModel>> getUnusedPhrases(String userId) async {
    try {
      final allPhrases = await getUserPhrases(userId);
      return allPhrases.where((phrase) => !phrase.isUsed).toList();
    } catch (e) {
      throw Exception('Failed to get unused phrases: ${e.toString()}');
    }
  }

  /// Marks vocabulary as used for the current user
  /// Updates the usage status in the specific request
  Future<void> markVocabularyAsUsed(String requestId, String english) async {
    try {
      final request = _learningRequestsBox.get(requestId);
      if (request != null) {
        final updatedVocabularies =
            request.vocabularies.map((vocab) {
              if (vocab.english == english) {
                return vocab.copyWith(isUsed: true);
              }
              return vocab;
            }).toList();

        final updatedRequest = request.copyWith(
          vocabularies: updatedVocabularies,
        );
        await _learningRequestsBox.put(requestId, updatedRequest);
      }
    } catch (e) {
      throw Exception('Failed to mark vocabulary as used: ${e.toString()}');
    }
  }

  /// Marks phrase as used for the current user
  /// Updates the usage status in the specific request
  Future<void> markPhraseAsUsed(String requestId, String english) async {
    try {
      final request = _learningRequestsBox.get(requestId);
      if (request != null) {
        final updatedPhrases =
            request.phrases.map((phrase) {
              if (phrase.english == english) {
                return phrase.copyWith(isUsed: true);
              }
              return phrase;
            }).toList();

        final updatedRequest = request.copyWith(phrases: updatedPhrases);
        await _learningRequestsBox.put(requestId, updatedRequest);
      }
    } catch (e) {
      throw Exception('Failed to mark phrase as used: ${e.toString()}');
    }
  }

  /// Retrieves request data by AI provider for analytics
  /// Used for analyzing performance and cost by provider
  Future<List<LearningRequestModel>> getRequestsByProvider(
    AiProviderType provider,
  ) async {
    try {
      return _learningRequestsBox.values
          .where((request) => request.aiProvider == provider)
          .toList();
    } catch (e) {
      throw Exception('Failed to get requests by provider: ${e.toString()}');
    }
  }

  /// Clears all data for the current user
  /// Used when user wants to reset their learning progress
  Future<void> clearUserData(String userId) async {
    try {
      final userRequests = await getUserRequests(userId);
      for (final request in userRequests) {
        await _learningRequestsBox.delete(request.requestId);
      }
    } catch (e) {
      throw Exception('Failed to clear user data: ${e.toString()}');
    }
  }

  /// Gets analytics data for the current user
  /// Returns usage statistics and cost analysis
  Future<Map<String, dynamic>> getUserAnalytics(String userId) async {
    try {
      final userRequests =
          _learningRequestsBox.values
              .where((request) => request.userId == userId)
              .toList();

      final totalTokens = userRequests.fold<int>(
        0,
        (sum, request) => sum + request.totalTokensUsed,
      );

      final totalCost = userRequests.fold<double>(
        0,
        (sum, request) => sum + request.estimatedCost,
      );

      final providerStats = <String, Map<String, dynamic>>{};

      for (final provider in AiProviderType.values) {
        final providerRequests =
            userRequests
                .where((request) => request.aiProvider == provider)
                .toList();

        final providerTokens = providerRequests.fold<int>(
          0,
          (sum, request) => sum + request.totalTokensUsed,
        );

        final providerCost = providerRequests.fold<double>(
          0,
          (sum, request) => sum + request.estimatedCost,
        );

        final totalVocabularies = providerRequests.fold<int>(
          0,
          (sum, request) => sum + request.vocabularies.length,
        );

        final totalPhrases = providerRequests.fold<int>(
          0,
          (sum, request) => sum + request.phrases.length,
        );

        final usedVocabularies = providerRequests.fold<int>(
          0,
          (sum, request) =>
              sum + request.vocabularies.where((v) => v.isUsed).length,
        );

        final usedPhrases = providerRequests.fold<int>(
          0,
          (sum, request) => sum + request.phrases.where((p) => p.isUsed).length,
        );

        providerStats[provider.toString()] = {
          'requests': providerRequests.length,
          'vocabularies': totalVocabularies,
          'phrases': totalPhrases,
          'tokensUsed': providerTokens,
          'estimatedCost': providerCost,
          'usedVocabularies': usedVocabularies,
          'usedPhrases': usedPhrases,
        };
      }

      final totalVocabularies = userRequests.fold<int>(
        0,
        (sum, request) => sum + request.vocabularies.length,
      );

      final totalPhrases = userRequests.fold<int>(
        0,
        (sum, request) => sum + request.phrases.length,
      );

      final usedVocabularies = userRequests.fold<int>(
        0,
        (sum, request) =>
            sum + request.vocabularies.where((v) => v.isUsed).length,
      );

      final usedPhrases = userRequests.fold<int>(
        0,
        (sum, request) => sum + request.phrases.where((p) => p.isUsed).length,
      );

      return {
        'totalRequests': userRequests.length,
        'totalVocabularies': totalVocabularies,
        'totalPhrases': totalPhrases,
        'totalTokens': totalTokens,
        'totalCost': totalCost,
        'usedVocabularies': usedVocabularies,
        'usedPhrases': usedPhrases,
        'providerStats': providerStats,
      };
    } catch (e) {
      throw Exception('Failed to get user analytics: ${e.toString()}');
    }
  }

  /// Closes the Hive boxes to free up resources
  /// Should be called when the data source is no longer needed
  Future<void> dispose() async {
    try {
      await _learningRequestsBox.close();
    } catch (e) {
      throw Exception('Failed to dispose local data source: ${e.toString()}');
    }
  }
}

// Example usage:
// final localDataSource = DailyLessonsLocalDataSource();
// await localDataSource.initialize();
// await localDataSource.saveLearningRequest(learningRequestModel);
// final userRequests = await localDataSource.getUserRequests('user123');
// final analytics = await localDataSource.getUserAnalytics('user123');
// await localDataSource.dispose();
