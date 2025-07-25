// daily_lessons_di.dart
// Dependency injection setup for the Daily Lessons feature.
// Registers data sources, repository, use cases, and Bloc for Daily Lessons.

import 'package:get_it/get_it.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:learning_english/features/daily_lessons/data/datasources/ai_provider_type.dart';
import 'package:learning_english/features/daily_lessons/data/datasources/ai_lessons_remote_data_source.dart';
import 'package:learning_english/features/daily_lessons/data/datasources/daily_lessons_remote_data_source.dart';
import 'package:learning_english/features/daily_lessons/data/datasources/openai_lessons_remote_data_source.dart';
import 'package:learning_english/features/daily_lessons/data/datasources/gemini_lessons_remote_data_source.dart';
import 'package:learning_english/features/daily_lessons/data/datasources/deepseek_lessons_remote_data_source.dart';
import 'package:learning_english/features/daily_lessons/data/repositories/daily_lessons_repository_impl.dart';
import 'package:learning_english/features/daily_lessons/domain/repositories/daily_lessons_repository.dart';
import 'package:learning_english/features/daily_lessons/domain/usecases/get_daily_vocabularies_usecase.dart';
import 'package:learning_english/features/daily_lessons/domain/usecases/get_daily_phrases_usecase.dart';
import 'package:learning_english/features/daily_lessons/domain/usecases/get_daily_lessons_usecase.dart';
import 'package:learning_english/features/daily_lessons/domain/usecases/refresh_daily_lessons_usecase.dart';
import 'package:learning_english/features/daily_lessons/presentation/bloc/daily_lessons_bloc.dart';

/// Call this function to register all dependencies for Daily Lessons
void setupDailyLessonsDI(GetIt getIt) {
  // Data Source
  // SECURITY: API keys should be stored securely (e.g., environment variables, secure storage, remote config)
  // For development, use placeholder values. In production, load from secure sources.
  getIt.registerLazySingleton<AiLessonsRemoteDataSource>(
    () => MultiModelLessonsRemoteDataSource(
      providerType: AiProviderType.gemini, // Change this to select the provider
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

  // Repository
  // Now uses the AI-provider agnostic data source
  getIt.registerLazySingleton<DailyLessonsRepository>(
    () => DailyLessonsRepositoryImpl(
      remoteDataSource: getIt<AiLessonsRemoteDataSource>(),
    ),
  );

  // Use Cases
  getIt.registerFactory(() => GetDailyVocabulariesUseCase(getIt()));
  getIt.registerFactory(() => GetDailyPhrasesUseCase(getIt()));
  getIt.registerFactory(
    () => GetDailyLessonsUseCase(getIt()),
  ); // New cost-effective use case
  getIt.registerFactory(() => RefreshDailyLessonsUseCase(getIt()));

  // Bloc
  getIt.registerSingleton(
    DailyLessonsBloc(
      getDailyVocabulariesUseCase: getIt(),
      getDailyPhrasesUseCase: getIt(),
      getDailyLessonsUseCase: getIt(), // New cost-effective use case
      refreshDailyLessonsUseCase: getIt(),
    ),
  );
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
// setupDailyLessonsDI();
// final bloc = getIt<DailyLessonsBloc>();
