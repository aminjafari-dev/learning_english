/// Core DI (Dependency Injection) setup for core dependencies.
///
/// This file registers core dependencies that can be used across multiple features
/// including user repository, core use cases, and TTS service.
///
/// Usage Example:
///   setupCoreDI(getIt);
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:learning_english/core/repositories/user_repository.dart';
import 'package:learning_english/core/repositories/user_repository_impl.dart';
import 'package:learning_english/core/usecase/get_user_id_usecase.dart';
import 'package:learning_english/features/authentication/data/datasources/user_local_data_source.dart';
import 'package:learning_english/core/services/tts_service.dart';
import 'package:learning_english/core/services/auth_service.dart';
import 'package:learning_english/core/services/user_profile_service.dart';

/// Sets up dependency injection for core dependencies
///
/// This function registers core dependencies with the GetIt locator.
/// These dependencies can be used across multiple features.
///
/// Parameters:
///   - locator: The GetIt instance to register dependencies with
void setupCoreDI(GetIt locator) {
  // Register User Local Data Source (needed by UserRepository)
  // This is registered here because it's used by core UserRepository
  locator.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSourceImpl(locator<SharedPreferences>()),
  );

  // Register Core Repository
  locator.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(locator<UserLocalDataSource>()),
  );

  // Register Core Use Cases
  locator.registerLazySingleton<GetUserIdUseCase>(
    () => GetUserIdUseCase(locator<UserRepository>()),
  );

  // Register TTS Service as a singleton
  // This service can be used across multiple features for audio playback
  locator.registerLazySingleton<TTSService>(() => TTSService());

  // Register Auth Service as a singleton
  // This service provides centralized authentication management
  locator.registerLazySingleton<AuthService>(() => AuthService());

  // Register User Profile Service as a singleton
  // This service handles automatic profile creation and management
  locator.registerLazySingleton<UserProfileService>(() => UserProfileService());
}
