import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:learning_english/features/history/data/datasources/local/vocabulary_history_local_data_source.dart';
import 'package:learning_english/features/history/data/repositories/vocabulary_history_repository_impl.dart';
import 'package:learning_english/features/history/domain/repositories/vocabulary_history_repository.dart';
import 'package:learning_english/features/history/domain/usecases/get_history_requests_usecase.dart';
import 'package:learning_english/features/history/domain/usecases/get_request_details_usecase.dart';
import 'package:learning_english/features/history/presentation/bloc/vocabulary_history_bloc.dart';
// Import the daily lessons models to register their adapters
import 'package:learning_english/features/daily_lessons/data/models/vocabulary_model.dart';
import 'package:learning_english/features/daily_lessons/data/models/phrase_model.dart';
import 'package:learning_english/features/daily_lessons/data/models/ai_provider_type.dart';

/// Dependency injection setup for vocabulary history feature
/// This file registers all the dependencies needed for the vocabulary history feature
///
/// Usage Example:
///   await setupVocabularyHistoryLocator(locator);
///
/// This follows the dependency injection pattern and provides
/// clean separation of concerns for the vocabulary history feature.
Future<void> setupVocabularyHistoryLocator(GetIt locator) async {
  try {
    // Register Hive adapters for the models (same as daily lessons)
    // This ensures the history feature can read the data saved by daily lessons
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(VocabularyModelAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(PhraseModelAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(AiProviderTypeAdapter());
    }

    // Data Sources
    locator.registerLazySingleton<VocabularyHistoryLocalDataSource>(
      () => VocabularyHistoryLocalDataSource(),
    );

    // Initialize the local data source
    await locator<VocabularyHistoryLocalDataSource>().initialize();

    // Repositories
    locator.registerLazySingleton<VocabularyHistoryRepository>(
      () => VocabularyHistoryRepositoryImpl(
        locator<VocabularyHistoryLocalDataSource>(),
      ),
    );

    // Use Cases
    locator.registerLazySingleton<GetHistoryRequestsUseCase>(
      () => GetHistoryRequestsUseCase(locator<VocabularyHistoryRepository>()),
    );

    locator.registerLazySingleton<GetRequestDetailsUseCase>(
      () => GetRequestDetailsUseCase(locator<VocabularyHistoryRepository>()),
    );

    // BLoC
    locator.registerSingleton<VocabularyHistoryBloc>(
       VocabularyHistoryBloc(
        getHistoryRequestsUseCase: locator<GetHistoryRequestsUseCase>(),
        getRequestDetailsUseCase: locator<GetRequestDetailsUseCase>(),
        repository: locator<VocabularyHistoryRepository>(),
      ),
    );

    print('✅ [DI] Vocabulary History dependencies registered successfully');
  } catch (e) {
    print('❌ [DI] Error setting up Vocabulary History dependencies: $e');
    rethrow;
  }
}
