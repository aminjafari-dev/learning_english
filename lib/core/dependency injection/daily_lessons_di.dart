// daily_lessons_di.dart
// Dependency injection setup for the Daily Lessons feature.
// Registers data sources, repository, use cases, and Bloc for Daily Lessons.
// Now includes user-specific data storage and analytics functionality using Hive.
// Now supports personalized content generation based on user preferences.

import 'package:get_it/get_it.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:learning_english/features/daily_lessons/data/models/learning_request_model.dart';
import 'package:learning_english/features/daily_lessons/data/models/level_type.dart';
import 'package:learning_english/features/daily_lessons/data/models/vocabulary_model.dart';
import 'package:learning_english/features/daily_lessons/data/models/phrase_model.dart';
import 'package:learning_english/features/daily_lessons/data/models/ai_provider_type.dart';
import 'package:learning_english/features/daily_lessons/data/datasources/remote/ai_lessons_remote_data_source.dart';
import 'package:learning_english/features/daily_lessons/data/datasources/remote/daily_lessons_remote_data_source.dart';
import 'package:learning_english/features/daily_lessons/data/datasources/local/daily_lessons_local_data_source.dart';
import 'package:learning_english/features/daily_lessons/data/datasources/remote/openai_lessons_remote_data_source.dart';
import 'package:learning_english/features/daily_lessons/data/datasources/remote/gemini_lessons_remote_data_source.dart';
import 'package:learning_english/features/daily_lessons/data/datasources/remote/deepseek_lessons_remote_data_source.dart';
import 'package:learning_english/features/daily_lessons/data/repositories/daily_lessons_repository_impl.dart';
import 'package:learning_english/features/daily_lessons/data/repositories/user_preferences_repository_impl.dart';
import 'package:learning_english/features/daily_lessons/data/repositories/conversation_repository_impl.dart';
import 'package:learning_english/features/daily_lessons/domain/repositories/conversation_repository.dart';
import 'package:learning_english/features/daily_lessons/domain/repositories/daily_lessons_repository.dart';
import 'package:learning_english/features/daily_lessons/domain/repositories/user_preferences_repository.dart';
import 'package:learning_english/features/level_selection/domain/repositories/user_repository.dart';
import 'package:learning_english/features/learning_focus_selection/domain/repositories/learning_focus_selection_repository.dart';
import 'package:learning_english/core/repositories/user_repository.dart'
    as core_user;
import 'package:learning_english/features/daily_lessons/domain/usecases/get_daily_lessons_usecase.dart';
import 'package:learning_english/features/daily_lessons/domain/usecases/get_user_preferences_usecase.dart';
import 'package:learning_english/features/daily_lessons/domain/usecases/send_conversation_message_usecase.dart';
import 'package:learning_english/features/daily_lessons/data/datasources/remote/gemini_conversation_service.dart';
import 'package:learning_english/features/daily_lessons/presentation/bloc/daily_lessons_bloc.dart';
import 'package:learning_english/features/daily_lessons/data/datasources/remote/firebase_lessons_remote_data_source.dart';
import 'package:learning_english/features/daily_lessons/data/services/content_sync_service_factory.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(LearningRequestModelAdapter());
    }
    if (!Hive.isAdapterRegistered(5)) {
      Hive.registerAdapter(UserLevelAdapter());
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

    // Gemini Conversation Service
    getIt.registerLazySingleton<GeminiConversationService>(
      () => GeminiConversationService(
        getIt<DailyLessonsLocalDataSource>(),
        _getGeminiApiKey(),
      ),
    );

    // Daily Lessons Repository - focused on core lesson generation only
    getIt.registerLazySingleton<DailyLessonsRepository>(
      () => DailyLessonsRepositoryImpl(
        remoteDataSource: getIt<AiLessonsRemoteDataSource>(),
        localDataSource: getIt<DailyLessonsLocalDataSource>(),
        coreUserRepository: getIt<core_user.UserRepository>(),
      ),
    );

    // User Preferences Repository - handles user settings and preferences
    getIt.registerLazySingleton<UserPreferencesRepository>(
      () => UserPreferencesRepositoryImpl(
        userRepository: getIt<UserRepository>(),
        learningFocusRepository: getIt<LearningFocusSelectionRepository>(),
        coreUserRepository: getIt<core_user.UserRepository>(),
      ),
    );

    // Conversation Repository - handles AI conversation threads and messaging
    getIt.registerLazySingleton<ConversationRepository>(
      () => ConversationRepositoryImpl(
        localDataSource: getIt<DailyLessonsLocalDataSource>(),
        geminiConversationService: getIt<GeminiConversationService>(),
        coreUserRepository: getIt<core_user.UserRepository>(),
      ),
    );

    // Use Cases
    getIt.registerFactory(() => GetDailyLessonsUseCase(getIt()));

    getIt.registerFactory(
      () => GetUserPreferencesUseCase(getIt<UserPreferencesRepository>()),
    );

    // Conversation use cases
    getIt.registerFactory(
      () => SendConversationMessageUseCase(getIt<ConversationRepository>()),
    );

    // Bloc
    getIt.registerSingleton<DailyLessonsBloc>(
      DailyLessonsBloc(
        getDailyLessonsUseCase: getIt<GetDailyLessonsUseCase>(),
        getUserPreferencesUseCase: getIt<GetUserPreferencesUseCase>(),
        sendConversationMessageUseCase: getIt<SendConversationMessageUseCase>(),
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
