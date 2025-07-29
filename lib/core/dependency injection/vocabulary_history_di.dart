import 'package:get_it/get_it.dart';
import 'package:learning_english/features/vocabulary_history/data/datasources/local/vocabulary_history_local_data_source.dart';
import 'package:learning_english/features/vocabulary_history/data/repositories/vocabulary_history_repository_impl.dart';
import 'package:learning_english/features/vocabulary_history/domain/repositories/vocabulary_history_repository.dart';
import 'package:learning_english/features/vocabulary_history/domain/usecases/get_history_requests_usecase.dart';
import 'package:learning_english/features/vocabulary_history/domain/usecases/get_request_details_usecase.dart';
import 'package:learning_english/features/vocabulary_history/presentation/bloc/vocabulary_history_bloc.dart';

/// Dependency injection setup for vocabulary history feature
/// This file registers all the dependencies needed for the vocabulary history feature
///
/// Usage Example:
///   await setupVocabularyHistoryLocator(locator);
///
/// This follows the dependency injection pattern and provides
/// clean separation of concerns for the vocabulary history feature.
Future<void> setupVocabularyHistoryLocator(GetIt locator) async {
  // Data Sources
  locator.registerLazySingleton<VocabularyHistoryLocalDataSource>(
    () => VocabularyHistoryLocalDataSource(),
  );

  // Repositories
  locator.registerLazySingleton<VocabularyHistoryRepository>(
    () => VocabularyHistoryRepositoryImpl(
      locator<VocabularyHistoryLocalDataSource>(),
    ),
  );

  // Use Cases
  locator.registerLazySingleton<GetHistoryRequestsUseCase>(
    () => GetHistoryRequestsUseCase(
      locator<VocabularyHistoryRepository>(),
    ),
  );

  locator.registerLazySingleton<GetRequestDetailsUseCase>(
    () => GetRequestDetailsUseCase(
      locator<VocabularyHistoryRepository>(),
    ),
  );

  // BLoC
  locator.registerFactory<VocabularyHistoryBloc>(
    () => VocabularyHistoryBloc(
      getHistoryRequestsUseCase: locator<GetHistoryRequestsUseCase>(),
      getRequestDetailsUseCase: locator<GetRequestDetailsUseCase>(),
      repository: locator<VocabularyHistoryRepository>(),
    ),
  );
}
