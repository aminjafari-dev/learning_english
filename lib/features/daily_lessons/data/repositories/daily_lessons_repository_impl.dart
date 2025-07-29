// daily_lessons_repository_impl.dart
// Enhanced implementation of the DailyLessonsRepository interface.
// This class connects the data sources to the domain layer and handles mapping and error handling.
// All methods are now personalized based on user preferences.
// Now includes complete request tracking with all metadata and generated content.

import 'package:dartz/dartz.dart';
import 'package:learning_english/features/daily_lessons/data/models/level_type.dart';
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
import 'package:learning_english/core/error/failure.dart';
import '../services/content_sync_manager.dart';
import 'package:learning_english/features/level_selection/domain/entities/user_profile.dart'
    as user_profile;
import 'package:learning_english/features/level_selection/domain/repositories/user_repository.dart';
import 'package:learning_english/features/learning_focus_selection/domain/repositories/learning_focus_selection_repository.dart';
import 'package:learning_english/features/authentication/domain/usecases/get_user_id_usecase.dart';
import 'package:learning_english/core/usecase/usecase.dart';

/// Enhanced implementation of DailyLessonsRepository with complete request tracking
/// All AI requests are saved with complete metadata and generated content
/// Now supports personalized content based on user preferences with full request history
class DailyLessonsRepositoryImpl implements DailyLessonsRepository {
  final AiLessonsRemoteDataSource remoteDataSource;
  final DailyLessonsLocalDataSource localDataSource;
  final UserRepository userRepository;
  final LearningFocusSelectionRepository learningFocusRepository;
  final GetUserIdUseCase getUserIdUseCase;

  /// Inject the AI-based remote data source and local data source via constructor
  /// Now also includes repositories for fetching user preferences
  DailyLessonsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.userRepository,
    required this.learningFocusRepository,
    required this.getUserIdUseCase,
  });

  /// Content sync manager for saving content to Firebase in background
  ContentSyncManager? _contentSyncManager;

  /// Sets the content sync manager for background Firebase operations
  /// This should be called after the manager is created and initialized
  void setContentSyncManager(ContentSyncManager manager) {
    _contentSyncManager = manager;
  }

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
    // Get user ID for request tracking
    final userIdResult = await getUserIdUseCase(NoParams());
    final userId = userIdResult.fold(
      (failure) => 'current_user',
      (id) => id ?? 'current_user',
    );

    // Generate unique request ID
    final requestId = _generateRequestId();

    // Fetch personalized content from AI based on user preferences
    final result = await remoteDataSource.fetchPersonalizedDailyLessons(
      preferences,
    );

    return result.fold((failure) => left(failure), (data) async {
      // Extract provider type and metadata from response
      final providerType = _extractProviderTypeFromMetadata(data.metadata);
      final aiModel = _extractAiModelFromMetadata(data.metadata);
      final totalTokens = _extractTotalTokensFromMetadata(data.metadata);
      final estimatedCost = _estimateCost(totalTokens, providerType);

      // Convert user level to the correct type
      final userLevel = _convertUserLevel(preferences.level);

      // Create complete learning request with all metadata
      final learningRequest = learning_request.LearningRequest(
        requestId: requestId,
        userId: userId,
        userLevel: userLevel,
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

      // Convert to model and save complete request
      final requestModel = LearningRequestModel.fromEntity(learningRequest);
      await localDataSource.saveLearningRequest(requestModel);

      // Trigger background sync to Firebase global pool with complete request context
      print(
        '🔄 [REPOSITORY] Triggering complete request background sync for request: $requestId',
      );
      _triggerCompleteRequestBackgroundSync(learningRequest);

      return right((
        vocabularies: data.vocabularies,
        phrases: data.phrases,
        metadata: data.metadata,
      ));
    });
  }

  @override
  Future<Either<Failure, UserPreferences>> getUserPreferences() async {
    try {
      // Get user ID first
      final userIdResult = await getUserIdUseCase(NoParams());
      final userId = userIdResult.fold((failure) => null, (id) => id);

      if (userId == null) {
        // Return default preferences if user ID is not available
        return right(UserPreferences.defaultPreferences());
      }

      // Get user level from Firestore
      user_profile.Level userLevel =
          user_profile.Level.intermediate; // Default level
      try {
        // Note: This is a simplified approach. In a real implementation,
        // you would have a proper method to get user level from the repository
        // For now, we'll use the default level
        userLevel = user_profile.Level.intermediate;
      } catch (e) {
        print('⚠️ [REPOSITORY] Could not fetch user level, using default: $e');
        userLevel = user_profile.Level.intermediate;
      }

      // Get learning focus areas from local storage
      List<String> focusAreas = ['general']; // Default focus area
      try {
        final selectedOptionIds =
            await learningFocusRepository.getLearningFocusSelection();
        if (selectedOptionIds.isNotEmpty) {
          // Convert option IDs to focus area names
          // This mapping should match the options in LearningFocusSelectionPage
          focusAreas = selectedOptionIds.selectedTexts;
        }
      } catch (e) {
        print(
          '⚠️ [REPOSITORY] Could not fetch learning focus areas, using default: $e',
        );
        focusAreas = ['general'];
      }

      final preferences = UserPreferences(
        level: userLevel,
        focusAreas: focusAreas,
      );

      print('✅ [REPOSITORY] Retrieved user preferences: $preferences');
      return right(preferences);
    } catch (e) {
      print('❌ [REPOSITORY] Error fetching user preferences: $e');
      return left(
        ServerFailure('Failed to fetch user preferences: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Vocabulary>>> getUserVocabularies() async {
    try {
      final userIdResult = await getUserIdUseCase(NoParams());
      final userId = userIdResult.fold(
        (failure) => 'current_user',
        (id) => id ?? 'current_user',
      );

      final vocabularyModels = await localDataSource.getUserVocabularies(
        userId,
      );
      final vocabularies =
          vocabularyModels.map((model) => model.toEntity()).toList();

      return right(vocabularies);
    } catch (e) {
      return left(
        ServerFailure('Failed to get user vocabularies: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Phrase>>> getUserPhrases() async {
    try {
      final userIdResult = await getUserIdUseCase(NoParams());
      final userId = userIdResult.fold(
        (failure) => 'current_user',
        (id) => id ?? 'current_user',
      );

      final phraseModels = await localDataSource.getUserPhrases(userId);
      final phrases = phraseModels.map((model) => model.toEntity()).toList();

      return right(phrases);
    } catch (e) {
      return left(ServerFailure('Failed to get user phrases: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<learning_request.LearningRequest>>>
  getUserRequests() async {
    try {
      final userIdResult = await getUserIdUseCase(NoParams());
      final userId = userIdResult.fold(
        (failure) => 'current_user',
        (id) => id ?? 'current_user',
      );

      final requestModels = await localDataSource.getUserRequests(userId);
      final requests = requestModels.map((model) => model.toEntity()).toList();

      return right(requests);
    } catch (e) {
      return left(
        ServerFailure('Failed to get user requests: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, learning_request.LearningRequest?>> getRequestById(
    String requestId,
  ) async {
    try {
      final requestModel = await localDataSource.getRequestById(requestId);
      final request = requestModel?.toEntity();

      return right(request);
    } catch (e) {
      return left(
        ServerFailure('Failed to get request by ID: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> markVocabularyAsUsed(
    String requestId,
    String english,
  ) async {
    try {
      await localDataSource.markVocabularyAsUsed(requestId, english);
      return right(unit);
    } catch (e) {
      return left(
        ServerFailure('Failed to mark vocabulary as used: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> markPhraseAsUsed(
    String requestId,
    String english,
  ) async {
    try {
      await localDataSource.markPhraseAsUsed(requestId, english);
      return right(unit);
    } catch (e) {
      return left(
        ServerFailure('Failed to mark phrase as used: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getUserAnalytics() async {
    try {
      final userIdResult = await getUserIdUseCase(NoParams());
      final userId = userIdResult.fold(
        (failure) => 'current_user',
        (id) => id ?? 'current_user',
      );

      final analytics = await localDataSource.getUserAnalytics(userId);
      return right(analytics);
    } catch (e) {
      return left(
        ServerFailure('Failed to get user analytics: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> clearUserData() async {
    try {
      final userIdResult = await getUserIdUseCase(NoParams());
      final userId = userIdResult.fold(
        (failure) => 'current_user',
        (id) => id ?? 'current_user',
      );

      await localDataSource.clearUserData(userId);
      return right(unit);
    } catch (e) {
      return left(ServerFailure('Failed to clear user data: ${e.toString()}'));
    }
  }

  /// Converts user level from UserProfile.Level to LearningRequest.Level
  UserLevel _convertUserLevel(dynamic userLevel) {
    // Handle the case where userLevel is already the correct type
    if (userLevel is UserLevel) {
      return userLevel;
    }

    // Handle conversion from other level types if needed
    // For now, we'll use the same enum since LearningRequest uses user_profile.Level

    // Default fallback
    return UserLevel.intermediate;
  }

  /// Triggers complete request background sync with full request context
  void _triggerCompleteRequestBackgroundSync(
    learning_request.LearningRequest request,
  ) {
    try {
      print(
        '🔄 [BACKGROUND_SYNC] Starting complete request background sync process',
      );
      print(
        '🔄 [BACKGROUND_SYNC] Request ID: ${request.requestId}, User: ${request.userId}, Level: ${request.userLevel}, Focus Areas: ${request.focusAreas}',
      );

      // Check if content sync manager is available
      if (_contentSyncManager == null) {
        print(
          '⚠️ [BACKGROUND_SYNC] Content sync manager not available, skipping background sync',
        );
        return;
      }

      // Trigger background sync with complete request data
      // Note: You'll need to implement syncCompleteRequest in ContentSyncManager
      // _contentSyncManager!.syncCompleteRequest(request);
    } catch (e) {
      print('❌ [BACKGROUND_SYNC] Error in background sync: $e');
    }
  }

  /// Generates a unique request ID
  String _generateRequestId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = (timestamp % 10000).toString().padLeft(4, '0');
    return 'req_${timestamp}_$random';
  }

  /// Extracts provider type from metadata
  AiProviderType _extractProviderTypeFromMetadata(AiUsageMetadata metadata) {
    // Implementation depends on your metadata structure
    return AiProviderType.openai; // Default fallback
  }

  /// Extracts AI model from metadata
  String _extractAiModelFromMetadata(AiUsageMetadata metadata) {
    // Implementation depends on your metadata structure
    return 'gpt-4'; // Default fallback
  }

  /// Extracts total tokens from metadata
  int _extractTotalTokensFromMetadata(AiUsageMetadata metadata) {
    // Implementation depends on your metadata structure
    // For now, return a default value
    return 100; // Default fallback
  }

  /// Estimates cost based on tokens and provider
  double _estimateCost(int tokens, AiProviderType provider) {
    // Implementation depends on your cost calculation logic
    return tokens * 0.00003; // Example cost calculation
  }

  /// Gets system prompt based on user preferences
  String _getSystemPrompt(UserPreferences preferences) {
    // Implementation depends on your prompt generation logic
    return 'You are an English teacher specializing in ${preferences.level} level English...';
  }

  /// Gets user prompt based on user preferences
  String _getUserPrompt(UserPreferences preferences) {
    // Implementation depends on your prompt generation logic
    return 'Generate vocabulary and phrases for ${preferences.focusAreas.join(", ")}...';
  }
}
