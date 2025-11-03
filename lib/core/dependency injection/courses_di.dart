// courses_di.dart
// Dependency injection setup for the Courses feature.
// Registers data sources, repository, use cases, and Bloc for Courses.
// Now includes user-specific data storage and analytics functionality using Hive.
// Now supports personalized content generation based on user preferences.

import 'package:get_it/get_it.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:learning_english/features/course/data/models/learning_request_model.dart';
import 'package:learning_english/features/course/data/models/level_type.dart';
import 'package:learning_english/features/course/data/models/vocabulary_model.dart';
import 'package:learning_english/features/course/data/models/phrase_model.dart';
import 'package:learning_english/features/course/data/models/ai_provider_type.dart';
import 'package:learning_english/features/course/data/datasources/local/courses_local_data_source.dart';
import 'package:learning_english/features/course/data/datasources/local/learning_requests_local_data_source.dart';

import 'package:learning_english/features/course/data/repositories/user_preferences_repository_impl.dart';
import 'package:learning_english/features/course/domain/repositories/user_preferences_repository.dart';
import 'package:learning_english/features/level_selection/domain/repositories/user_repository.dart';
import 'package:learning_english/features/learning_focus_selection/domain/repositories/learning_focus_selection_repository.dart';
import 'package:learning_english/core/repositories/user_repository.dart'
    as core_user;
import 'package:learning_english/features/course/domain/usecases/get_courses_usecase.dart';
import 'package:learning_english/features/course/domain/usecases/get_user_preferences_usecase.dart';
import 'package:learning_english/features/course/domain/usecases/complete_course_usecase.dart';
import 'package:learning_english/features/course/domain/repositories/courses_repository.dart';
import 'package:learning_english/features/course/data/repositories/courses_repository_impl.dart';
import 'package:learning_english/features/course/data/datasources/remote/gemini_lessons_service.dart';
import 'package:learning_english/features/course/presentation/bloc/courses_bloc.dart';
import 'package:learning_english/features/learning_paths/domain/repositories/learning_paths_repository.dart';

/// Call this function to register all dependencies for Courses
/// @param getIt The GetIt instance for dependency injection
Future<void> setupCoursesDI(GetIt getIt) async {
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
    getIt.registerLazySingleton<CoursesLocalDataSource>(
      () => CoursesLocalDataSource(),
    );

    // Initialize the main local data source (which initializes all specialized data sources)
    await getIt<CoursesLocalDataSource>().initialize();

    // Note: Learning requests cloud storage is now handled by Supabase functions
    // No need for remote data source registration

    // Gemini Lessons Service
    getIt.registerLazySingleton<GeminiLessonsService>(
      () => GeminiLessonsService(
        getIt<CoursesLocalDataSource>(),
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

    // Courses Repository - handles course content and lesson generation
    getIt.registerLazySingleton<CoursesRepository>(
      () => CoursesRepositoryImpl(
        localDataSource: getIt<CoursesLocalDataSource>(),
        geminiLessonsService: getIt<GeminiLessonsService>(),
        userPreferencesRepository: getIt<UserPreferencesRepository>(),
        learningPathsRepository: getIt<LearningPathsRepository>(),
        coreUserRepository: getIt<core_user.UserRepository>(),
      ),
    );

    getIt.registerFactory(
      () => GetCoursesUseCase(
        getIt<CoursesRepository>(),
      ),
    );

    getIt.registerFactory(
      () => GetUserPreferencesUseCase(getIt<UserPreferencesRepository>()),
    );

    getIt.registerFactory(
      () => CompleteCourseUseCase(repository: getIt<CoursesRepository>()),
    );

    // Bloc
    getIt.registerSingleton<CoursesBloc>(
      CoursesBloc(
        getCoursesUseCase: getIt<GetCoursesUseCase>(),
        getUserPreferencesUseCase: getIt<GetUserPreferencesUseCase>(),
        completeCourseUseCase: getIt<CompleteCourseUseCase>(),
        coursesRepository: getIt<CoursesRepository>(),
      ),
    );

    print('✅ [DI] Courses dependencies registered successfully');
  } catch (e) {
    print('❌ [DI] Error setting up Courses dependencies: $e');
    rethrow; // Re-throw to let the caller handle the error
  }
}

/// Get Gemini API key from environment variables
/// Loads the API key from the .env file using flutter_dotenv
String _getGeminiApiKey() {
  return dotenv.env['GEMINI_API_KEY'] ?? '';
}

// Example usage:
// setupCoursesDI(getIt);
// final bloc = getIt<CoursesBloc>();
// bloc.add(const CoursesEvent.fetchLessons());
