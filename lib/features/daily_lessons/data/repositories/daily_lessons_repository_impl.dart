// daily_lessons_repository_impl.dart
// Focused implementation of the DailyLessonsRepository interface.
// This class handles only core daily lessons functionality - generating personalized content from AI.
// All other responsibilities have been moved to dedicated repositories.

import 'package:dartz/dartz.dart';
import 'package:learning_english/core/error/failure.dart';
import 'package:learning_english/core/repositories/user_repository.dart';
import '../../domain/entities/vocabulary.dart';
import '../../domain/entities/phrase.dart';
import '../../domain/entities/ai_usage_metadata.dart';
import '../../domain/entities/user_preferences.dart';
import '../../domain/entities/learning_request.dart' as learning_request;
import '../../domain/repositories/daily_lessons_repository.dart';
import '../datasources/remote/ai_lessons_remote_data_source.dart';
import '../datasources/local/daily_lessons_local_data_source.dart';
import '../models/ai_provider_type.dart';
import '../models/learning_request_model.dart';

/// Focused implementation of DailyLessonsRepository
/// Handles only core lesson generation functionality
/// Other responsibilities moved to UserPreferencesRepository, UserDataRepository, and ConversationRepository
class DailyLessonsRepositoryImpl implements DailyLessonsRepository {
  final AiLessonsRemoteDataSource remoteDataSource;
  final DailyLessonsLocalDataSource localDataSource;
  final UserRepository coreUserRepository;

  /// Constructor for dependency injection
  /// Requires only AI remote data source, local data source, and core user repository
  DailyLessonsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.coreUserRepository,
  });

  @override
  Future<
    Either<
      Failure,
      ({
        List<Vocabulary> vocabularies,
        List<Phrase> phrases,
        AiUsageMetadata metadata,
      })
    >
  >
  getPersonalizedDailyLessons(UserPreferences preferences) async {
    try {
      print('🎯 [DAILY_LESSONS] Starting personalized lesson generation');
      print(
        '📋 [DAILY_LESSONS] User preferences: level=${preferences.level}, areas=${preferences.focusAreas}',
      );

      // Get user ID for request tracking
      final userId = await coreUserRepository.getUserId() ?? 'current_user';

      // Generate unique request ID for tracking
      final requestId = _generateRequestId();
      print('🔢 [DAILY_LESSONS] Generated request ID: $requestId');

      // Fetch personalized content from AI based on user preferences
      print('🤖 [DAILY_LESSONS] Calling AI service for content generation');
      final result = await remoteDataSource.fetchPersonalizedDailyLessons(
        preferences,
      );

      return result.fold(
        (failure) {
          print('❌ [DAILY_LESSONS] AI service failed: ${failure.message}');
          return left(failure);
        },
        (data) async {
          print('✅ [DAILY_LESSONS] AI service returned content:');
          print(
            '📚 [DAILY_LESSONS] - ${data.vocabularies.length} vocabularies',
          );
          print('💬 [DAILY_LESSONS] - ${data.phrases.length} phrases');
          print('📊 [DAILY_LESSONS] - Metadata: ${data.metadata.toJson()}');

          // Extract AI usage information for tracking
          final providerType = _extractProviderTypeFromMetadata(data.metadata);
          final aiModel = _extractAiModelFromMetadata(data.metadata);
          final totalTokens = _extractTotalTokensFromMetadata(data.metadata);
          final estimatedCost = _estimateCost(totalTokens, providerType);

          print(
            '💰 [DAILY_LESSONS] Usage: provider=$providerType, model=$aiModel, tokens=$totalTokens, cost=\$${estimatedCost.toStringAsFixed(4)}',
          );

          // Create learning request for complete tracking
          final learningRequest = learning_request.LearningRequest(
            requestId: requestId,
            userId: userId,
            userLevel: preferences.level,
            focusAreas: preferences.focusAreas,
            aiProvider: providerType,
            aiModel: aiModel,
            totalTokensUsed: totalTokens,
            estimatedCost: estimatedCost,
            requestTimestamp: DateTime.now(),
            createdAt: DateTime.now(),
            systemPrompt: _getSystemPrompt(preferences),
            userPrompt: _getUserPrompt(preferences),
            errorMessage: null,
            vocabularies: data.vocabularies,
            phrases: data.phrases,
            metadata: data.metadata.toJson(),
          );

          // Save learning request for history and analytics
          try {
            final requestModel = LearningRequestModel.fromEntity(
              learningRequest,
            );
            await localDataSource.saveLearningRequest(requestModel);
            print('💾 [DAILY_LESSONS] Saved learning request to local storage');
          } catch (e) {
            print('⚠️ [DAILY_LESSONS] Failed to save learning request: $e');
            // Continue even if saving fails - don't block the main response
          }

          // Return the generated content
          print('✅ [DAILY_LESSONS] Lesson generation completed successfully');
          return right((
            vocabularies: data.vocabularies,
            phrases: data.phrases,
            metadata: data.metadata,
          ));
        },
      );
    } catch (e) {
      print('❌ [DAILY_LESSONS] Unexpected error in lesson generation: $e');
      return left(
        ServerFailure(
          'Failed to generate personalized lessons: ${e.toString()}',
        ),
      );
    }
  }

  /// Generates a unique request ID for tracking purposes
  String _generateRequestId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = (timestamp % 10000).toString().padLeft(4, '0');
    return 'req_${timestamp}_$random';
  }

  /// Extracts AI provider type from metadata
  AiProviderType _extractProviderTypeFromMetadata(AiUsageMetadata metadata) {
    // Extract from metadata structure - implementation depends on your metadata format
    return AiProviderType.openai; // Default fallback
  }

  /// Extracts AI model name from metadata
  String _extractAiModelFromMetadata(AiUsageMetadata metadata) {
    // Extract from metadata structure - implementation depends on your metadata format
    return 'gpt-4'; // Default fallback
  }

  /// Extracts total tokens from metadata
  int _extractTotalTokensFromMetadata(AiUsageMetadata metadata) {
    // Extract from metadata structure - implementation depends on your metadata format
    return 100; // Default fallback
  }

  /// Estimates cost based on tokens and provider
  double _estimateCost(int tokens, AiProviderType provider) {
    // Cost calculation based on provider pricing
    switch (provider) {
      case AiProviderType.openai:
        return tokens * 0.00003; // Example OpenAI pricing
      case AiProviderType.gemini:
        return tokens * 0.00002; // Example Gemini pricing
      default:
        return tokens * 0.00003; // Default pricing
    }
  }

  /// Gets system prompt based on user preferences
  String _getSystemPrompt(UserPreferences preferences) {
    return 'You are an English teacher specializing in ${preferences.level} level English. '
        'Focus on ${preferences.focusAreas.join(", ")} topics.';
  }

  /// Gets user prompt based on user preferences
  String _getUserPrompt(UserPreferences preferences) {
    return 'Generate vocabulary and phrases for ${preferences.level} level students '
        'focusing on ${preferences.focusAreas.join(", ")}';
  }
}

// Example usage:
// final dailyLessonsRepo = DailyLessonsRepositoryImpl(
//   remoteDataSource: getIt<AiLessonsRemoteDataSource>(),
//   localDataSource: getIt<DailyLessonsLocalDataSource>(),
//   getUserIdUseCase: getIt<GetUserIdUseCase>(),
// );
// 
// // Generate personalized content
// final preferences = UserPreferences(level: UserLevel.intermediate, focusAreas: ['technology']);
// final result = await dailyLessonsRepo.getPersonalizedDailyLessons(preferences);
// 
// // Validate preferences
// final validation = await dailyLessonsRepo.validateUserPreferences(preferences);
// 
// // Get available providers
// final providers = await dailyLessonsRepo.getAvailableAiProviders();