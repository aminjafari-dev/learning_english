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
  try {
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

    // Bloc
    getIt.registerSingleton<LevelBloc>(
      LevelBloc(
        saveUserLevelUseCase: getIt<SaveUserLevelUseCase>(),
        // This is already registered in sign_in_di.dart
        getUserIdUseCase: getIt<GetUserIdUseCase>(),
      ),
    );

    print('✅ [DI] Level Selection dependencies registered successfully');
  } catch (e) {
    print('❌ [DI] Error setting up Level Selection dependencies: $e');
    rethrow; // Re-throw to let the caller handle the error
  }
}
