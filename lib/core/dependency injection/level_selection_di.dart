// level_selection_di.dart
// Registers all dependencies for the level selection feature.
// Usage: Call setupLevelSelectionDI(getIt) in your main locator to register these dependencies.
// Example:
//   setupLevelSelectionDI(getIt);

import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learning_english/features/level_selection/data/datasources/user_remote_data_source.dart';
import 'package:learning_english/features/level_selection/data/repositories/user_repository_impl.dart';
import 'package:learning_english/features/level_selection/domain/repositories/user_repository.dart';
import 'package:learning_english/features/level_selection/domain/usecases/save_user_level_usecase.dart';
import 'package:learning_english/features/level_selection/presentation/blocs/level_bloc.dart';
import 'package:learning_english/features/authentication/domain/usecases/get_user_id_usecase.dart';

/// Registers all dependencies for the level selection feature.
/// Call this in your main locator file.
void setupLevelSelectionDI(GetIt getIt) {
  // Register FirebaseFirestore if not already registered
  if (!getIt.isRegistered<FirebaseFirestore>()) {
    getIt.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance,
    );
  }

  // Data source
  getIt.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSource(getIt<FirebaseFirestore>()),
  );

  // Repository
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(remoteDataSource: getIt<UserRemoteDataSource>()),
  );

  // Use case
  getIt.registerLazySingleton<SaveUserLevelUseCase>(
    () => SaveUserLevelUseCase(getIt<UserRepository>()),
  );
  // GetUserIdUseCase from authentication feature
  if (!getIt.isRegistered<GetUserIdUseCase>()) {
    getIt.registerLazySingleton<GetUserIdUseCase>(
      () => GetUserIdUseCase(getIt()),
    );
  }

  // Bloc
  getIt.registerFactory<LevelBloc>(
    () => LevelBloc(
      saveUserLevelUseCase: getIt<SaveUserLevelUseCase>(),
      getUserIdUseCase: getIt<GetUserIdUseCase>(),
    ),
  );
}
