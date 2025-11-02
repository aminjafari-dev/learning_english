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
import 'package:learning_english/features/daily_lessons/data/datasources/local/daily_lessons_local_data_source.dart';
import 'package:learning_english/features/daily_lessons/data/datasources/local/learning_requests_local_data_source.dart';

import 'package:learning_english/features/daily_lessons/data/repositories/user_preferences_repository_impl.dart';
import 'package:learning_english/features/daily_lessons/domain/repositories/user_preferences_repository.dart';
import 'package:learning_english/features/level_selection/domain/repositories/user_repository.dart';
import 'package:learning_english/features/learning_focus_selection/domain/repositories/learning_focus_selection_repository.dart';
import 'package:learning_english/core/repositories/user_repository.dart'
    as core_user;
import 'package:learning_english/features/daily_lessons/domain/usecases/get_daily_lessons_usecase.dart';
import 'package:learning_english/features/daily_lessons/domain/usecases/get_user_preferences_usecase.dart';
import 'package:learning_english/features/daily_lessons/domain/usecases/complete_course_usecase.dart';
import 'package:learning_english/features/daily_lessons/domain/repositories/daily_lessons_repository.dart';
import 'package:learning_english/features/daily_lessons/data/repositories/daily_lessons_repository_impl.dart';
import 'package:learning_english/features/daily_lessons/data/datasources/remote/gemini_lessons_service.dart';
import 'package:learning_english/features/daily_lessons/presentation/bloc/daily_lessons_bloc.dart';
import 'package:learning_english/features/learning_paths/domain/repositories/learning_paths_repository.dart';

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

    // ===== SPECIALIZED LOCAL DATA SOURCES =====

    // Learning Requests Local Data Source - handles learning request CRUD operations
    getIt.registerLazySingleton<LearningRequestsLocalDataSource>(
      () => LearningRequestsLocalDataSource(),
    );

    // ===== MAIN COORDINATOR LOCAL DATA SOURCE =====

    // Main Local Data Source - uses composition pattern with specialized data sources
    getIt.registerLazySingleton<DailyLessonsLocalDataSource>(
      () => DailyLessonsLocalDataSource(),
    );

    // Initialize the main local data source (which initializes all specialized data sources)
    await getIt<DailyLessonsLocalDataSource>().initialize();

    // Note: Learning requests cloud storage is now handled by Supabase functions
    // No need for remote data source registration

    // Gemini Lessons Service
    getIt.registerLazySingleton<GeminiLessonsService>(
      () => GeminiLessonsService(
        getIt<DailyLessonsLocalDataSource>(),
        _getGeminiApiKey(),
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

    // Daily Lessons Repository - handles course content and lesson generation
    getIt.registerLazySingleton<DailyLessonsRepository>(
      () => DailyLessonsRepositoryImpl(
        localDataSource: getIt<DailyLessonsLocalDataSource>(),
        geminiLessonsService: getIt<GeminiLessonsService>(),
        userPreferencesRepository: getIt<UserPreferencesRepository>(),
        learningPathsRepository: getIt<LearningPathsRepository>(),
        coreUserRepository: getIt<core_user.UserRepository>(),
      ),
    );

    getIt.registerFactory(
      () => GetDailyLessonsUseCase(
        getIt<DailyLessonsRepository>(),
      ),
    );

    getIt.registerFactory(
      () => GetUserPreferencesUseCase(getIt<UserPreferencesRepository>()),
    );

    getIt.registerFactory(
      () => CompleteCourseUseCase(repository: getIt<DailyLessonsRepository>()),
    );

    // Bloc
    getIt.registerSingleton<DailyLessonsBloc>(
      DailyLessonsBloc(
        getDailyLessonsUseCase: getIt<GetDailyLessonsUseCase>(),
        getUserPreferencesUseCase: getIt<GetUserPreferencesUseCase>(),
        completeCourseUseCase: getIt<CompleteCourseUseCase>(),
        dailyLessonsRepository: getIt<DailyLessonsRepository>(),
      ),
    );

    print('✅ [DI] Daily Lessons dependencies registered successfully');
  } catch (e) {
    print('❌ [DI] Error setting up Daily Lessons dependencies: $e');
    rethrow; // Re-throw to let the caller handle the error
  }
}

/// Get Gemini API key from environment variables
/// Loads the API key from the .env file using flutter_dotenv
String _getGeminiApiKey() {
  return dotenv.env['GEMINI_API_KEY'] ?? '';
}

// Example usage:
// setupDailyLessonsDI(getIt);
// final bloc = getIt<DailyLessonsBloc>();
// bloc.add(const DailyLessonsEvent.fetchLessons());
