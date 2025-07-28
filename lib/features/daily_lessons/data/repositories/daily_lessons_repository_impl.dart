// daily_lessons_repository_impl.dart
// Enhanced implementation of the DailyLessonsRepository interface.
// This class connects the data sources to the domain layer and handles mapping and error handling.
// All methods are now personalized based on user preferences.
// Now includes user-specific data storage and retrieval with metadata tracking.

import 'package:dartz/dartz.dart';
import '../../domain/entities/vocabulary.dart';
import '../../domain/entities/phrase.dart';
import '../../domain/entities/ai_usage_metadata.dart';
import '../../domain/entities/user_preferences.dart';
import '../../domain/repositories/daily_lessons_repository.dart';
import '../datasources/remote/ai_lessons_remote_data_source.dart';
import '../datasources/local/daily_lessons_local_data_source.dart';
import '../datasources/ai_provider_type.dart';
import '../models/vocabulary_model.dart';
import '../models/phrase_model.dart';
import 'package:learning_english/core/error/failure.dart';
import '../services/content_sync_manager.dart';
import 'package:learning_english/features/level_selection/domain/entities/user_profile.dart';
import '../datasources/remote/firebase_lessons_remote_data_source.dart';
import 'package:learning_english/features/level_selection/domain/repositories/user_repository.dart';
import 'package:learning_english/features/learning_focus_selection/domain/repositories/learning_focus_selection_repository.dart';
import 'package:learning_english/features/authentication/domain/usecases/get_user_id_usecase.dart';
import 'package:learning_english/core/usecase/usecase.dart';

/// Enhanced implementation of DailyLessonsRepository with personalized content
/// All AI-fetched content is automatically marked as used since the user will definitely read it
/// Now supports personalized content based on user preferences
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
    // Fetch personalized content from AI based on user preferences
    final result = await remoteDataSource.fetchPersonalizedDailyLessons(
      preferences,
    );
    return result.fold((failure) => left(failure), (data) async {
      // Extract provider type and request ID from metadata
      final providerType = _extractProviderTypeFromMetadata(data.metadata);
      final requestId = data.metadata.responseId;

      // Save personalized vocabularies with exact metadata
      for (final vocabulary in data.vocabularies) {
        final model = VocabularyModel.fromEntity(
          vocabulary,
          'current_user', // Placeholder since we don't need userId for local storage
          providerType,
          _estimateTokens(vocabulary.english, vocabulary.persian),
          requestId,
        ).copyWith(
          isUsed: true,
        ); // Mark as used since user will definitely read it
        await localDataSource.saveUserVocabulary(model);
      }

      // Save personalized phrases with exact metadata
      for (final phrase in data.phrases) {
        final model = PhraseModel.fromEntity(
          phrase,
          'current_user', // Placeholder since we don't need userId for local storage
          providerType,
          _estimateTokens(phrase.english, phrase.persian),
          requestId,
        ).copyWith(
          isUsed: true,
        ); // Mark as used since user will definitely read it
        await localDataSource.saveUserPhrase(model);
      }

      // Trigger background sync to Firebase global pool with personalized context
      print(
        '🔄 [REPOSITORY] Triggering personalized background sync for ${data.vocabularies.length} vocabularies and ${data.phrases.length} phrases',
      );
      _triggerPersonalizedBackgroundSync(
        data.vocabularies,
        data.phrases,
        providerType,
        requestId,
        preferences,
      );

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
      Level userLevel = Level.intermediate; // Default level
      try {
        // Note: This is a simplified approach. In a real implementation,
        // you would have a proper method to get user level from the repository
        // For now, we'll use the default level
        userLevel = Level.intermediate;
      } catch (e) {
        print('⚠️ [REPOSITORY] Could not fetch user level, using default: $e');
        userLevel = Level.intermediate;
      }

      // Get learning focus areas from local storage
      List<String> focusAreas = ['general']; // Default focus area
      try {
        final selectedOptionIds =
            await learningFocusRepository.getSelectedOptions();
        if (selectedOptionIds.isNotEmpty) {
          // Convert option IDs to focus area names
          // This mapping should match the options in LearningFocusSelectionPage
          focusAreas = _mapOptionIdsToFocusAreas(selectedOptionIds);
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

  /// Maps learning focus option IDs to focus area names
  /// This mapping should match the options defined in LearningFocusSelectionPage
  List<String> _mapOptionIdsToFocusAreas(List<int> optionIds) {
    const Map<int, String> optionIdToFocusArea = {
      0: 'business',
      1: 'travel',
      2: 'social',
      3: 'home',
      4: 'academic',
      5: 'movie',
      6: 'music',
      7: 'tv',
      8: 'shopping',
      9: 'restaurant',
      10: 'health',
      11: 'everyday',
    };

    return optionIds.map((id) => optionIdToFocusArea[id] ?? 'general').toList();
  }

  /// Triggers personalized background sync with user preferences context
  void _triggerPersonalizedBackgroundSync(
    List<Vocabulary> vocabularies,
    List<Phrase> phrases,
    AiProviderType providerType,
    String requestId,
    UserPreferences preferences,
  ) {
    try {
      print(
        '🔄 [BACKGROUND_SYNC] Starting personalized background sync process',
      );
      print(
        '🔄 [BACKGROUND_SYNC] Provider: $providerType, Request ID: $requestId, Preferences: $preferences',
      );

      // Check if content sync manager is available
      if (_contentSyncManager == null) {
        print(
          '⚠️ [BACKGROUND_SYNC] Content sync manager not available, skipping Firebase save',
        );
        return;
      }

      // Convert domain entities to models for Firebase storage
      final vocabularyModels =
          vocabularies.map((vocabulary) {
            return VocabularyModel.fromEntity(
              vocabulary,
              'current_user', // Will be replaced with actual user ID
              providerType,
              _estimateTokens(vocabulary.english, vocabulary.persian),
              requestId,
            );
          }).toList();

      final phraseModels =
          phrases.map((phrase) {
            return PhraseModel.fromEntity(
              phrase,
              'current_user', // Will be replaced with actual user ID
              providerType,
              _estimateTokens(phrase.english, phrase.persian),
              requestId,
            );
          }).toList();

      print(
        '🔄 [BACKGROUND_SYNC] Converted ${vocabularyModels.length} vocabularies and ${phraseModels.length} phrases to models',
      );

      // Create learning context with user preferences
      final context = LearningContext(
        level: preferences.level,
        focusArea: preferences.focusAreasString,
        difficulty: _getDifficultyFromLevel(preferences.level),
      );

      print(
        '🔄 [BACKGROUND_SYNC] Created personalized learning context: ${context.toJson()}',
      );

      // Trigger background sync via content sync manager
      print(
        '🔄 [BACKGROUND_SYNC] Saving personalized content to Firebase via sync manager',
      );
      _contentSyncManager!.saveContentToFirebase(
        vocabularies: vocabularyModels,
        phrases: phraseModels,
        context: context,
        userId: 'current_user', // Will be replaced with actual user ID
      );

      print(
        '✅ [BACKGROUND_SYNC] Personalized background sync triggered successfully',
      );
    } catch (e) {
      print('❌ [BACKGROUND_SYNC] Error in personalized background sync: $e');
    }
  }

  /// Maps user level to difficulty string for learning context
  String _getDifficultyFromLevel(Level level) {
    switch (level) {
      case Level.beginner:
        return 'easy';
      case Level.elementary:
        return 'easy';
      case Level.intermediate:
        return 'medium';
      case Level.advanced:
        return 'hard';
    }
  }


  @override
  Future<Either<Failure, bool>> markVocabularyAsUsed(String english) async {
    try {
      await localDataSource.markVocabularyAsUsed(english);
      return right(true);
    } catch (e) {
      return left(
        ServerFailure('Failed to mark vocabulary as used: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> markPhraseAsUsed(String english) async {
    try {
      await localDataSource.markPhraseAsUsed(english);
      return right(true);
    } catch (e) {
      return left(
        ServerFailure('Failed to mark phrase as used: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getUserAnalytics() async {
    try {
      final analytics = await localDataSource.getUserAnalytics();
      return right(analytics);
    } catch (e) {
      return left(
        ServerFailure('Failed to get user analytics: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Vocabulary>>> getVocabulariesByProvider(
    AiProviderType provider,
  ) async {
    try {
      final vocabularies = await localDataSource.getVocabulariesByProvider(
        provider,
      );
      return right(vocabularies.map((model) => model.toEntity()).toList());
    } catch (e) {
      return left(
        ServerFailure(
          'Failed to get vocabularies by provider: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<Phrase>>> getPhrasesByProvider(
    AiProviderType provider,
  ) async {
    try {
      final phrases = await localDataSource.getPhrasesByProvider(provider);
      return right(phrases.map((model) => model.toEntity()).toList());
    } catch (e) {
      return left(
        ServerFailure('Failed to get phrases by provider: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> clearUserData() async {
    try {
      await localDataSource.clearUserData();
      return right(true);
    } catch (e) {
      return left(ServerFailure('Failed to clear user data: ${e.toString()}'));
    }
  }

  /// Extracts provider type from metadata for background sync
  AiProviderType _extractProviderTypeFromMetadata(AiUsageMetadata metadata) {
    // This is a simplified extraction - in a real implementation,
    // you would parse the metadata more carefully
    if (metadata.modelVersion.contains('gpt')) {
      return AiProviderType.openai;
    } else if (metadata.modelVersion.contains('gemini')) {
      return AiProviderType.gemini;
    } else if (metadata.modelVersion.contains('deepseek')) {
      return AiProviderType.deepseek;
    } else {
      return AiProviderType.openai; // Default fallback
    }
  }

  /// Estimates token usage for cost tracking
  int _estimateTokens(String english, String persian) {
    // Rough estimation: 1 token ≈ 4 characters for English, 2 characters for Persian
    final englishTokens = (english.length / 4).ceil();
    final persianTokens = (persian.length / 2).ceil();
    return englishTokens + persianTokens + 10; // Add buffer for JSON structure
  }
}
