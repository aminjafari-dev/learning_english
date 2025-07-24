// learning_focus_di.dart
// Dependency injection setup for the learning focus feature.
//
// Usage Example:
//   setupLearningFocusDI(getIt);
//
// This file registers all dependencies for the learning focus feature.

import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learning_english/features/learning_focus/data/datasources/learning_focus_local_data_source.dart';
import 'package:learning_english/features/learning_focus/data/datasources/learning_focus_remote_data_source.dart';
import 'package:learning_english/features/learning_focus/data/repositories/learning_focus_repository_impl.dart';
import 'package:learning_english/features/learning_focus/domain/repositories/learning_focus_repository.dart';
import 'package:learning_english/features/learning_focus/domain/usecases/get_learning_focus_options_usecase.dart';
import 'package:learning_english/features/learning_focus/domain/usecases/get_user_learning_focus_usecase.dart';
import 'package:learning_english/features/learning_focus/domain/usecases/save_user_learning_focus_usecase.dart';
import 'package:learning_english/features/learning_focus/presentation/bloc/learning_focus_bloc.dart';

/// Registers all dependencies for the learning focus feature.
/// Call this in your main locator file.
void setupLearningFocusDI(GetIt getIt) {
  // Register FirebaseFirestore if not already registered
  if (!getIt.isRegistered<FirebaseFirestore>()) {
    getIt.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance,
    );
  }

  // Data sources
  getIt.registerLazySingleton<LearningFocusLocalDataSource>(
    () => LearningFocusLocalDataSourceImpl(),
  );

  getIt.registerLazySingleton<LearningFocusRemoteDataSource>(
    () => LearningFocusRemoteDataSourceImpl(getIt<FirebaseFirestore>()),
  );

  // Repository
  getIt.registerLazySingleton<LearningFocusRepository>(
    () => LearningFocusRepositoryImpl(
      localDataSource: getIt<LearningFocusLocalDataSource>(),
      remoteDataSource: getIt<LearningFocusRemoteDataSource>(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton<GetLearningFocusOptionsUseCase>(
    () => GetLearningFocusOptionsUseCase(getIt<LearningFocusRepository>()),
  );

  getIt.registerLazySingleton<SaveUserLearningFocusUseCase>(
    () => SaveUserLearningFocusUseCase(getIt<LearningFocusRepository>()),
  );

  getIt.registerLazySingleton<GetUserLearningFocusUseCase>(
    () => GetUserLearningFocusUseCase(getIt<LearningFocusRepository>()),
  );

  // BLoC
  getIt.registerFactory<LearningFocusBloc>(
    () => LearningFocusBloc(
      getLearningFocusOptionsUseCase: getIt<GetLearningFocusOptionsUseCase>(),
      saveUserLearningFocusUseCase: getIt<SaveUserLearningFocusUseCase>(),
      getUserLearningFocusUseCase: getIt<GetUserLearningFocusUseCase>(),
    ),
  );
}
