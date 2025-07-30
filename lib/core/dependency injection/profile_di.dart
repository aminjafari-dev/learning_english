/// Profile DI (Dependency Injection) setup for the profile feature.
///
/// This file registers all dependencies related to the profile feature
/// including data sources, repositories, use cases, and BLoC.
///
/// Usage Example:
///   await setupProfileDI(getIt);
import 'package:get_it/get_it.dart';
import 'package:learning_english/features/profile/data/datasources/profile_local_data_source.dart';
import 'package:learning_english/features/profile/data/datasources/profile_local_data_source_impl.dart';
import 'package:learning_english/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:learning_english/features/profile/data/datasources/profile_remote_data_source_impl.dart';
import 'package:learning_english/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:learning_english/features/profile/domain/repositories/profile_repository.dart';
import 'package:learning_english/features/profile/domain/usecases/get_user_profile_usecase.dart';
import 'package:learning_english/features/profile/domain/usecases/update_app_language_usecase.dart';
import 'package:learning_english/features/profile/domain/usecases/update_profile_image_usecase.dart';
import 'package:learning_english/features/profile/domain/usecases/update_user_profile_usecase.dart';
import 'package:learning_english/features/profile/presentation/bloc/profile_bloc.dart';

/// Sets up dependency injection for the profile feature
///
/// This function registers all profile-related dependencies with the GetIt locator.
/// It follows the established pattern of registering data sources, repositories,
/// use cases, and BLoC in the correct order.
///
/// Parameters:
///   - locator: The GetIt instance to register dependencies with
///
/// Returns:
///   - Future<void>: Completes when all dependencies are registered
Future<void> setupProfileDI(GetIt locator) async {
  // Register Data Sources
  locator.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(),
  );

  locator.registerLazySingleton<ProfileLocalDataSource>(
    () => ProfileLocalDataSourceImpl(sharedPreferences: locator()),
  );

  // Register Repository
  locator.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // Register Use Cases
  locator.registerLazySingleton<GetUserProfileUseCase>(
    () => GetUserProfileUseCase(locator()),
  );

  locator.registerLazySingleton<UpdateUserProfileUseCase>(
    () => UpdateUserProfileUseCase(locator()),
  );

  locator.registerLazySingleton<UpdateProfileImageUseCase>(
    () => UpdateProfileImageUseCase(locator()),
  );

  locator.registerLazySingleton<UpdateAppLanguageUseCase>(
    () => UpdateAppLanguageUseCase(locator()),
  );

  // Register BLoC
  locator.registerSingleton<ProfileBloc>(
    ProfileBloc(
      getUserIdUseCase: locator(),
      getUserProfileUseCase: locator(),
      updateUserProfileUseCase: locator(),
      updateProfileImageUseCase: locator(),
      updateAppLanguageUseCase: locator(),
    ),
  );
}
