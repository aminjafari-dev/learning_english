// learning_requests_local_data_source.dart
// Specialized local data source for managing learning request CRUD operations using Hive.
// This class handles persistence of complete AI requests with all metadata and generated content.
// Usage: Use this class to store, retrieve, and manage learning request data locally.

import 'package:hive_flutter/hive_flutter.dart';
import '../../models/learning_request_model.dart';
import '../../models/vocabulary_model.dart';
import '../../models/phrase_model.dart';
import '../../models/ai_provider_type.dart';

/// Specialized local data source for learning requests storage using Hive
/// This class focuses solely on learning request CRUD operations
/// Usage: Initialize once, then use methods to manage learning request data
class LearningRequestsLocalDataSource {
  static const String _boxName = 'learning_requests';

  late Box<LearningRequestModel> _box;

  /// Initialize Hive box for learning request storage
  /// This method should be called before using any other methods
  /// Example: await dataSource.initialize();
  Future<void> initialize() async {
    try {
      _box = await Hive.openBox<LearningRequestModel>(_boxName);
    } catch (e) {
      throw Exception(
        'Failed to initialize learning requests box: ${e.toString()}',
      );
    }
  }

  /// Saves complete learning request data
  /// Stores all request metadata and generated content using request ID as key
  /// Example: await dataSource.saveLearningRequest(requestModel);
  Future<void> saveLearningRequest(LearningRequestModel request) async {
    try {
      // Use request ID as the key for easy retrieval and updates
      await _box.put(request.requestId, request);
    } catch (e) {
      throw Exception('Failed to save learning request: ${e.toString()}');
    }
  }

  /// Retrieves all learning requests for a specific user
  /// Returns list of LearningRequestModel with complete metadata
  /// Example: final requests = await dataSource.getUserRequests('user123');
  Future<List<LearningRequestModel>> getUserRequests(String userId) async {
    try {
      return _box.values.where((request) => request.userId == userId).toList();
    } catch (e) {
      throw Exception('Failed to get user requests: ${e.toString()}');
    }
  }

  /// Retrieves a specific learning request by ID
  /// Returns the complete request with all metadata and content
  /// Example: final request = await dataSource.getRequestById('req123');
  Future<LearningRequestModel?> getRequestById(String requestId) async {
    try {
      return _box.get(requestId);
    } catch (e) {
      throw Exception('Failed to get request by ID: ${e.toString()}');
    }
  }

  /// Retrieves all vocabulary from user's requests
  /// Returns flattened list of all vocabulary from all user requests
  /// Example: final vocabularies = await dataSource.getUserVocabularies('user123');
  Future<List<VocabularyModel>> getUserVocabularies(String userId) async {
    try {
      final userRequests = await getUserRequests(userId);
      final allVocabularies = <VocabularyModel>[];

      // Flatten vocabulary from all user requests
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
  /// Example: final phrases = await dataSource.getUserPhrases('user123');
  Future<List<PhraseModel>> getUserPhrases(String userId) async {
    try {
      final userRequests = await getUserRequests(userId);
      final allPhrases = <PhraseModel>[];

      // Flatten phrases from all user requests
      for (final request in userRequests) {
        allPhrases.addAll(request.phrases);
      }

      return allPhrases;
    } catch (e) {
      throw Exception('Failed to get user phrases: ${e.toString()}');
    }
  }

  /// Retrieves unused vocabulary for the current user
  /// Used to avoid suggesting previously used content in new lessons
  /// Example: final unused = await dataSource.getUnusedVocabularies('user123');
  Future<List<VocabularyModel>> getUnusedVocabularies(String userId) async {
    try {
      final allVocabularies = await getUserVocabularies(userId);
      return allVocabularies.where((vocab) => !vocab.isUsed).toList();
    } catch (e) {
      throw Exception('Failed to get unused vocabularies: ${e.toString()}');
    }
  }

  /// Retrieves unused phrases for the current user
  /// Used to avoid suggesting previously used content in new lessons
  /// Example: final unused = await dataSource.getUnusedPhrases('user123');
  Future<List<PhraseModel>> getUnusedPhrases(String userId) async {
    try {
      final allPhrases = await getUserPhrases(userId);
      return allPhrases.where((phrase) => !phrase.isUsed).toList();
    } catch (e) {
      throw Exception('Failed to get unused phrases: ${e.toString()}');
    }
  }

  /// Marks vocabulary as used for the current user
  /// Updates the usage status in the specific request to track learning progress
  /// Example: await dataSource.markVocabularyAsUsed('req123', 'hello');
  Future<void> markVocabularyAsUsed(String requestId, String english) async {
    try {
      final request = _box.get(requestId);
      if (request != null) {
        // Update vocabulary usage status
        final updatedVocabularies =
            request.vocabularies.map((vocab) {
              if (vocab.english == english) {
                return vocab.copyWith(isUsed: true);
              }
              return vocab;
            }).toList();

        // Save updated request with new vocabulary status
        final updatedRequest = request.copyWith(
          vocabularies: updatedVocabularies,
        );
        await _box.put(requestId, updatedRequest);
      }
    } catch (e) {
      throw Exception('Failed to mark vocabulary as used: ${e.toString()}');
    }
  }

  /// Marks phrase as used for the current user
  /// Updates the usage status in the specific request to track learning progress
  /// Example: await dataSource.markPhraseAsUsed('req123', 'Good morning');
  Future<void> markPhraseAsUsed(String requestId, String english) async {
    try {
      final request = _box.get(requestId);
      if (request != null) {
        // Update phrase usage status
        final updatedPhrases =
            request.phrases.map((phrase) {
              if (phrase.english == english) {
                return phrase.copyWith(isUsed: true);
              }
              return phrase;
            }).toList();

        // Save updated request with new phrase status
        final updatedRequest = request.copyWith(phrases: updatedPhrases);
        await _box.put(requestId, updatedRequest);
      }
    } catch (e) {
      throw Exception('Failed to mark phrase as used: ${e.toString()}');
    }
  }

  /// Retrieves request data by AI provider for analytics
  /// Used for analyzing performance and cost by specific AI provider
  /// Example: final requests = await dataSource.getRequestsByProvider(AiProviderType.openai);
  Future<List<LearningRequestModel>> getRequestsByProvider(
    AiProviderType provider,
  ) async {
    try {
      return _box.values
          .where((request) => request.aiProvider == provider)
          .toList();
    } catch (e) {
      throw Exception('Failed to get requests by provider: ${e.toString()}');
    }
  }

  /// Clears all learning request data for the current user
  /// Used when user wants to reset their learning progress completely
  /// Example: await dataSource.clearUserData('user123');
  Future<void> clearUserData(String userId) async {
    try {
      final userRequests = await getUserRequests(userId);
      // Delete each user request from storage
      for (final request in userRequests) {
        await _box.delete(request.requestId);
      }
    } catch (e) {
      throw Exception('Failed to clear user data: ${e.toString()}');
    }
  }

  /// Closes the Hive box to free up resources
  /// Should be called when the data source is no longer needed
  /// Example: await dataSource.dispose();
  Future<void> dispose() async {
    try {
      await _box.close();
    } catch (e) {
      throw Exception(
        'Failed to dispose learning requests data source: ${e.toString()}',
      );
    }
  }
}

// Example usage:
// final dataSource = LearningRequestsLocalDataSource();
// await dataSource.initialize();
// await dataSource.saveLearningRequest(learningRequestModel);
// final userRequests = await dataSource.getUserRequests('user123');
// await dataSource.dispose();
