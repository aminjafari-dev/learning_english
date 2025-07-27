// daily_lessons_di.dart
// Dependency injection setup for the Daily Lessons feature.
// Registers data sources, repository, use cases, and Bloc for Daily Lessons.
// Now includes user-specific data storage and analytics functionality using Hive.
// Now supports personalized content generation based on user preferences.

import 'package:get_it/get_it.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:learning_english/features/daily_lessons/data/models/vocabulary_model.dart';
import 'package:learning_english/features/daily_lessons/data/models/phrase_model.dart';
import 'package:learning_english/features/daily_lessons/data/datasources/ai_provider_type.dart';
import 'package:learning_english/features/daily_lessons/data/datasources/remote/ai_lessons_remote_data_source.dart';
import 'package:learning_english/features/daily_lessons/data/datasources/remote/daily_lessons_remote_data_source.dart';
import 'package:learning_english/features/daily_lessons/data/datasources/local/daily_lessons_local_data_source.dart';
import 'package:learning_english/features/daily_lessons/data/datasources/remote/openai_lessons_remote_data_source.dart';
import 'package:learning_english/features/daily_lessons/data/datasources/remote/gemini_lessons_remote_data_source.dart';
import 'package:learning_english/features/daily_lessons/data/datasources/remote/deepseek_lessons_remote_data_source.dart';
import 'package:learning_english/features/daily_lessons/data/repositories/daily_lessons_repository_impl.dart';
import 'package:learning_english/features/daily_lessons/domain/repositories/daily_lessons_repository.dart';
import 'package:learning_english/features/daily_lessons/domain/usecases/get_daily_vocabularies_usecase.dart';
import 'package:learning_english/features/daily_lessons/domain/usecases/get_daily_phrases_usecase.dart';
import 'package:learning_english/features/daily_lessons/domain/usecases/get_daily_lessons_usecase.dart';
import 'package:learning_english/features/daily_lessons/domain/usecases/refresh_daily_lessons_usecase.dart';
import 'package:learning_english/features/daily_lessons/domain/usecases/mark_vocabulary_as_used_usecase.dart';
import 'package:learning_english/features/daily_lessons/domain/usecases/mark_phrase_as_used_usecase.dart';
import 'package:learning_english/features/daily_lessons/domain/usecases/get_user_analytics_usecase.dart';
import 'package:learning_english/features/daily_lessons/domain/usecases/clear_user_data_usecase.dart';
import 'package:learning_english/features/daily_lessons/domain/usecases/get_user_preferences_usecase.dart';
import 'package:learning_english/features/daily_lessons/presentation/bloc/daily_lessons_bloc.dart';
import 'package:learning_english/features/daily_lessons/data/datasources/remote/firebase_lessons_remote_data_source.dart';
import 'package:learning_english/features/daily_lessons/data/services/content_sync_service_factory.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learning_english/features/level_selection/domain/repositories/user_repository.dart';
import 'package:learning_english/features/learning_focus_selection/domain/repositories/learning_focus_selection_repository.dart';
import 'package:learning_english/features/authentication/domain/usecases/get_user_id_usecase.dart';

/// Call this function to register all dependencies for Daily Lessons
/// @param getIt The GetIt instance for dependency injection
Future<void> setupDailyLessonsDI(GetIt getIt) async {
  try {
    // Register Hive adapters for the models
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(VocabularyModelAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(PhraseModelAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(AiProviderTypeAdapter());
    }

    // Local Data Source
    getIt.registerLazySingleton<DailyLessonsLocalDataSource>(
      () => DailyLessonsLocalDataSource(),
    );

    // Initialize the local data source
    await getIt<DailyLessonsLocalDataSource>().initialize();

    // Remote Data Source
    // SECURITY: API keys should be stored securely (e.g., environment variables, secure storage, remote config)
    // For development, use placeholder values. In production, load from secure sources.
    getIt.registerLazySingleton<AiLessonsRemoteDataSource>(
      () => MultiModelLessonsRemoteDataSource(
        providerType:
            AiProviderType.gemini, // Change this to select the provider
        openAi: OpenAiLessonsRemoteDataSource(
          apiKey: _getOpenAiApiKey(), // Load from secure source
        ),
        gemini: GeminiLessonsRemoteDataSource(
          apiKey: _getGeminiApiKey(), // Load from secure source
        ),
        deepSeek: DeepSeekLessonsRemoteDataSource(
          apiKey: _getDeepSeekApiKey(), // Load from secure source
        ),
      ),
    );

    // Firebase Remote Data Source for background content sync
    getIt.registerLazySingleton<FirebaseLessonsRemoteDataSource>(
      () => FirebaseLessonsRemoteDataSource(
        firestore: FirebaseFirestore.instance,
      ),
    );

    // Content Sync Service Factory
    getIt.registerLazySingleton<ContentSyncServiceFactory>(
      () => ContentSyncServiceFactory(
        firebaseDataSource: getIt<FirebaseLessonsRemoteDataSource>(),
      ),
    );

    // Initialize content sync services
    final contentSyncFactory = getIt<ContentSyncServiceFactory>();
    contentSyncFactory.initialize();

    // Get the content sync manager
    final contentSyncManager = contentSyncFactory.getContentSyncManager();

    // Repository with injected content sync manager and user preference dependencies
    getIt.registerLazySingleton<DailyLessonsRepository>(() {
      final repository = DailyLessonsRepositoryImpl(
        remoteDataSource: getIt<AiLessonsRemoteDataSource>(),
        localDataSource: getIt<DailyLessonsLocalDataSource>(),
        userRepository: getIt<UserRepository>(),
        learningFocusRepository: getIt<LearningFocusSelectionRepository>(),
        getUserIdUseCase: getIt<GetUserIdUseCase>(),
      );

      // Inject the content sync manager if available
      if (contentSyncManager != null) {
        repository.setContentSyncManager(contentSyncManager);
        print(
          '✅ [DI] Content sync manager injected into repository successfully',
        );
      } else {
        print(
          '⚠️ [DI] Content sync manager not available for repository injection',
        );
      }

      return repository;
    });

    // Use Cases
    getIt.registerFactory(() => GetDailyVocabulariesUseCase(getIt()));
    getIt.registerFactory(() => GetDailyPhrasesUseCase(getIt()));
    getIt.registerFactory(
      () => GetDailyLessonsUseCase(getIt()),
    ); // New cost-effective use case
    getIt.registerFactory(() => RefreshDailyLessonsUseCase(getIt()));

    // New user-specific use cases
    getIt.registerFactory(() => MarkVocabularyAsUsedUseCase(getIt()));
    getIt.registerFactory(() => MarkPhraseAsUsedUseCase(getIt()));
    getIt.registerFactory(() => GetUserAnalyticsUseCase(getIt()));
    getIt.registerFactory(() => ClearUserDataUseCase(getIt()));
    getIt.registerFactory(() => GetUserPreferencesUseCase(getIt()));

    // Bloc
    getIt.registerSingleton<DailyLessonsBloc>(
      DailyLessonsBloc(
        getDailyVocabulariesUseCase: getIt<GetDailyVocabulariesUseCase>(),
        getDailyPhrasesUseCase: getIt<GetDailyPhrasesUseCase>(),
        getDailyLessonsUseCase: getIt<GetDailyLessonsUseCase>(),
        refreshDailyLessonsUseCase: getIt<RefreshDailyLessonsUseCase>(),
        markVocabularyAsUsedUseCase: getIt<MarkVocabularyAsUsedUseCase>(),
        markPhraseAsUsedUseCase: getIt<MarkPhraseAsUsedUseCase>(),
        getUserAnalyticsUseCase: getIt<GetUserAnalyticsUseCase>(),
        clearUserDataUseCase: getIt<ClearUserDataUseCase>(),
        getUserPreferencesUseCase: getIt<GetUserPreferencesUseCase>(),
      ),
    );

    print('✅ [DI] Daily Lessons dependencies registered successfully');
  } catch (e) {
    print('❌ [DI] Error setting up Daily Lessons dependencies: $e');
    rethrow; // Re-throw to let the caller handle the error
  }
}

/// Get OpenAI API key from environment variables
/// Loads the API key from the .env file using flutter_dotenv
String _getOpenAiApiKey() {
  return dotenv.env['OPENAI_API_KEY'] ?? '';
}

/// Get Gemini API key from environment variables
/// Loads the API key from the .env file using flutter_dotenv
String _getGeminiApiKey() {
  return dotenv.env['GEMINI_API_KEY'] ?? '';
}

/// Get DeepSeek API key from environment variables
/// Loads the API key from the .env file using flutter_dotenv
String _getDeepSeekApiKey() {
  return dotenv.env['DEEPSEEK_API_KEY'] ?? '';
}

// Example usage:
// setupDailyLessonsDI(getIt);
// final bloc = getIt<DailyLessonsBloc>();
//
// // Personalized content usage:
// final preferences = await bloc.getUserPreferences();
// preferences.fold(
//   (failure) => print('Error: ${failure.message}'),
//   (prefs) => {
//     final personalizedResult = await bloc.getPersonalizedDailyLessons(prefs);
//   },
// );
