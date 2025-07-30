/// Core DI (Dependency Injection) setup for core dependencies.
///
/// This file registers core dependencies that can be used across multiple features
/// including user repository and core use cases.
///
/// Usage Example:
///   setupCoreDI(getIt);
import 'package:get_it/get_it.dart';
import 'package:learning_english/core/repositories/user_repository.dart';
import 'package:learning_english/core/repositories/user_repository_impl.dart';
import 'package:learning_english/core/usecase/get_user_id_usecase.dart';
import 'package:learning_english/features/authentication/data/datasources/user_local_data_source.dart';

/// Sets up dependency injection for core dependencies
///
/// This function registers core dependencies with the GetIt locator.
/// These dependencies can be used across multiple features.
///
/// Parameters:
///   - locator: The GetIt instance to register dependencies with
void setupCoreDI(GetIt locator) {
  // Register Core Repository
  locator.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(locator<UserLocalDataSource>()),
  );

  // Register Core Use Cases
  locator.registerLazySingleton<GetUserIdUseCase>(
    () => GetUserIdUseCase(locator<UserRepository>()),
  );
} 