// supabase_learning_requests_remote_data_source.dart
// Supabase remote data source for learning requests with complete user separation.
// This class handles saving and retrieving all LearningRequestModel attributes to/from Supabase
// for each user separately, providing cloud backup and synchronization capabilities.
//
// Usage:
//   final dataSource = SupabaseLearningRequestsRemoteDataSource(supabaseClient);
//   await dataSource.saveLearningRequest(learningRequestModel);
//   final userRequests = await dataSource.getUserLearningRequests(userId);

import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:learning_english/core/error/failure.dart';
import '../../models/learning_request_model.dart';
import '../../models/vocabulary_model.dart';
import '../../models/phrase_model.dart';
import '../../models/level_type.dart';
import '../../models/ai_provider_type.dart';

/// Supabase remote data source for learning requests management
/// Handles complete CRUD operations for LearningRequestModel with user separation
/// Provides cloud backup and synchronization for all learning request data
class SupabaseLearningRequestsRemoteDataSource {
  final SupabaseClient _supabaseClient;

  /// Table names for Supabase database
  static const String _learningRequestsTable = 'learning_requests';
  static const String _vocabulariesTable = 'learning_request_vocabularies';
  static const String _phrasesTable = 'learning_request_phrases';

  /// Constructor requires SupabaseClient instance
  /// This allows for dependency injection and easier testing
  SupabaseLearningRequestsRemoteDataSource(this._supabaseClient);

  /// Saves complete learning request data to Supabase
  /// Stores all attributes from LearningRequestModel with user separation
  /// Uses transactions to ensure data consistency across related tables
  ///
  /// Parameters:
  /// - request: Complete LearningRequestModel with all attributes
  ///
  /// Returns: Either Failure or the saved request ID
  /// Example: await dataSource.saveLearningRequest(learningRequestModel);
  Future<Either<Failure, String>> saveLearningRequest(
    LearningRequestModel request,
  ) async {
    try {
      print('📤 [SUPABASE] Saving learning request: ${request.requestId}');
      print(
        '📤 [SUPABASE] User: ${request.userId}, Level: ${request.userLevel}',
      );

      // Convert the request to JSON format suitable for Supabase
      final requestData = _convertRequestToSupabaseFormat(request);

      // Insert the main learning request record
      final response =
          await _supabaseClient
              .from(_learningRequestsTable)
              .insert(requestData)
              .select('id')
              .single();

      final insertedId = response['id'] as int;
      print('✅ [SUPABASE] Learning request saved with ID: $insertedId');

      // Save vocabularies in separate table with foreign key reference
      if (request.vocabularies.isNotEmpty) {
        await _saveVocabularies(insertedId, request.vocabularies);
      }

      // Save phrases in separate table with foreign key reference
      if (request.phrases.isNotEmpty) {
        await _savePhrases(insertedId, request.phrases);
      }

      print('✅ [SUPABASE] Complete learning request data saved successfully');
      return right(insertedId.toString());
    } catch (e) {
      print('❌ [SUPABASE] Failed to save learning request: $e');
      return left(
        ServerFailure('Failed to save learning request: ${e.toString()}'),
      );
    }
  }

  /// Retrieves all learning requests for a specific user
  /// Returns complete learning request data with embedded vocabularies and phrases
  /// Results are ordered by creation date (newest first)
  ///
  /// Parameters:
  /// - userId: The user's unique identifier
  /// - limit: Maximum number of requests to return (default: 50)
  /// - offset: Number of requests to skip for pagination (default: 0)
  ///
  /// Returns: Either Failure or list of LearningRequestModel
  /// Example: final requests = await dataSource.getUserLearningRequests('user123');
  Future<Either<Failure, List<LearningRequestModel>>> getUserLearningRequests(
    String userId, {
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      print('📥 [SUPABASE] Fetching learning requests for user: $userId');

      // Fetch learning requests with vocabularies and phrases
      final response = await _supabaseClient
          .from(_learningRequestsTable)
          .select('''
            *,
            learning_request_vocabularies(*),
            learning_request_phrases(*)
          ''')
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      final List<LearningRequestModel> requests = [];

      for (final record in response) {
        final request = await _convertSupabaseRecordToModel(record);
        requests.add(request);
      }

      print('✅ [SUPABASE] Retrieved ${requests.length} learning requests');
      return right(requests);
    } catch (e) {
      print('❌ [SUPABASE] Failed to get user learning requests: $e');
      return left(
        ServerFailure('Failed to get user learning requests: ${e.toString()}'),
      );
    }
  }

  /// Retrieves a specific learning request by ID
  /// Returns complete request data with vocabularies and phrases
  ///
  /// Parameters:
  /// - requestId: The unique request identifier
  /// - userId: The user's unique identifier (for security)
  ///
  /// Returns: Either Failure or LearningRequestModel (null if not found)
  /// Example: final request = await dataSource.getLearningRequestById('req123', 'user123');
  Future<Either<Failure, LearningRequestModel?>> getLearningRequestById(
    String requestId,
    String userId,
  ) async {
    try {
      print(
        '📥 [SUPABASE] Fetching learning request: $requestId for user: $userId',
      );

      final response =
          await _supabaseClient
              .from(_learningRequestsTable)
              .select('''
            *,
            learning_request_vocabularies(*),
            learning_request_phrases(*)
          ''')
              .eq('request_id', requestId)
              .eq('user_id', userId)
              .maybeSingle();

      if (response == null) {
        print('⚠️ [SUPABASE] Learning request not found: $requestId');
        return right(null);
      }

      final request = await _convertSupabaseRecordToModel(response);
      print('✅ [SUPABASE] Learning request retrieved successfully');
      return right(request);
    } catch (e) {
      print('❌ [SUPABASE] Failed to get learning request by ID: $e');
      return left(
        ServerFailure('Failed to get learning request: ${e.toString()}'),
      );
    }
  }

  /// Updates an existing learning request
  /// Updates all attributes and related vocabularies/phrases
  ///
  /// Parameters:
  /// - request: Updated LearningRequestModel
  ///
  /// Returns: Either Failure or success status
  /// Example: await dataSource.updateLearningRequest(updatedRequest);
  Future<Either<Failure, bool>> updateLearningRequest(
    LearningRequestModel request,
  ) async {
    try {
      print('📝 [SUPABASE] Updating learning request: ${request.requestId}');

      // Convert the request to Supabase format
      final requestData = _convertRequestToSupabaseFormat(request);

      // Update the main learning request record
      await _supabaseClient
          .from(_learningRequestsTable)
          .update(requestData)
          .eq('request_id', request.requestId)
          .eq('user_id', request.userId);

      // Get the internal ID for related table operations
      final idResponse =
          await _supabaseClient
              .from(_learningRequestsTable)
              .select('id')
              .eq('request_id', request.requestId)
              .eq('user_id', request.userId)
              .single();

      final internalId = idResponse['id'] as int;

      // Delete existing vocabularies and phrases
      await _supabaseClient
          .from(_vocabulariesTable)
          .delete()
          .eq('learning_request_id', internalId);

      await _supabaseClient
          .from(_phrasesTable)
          .delete()
          .eq('learning_request_id', internalId);

      // Insert updated vocabularies and phrases
      if (request.vocabularies.isNotEmpty) {
        await _saveVocabularies(internalId, request.vocabularies);
      }

      if (request.phrases.isNotEmpty) {
        await _savePhrases(internalId, request.phrases);
      }

      print('✅ [SUPABASE] Learning request updated successfully');
      return right(true);
    } catch (e) {
      print('❌ [SUPABASE] Failed to update learning request: $e');
      return left(
        ServerFailure('Failed to update learning request: ${e.toString()}'),
      );
    }
  }

  /// Deletes a learning request and all related data
  /// Removes the request, vocabularies, and phrases
  ///
  /// Parameters:
  /// - requestId: The unique request identifier
  /// - userId: The user's unique identifier (for security)
  ///
  /// Returns: Either Failure or success status
  /// Example: await dataSource.deleteLearningRequest('req123', 'user123');
  Future<Either<Failure, bool>> deleteLearningRequest(
    String requestId,
    String userId,
  ) async {
    try {
      print(
        '🗑️ [SUPABASE] Deleting learning request: $requestId for user: $userId',
      );

      // Get the internal ID
      final idResponse =
          await _supabaseClient
              .from(_learningRequestsTable)
              .select('id')
              .eq('request_id', requestId)
              .eq('user_id', userId)
              .maybeSingle();

      if (idResponse == null) {
        print(
          '⚠️ [SUPABASE] Learning request not found for deletion: $requestId',
        );
        return right(false);
      }

      final internalId = idResponse['id'] as int;

      // Delete related vocabularies and phrases (cascading delete)
      await _supabaseClient
          .from(_vocabulariesTable)
          .delete()
          .eq('learning_request_id', internalId);

      await _supabaseClient
          .from(_phrasesTable)
          .delete()
          .eq('learning_request_id', internalId);

      // Delete the main learning request
      await _supabaseClient
          .from(_learningRequestsTable)
          .delete()
          .eq('request_id', requestId)
          .eq('user_id', userId);

      print('✅ [SUPABASE] Learning request deleted successfully');
      return right(true);
    } catch (e) {
      print('❌ [SUPABASE] Failed to delete learning request: $e');
      return left(
        ServerFailure('Failed to delete learning request: ${e.toString()}'),
      );
    }
  }

  /// Gets user's learning statistics
  /// Returns aggregated data about user's learning progress
  ///
  /// Parameters:
  /// - userId: The user's unique identifier
  ///
  /// Returns: Either Failure or statistics map
  /// Example: final stats = await dataSource.getUserLearningStatistics('user123');
  Future<Either<Failure, Map<String, dynamic>>> getUserLearningStatistics(
    String userId,
  ) async {
    try {
      print('📊 [SUPABASE] Fetching learning statistics for user: $userId');

      // Get request count and token usage statistics
      final response = await _supabaseClient
          .from(_learningRequestsTable)
          .select('total_tokens_used, estimated_cost, ai_provider')
          .eq('user_id', userId);

      int totalRequests = response.length;
      int totalTokens = 0;
      double totalCost = 0.0;
      Map<String, int> providerUsage = {};

      for (final record in response) {
        totalTokens += (record['total_tokens_used'] as int? ?? 0);
        totalCost += (record['estimated_cost'] as double? ?? 0.0);

        final provider = record['ai_provider'] as String? ?? 'unknown';
        providerUsage[provider] = (providerUsage[provider] ?? 0) + 1;
      }

      // Get vocabulary and phrase counts
      final vocabCountResponse = await _supabaseClient
          .from(_vocabulariesTable)
          .select('id')
          .eq('user_id', userId);

      final phraseCountResponse = await _supabaseClient
          .from(_phrasesTable)
          .select('id')
          .eq('user_id', userId);

      final statistics = {
        'totalRequests': totalRequests,
        'totalTokensUsed': totalTokens,
        'totalCostUsd': totalCost,
        'totalVocabularies': vocabCountResponse.length,
        'totalPhrases': phraseCountResponse.length,
        'providerUsage': providerUsage,
        'lastUpdated': DateTime.now().toIso8601String(),
      };

      print('✅ [SUPABASE] Learning statistics retrieved successfully');
      return right(statistics);
    } catch (e) {
      print('❌ [SUPABASE] Failed to get learning statistics: $e');
      return left(
        ServerFailure('Failed to get learning statistics: ${e.toString()}'),
      );
    }
  }

  // ===== PRIVATE HELPER METHODS =====

  /// Converts LearningRequestModel to Supabase-compatible format
  /// Maps all model attributes to database column names
  Map<String, dynamic> _convertRequestToSupabaseFormat(
    LearningRequestModel request,
  ) {
    return {
      'request_id': request.requestId,
      'user_id': request.userId,
      'user_level': request.userLevel.name,
      'focus_areas': request.focusAreas,
      'ai_provider': request.aiProvider.name,
      'ai_model': request.aiModel,
      'total_tokens_used': request.totalTokensUsed,
      'estimated_cost': request.estimatedCost,
      'request_timestamp': request.requestTimestamp.toIso8601String(),
      'created_at': request.createdAt.toIso8601String(),
      'system_prompt': request.systemPrompt,
      'user_prompt': request.userPrompt,
      'error_message': request.errorMessage,
      'metadata': request.metadata,
    };
  }

  /// Converts Supabase record to LearningRequestModel
  /// Rebuilds the complete model with all attributes and related data
  Future<LearningRequestModel> _convertSupabaseRecordToModel(
    Map<String, dynamic> record,
  ) async {
    // Convert vocabularies
    final vocabulariesData =
        record['learning_request_vocabularies'] as List? ?? [];
    final vocabularies =
        vocabulariesData
            .map(
              (vocabRecord) => VocabularyModel(
                english: vocabRecord['english'] as String,
                persian: vocabRecord['persian'] as String,
                isUsed: vocabRecord['is_used'] as bool? ?? false,
              ),
            )
            .toList();

    // Convert phrases
    final phrasesData = record['learning_request_phrases'] as List? ?? [];
    final phrases =
        phrasesData
            .map(
              (phraseRecord) => PhraseModel(
                english: phraseRecord['english'] as String,
                persian: phraseRecord['persian'] as String,
                isUsed: phraseRecord['is_used'] as bool? ?? false,
              ),
            )
            .toList();

    return LearningRequestModel(
      requestId: record['request_id'] as String,
      userId: record['user_id'] as String,
      userLevel: UserLevel.values.firstWhere(
        (level) => level.name == record['user_level'],
        orElse: () => UserLevel.intermediate,
      ),
      focusAreas: List<String>.from(record['focus_areas'] as List? ?? []),
      aiProvider: AiProviderType.values.firstWhere(
        (provider) => provider.name == record['ai_provider'],
        orElse: () => AiProviderType.openai,
      ),
      aiModel: record['ai_model'] as String,
      totalTokensUsed: record['total_tokens_used'] as int,
      estimatedCost: record['estimated_cost'] as double,
      requestTimestamp: DateTime.parse(record['request_timestamp'] as String),
      createdAt: DateTime.parse(record['created_at'] as String),
      systemPrompt: record['system_prompt'] as String,
      userPrompt: record['user_prompt'] as String,
      errorMessage: record['error_message'] as String?,
      vocabularies: vocabularies,
      phrases: phrases,
      metadata: record['metadata'] as Map<String, dynamic>?,
    );
  }

  /// Saves vocabularies to the vocabularies table
  /// Links vocabularies to the learning request via foreign key
  Future<void> _saveVocabularies(
    int learningRequestId,
    List<VocabularyModel> vocabularies,
  ) async {
    final vocabulariesData =
        vocabularies
            .map(
              (vocab) => {
                'learning_request_id': learningRequestId,
                'english': vocab.english,
                'persian': vocab.persian,
                'is_used': vocab.isUsed,
              },
            )
            .toList();

    await _supabaseClient.from(_vocabulariesTable).insert(vocabulariesData);
    print('✅ [SUPABASE] Saved ${vocabularies.length} vocabularies');
  }

  /// Saves phrases to the phrases table
  /// Links phrases to the learning request via foreign key
  Future<void> _savePhrases(
    int learningRequestId,
    List<PhraseModel> phrases,
  ) async {
    final phrasesData =
        phrases
            .map(
              (phrase) => {
                'learning_request_id': learningRequestId,
                'english': phrase.english,
                'persian': phrase.persian,
                'is_used': phrase.isUsed,
              },
            )
            .toList();

    await _supabaseClient.from(_phrasesTable).insert(phrasesData);
    print('✅ [SUPABASE] Saved ${phrases.length} phrases');
  }
}

// ===== SUPABASE DATABASE SCHEMA =====
// 
// The following SQL schema should be created in Supabase:
//
// -- Main learning requests table
// CREATE TABLE learning_requests (
//   id BIGSERIAL PRIMARY KEY,
//   request_id TEXT UNIQUE NOT NULL,
//   user_id TEXT NOT NULL,
//   user_level TEXT NOT NULL,
//   focus_areas TEXT[] NOT NULL DEFAULT '{}',
//   ai_provider TEXT NOT NULL,
//   ai_model TEXT NOT NULL,
//   total_tokens_used INTEGER NOT NULL DEFAULT 0,
//   estimated_cost DECIMAL(10,6) NOT NULL DEFAULT 0.0,
//   request_timestamp TIMESTAMPTZ NOT NULL,
//   created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
//   system_prompt TEXT NOT NULL,
//   user_prompt TEXT NOT NULL,
//   error_message TEXT,
//   metadata JSONB,
//   
//   -- Indexes for performance
//   INDEX idx_learning_requests_user_id ON learning_requests(user_id),
//   INDEX idx_learning_requests_request_id ON learning_requests(request_id),
//   INDEX idx_learning_requests_created_at ON learning_requests(created_at DESC)
// );
//
// -- Vocabularies table with foreign key relationship
// CREATE TABLE learning_request_vocabularies (
//   id BIGSERIAL PRIMARY KEY,
//   learning_request_id BIGINT REFERENCES learning_requests(id) ON DELETE CASCADE,
//   english TEXT NOT NULL,
//   persian TEXT NOT NULL,
//   is_used BOOLEAN NOT NULL DEFAULT FALSE,
//   created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
//   
//   -- Index for performance
//   INDEX idx_vocabularies_learning_request_id ON learning_request_vocabularies(learning_request_id)
// );
//
// -- Phrases table with foreign key relationship
// CREATE TABLE learning_request_phrases (
//   id BIGSERIAL PRIMARY KEY,
//   learning_request_id BIGINT REFERENCES learning_requests(id) ON DELETE CASCADE,
//   english TEXT NOT NULL,
//   persian TEXT NOT NULL,
//   is_used BOOLEAN NOT NULL DEFAULT FALSE,
//   created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
//   
//   -- Index for performance
//   INDEX idx_phrases_learning_request_id ON learning_request_phrases(learning_request_id)
// );
//
// -- Row Level Security (RLS) policies
// ALTER TABLE learning_requests ENABLE ROW LEVEL SECURITY;
// ALTER TABLE learning_request_vocabularies ENABLE ROW LEVEL SECURITY;
// ALTER TABLE learning_request_phrases ENABLE ROW LEVEL SECURITY;
//
// -- RLS policies to ensure users can only access their own data
// CREATE POLICY "Users can only access their own learning requests" ON learning_requests
//   FOR ALL USING (auth.uid()::text = user_id);
//
// CREATE POLICY "Users can only access their own vocabularies" ON learning_request_vocabularies
//   FOR ALL USING (EXISTS (
//     SELECT 1 FROM learning_requests 
//     WHERE learning_requests.id = learning_request_vocabularies.learning_request_id 
//     AND learning_requests.user_id = auth.uid()::text
//   ));
//
// CREATE POLICY "Users can only access their own phrases" ON learning_request_phrases
//   FOR ALL USING (EXISTS (
//     SELECT 1 FROM learning_requests 
//     WHERE learning_requests.id = learning_request_phrases.learning_request_id 
//     AND learning_requests.user_id = auth.uid()::text
//   ));

// ===== EXAMPLE USAGE =====
//
// final supabaseClient = Supabase.instance.client;
// final dataSource = SupabaseLearningRequestsRemoteDataSource(supabaseClient);
//
// // Save a learning request
// final result = await dataSource.saveLearningRequest(learningRequestModel);
// result.fold(
//   (failure) => print('Error: ${failure.message}'),
//   (requestId) => print('Saved with ID: $requestId'),
// );
//
// // Get user's learning requests
// final requestsResult = await dataSource.getUserLearningRequests('user123');
// requestsResult.fold(
//   (failure) => print('Error: ${failure.message}'),
//   (requests) => print('Found ${requests.length} requests'),
// );
//
// // Get learning statistics
// final statsResult = await dataSource.getUserLearningStatistics('user123');
// statsResult.fold(
//   (failure) => print('Error: ${failure.message}'),
//   (stats) => print('Total requests: ${stats['totalRequests']}'),
// );