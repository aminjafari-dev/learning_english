// splash_di.dart
// Dependency injection setup for the splash feature.
//
// Usage Example:
//   await setupSplashLocator(locator);
//   final splashBloc = getIt<SplashBloc>();

import 'package:get_it/get_it.dart';
import 'package:learning_english/features/splash/data/datasources/splash_local_data_source.dart';
import 'package:learning_english/features/splash/data/repositories/splash_repository_impl.dart';
import 'package:learning_english/features/splash/domain/repositories/splash_repository.dart';
import 'package:learning_english/features/splash/domain/usecases/check_authentication_status_usecase.dart';
import 'package:learning_english/features/splash/presentation/bloc/splash_bloc.dart';

/// Sets up dependency injection for the splash feature
Future<void> setupSplashLocator(GetIt locator) async {
  // Data Sources
  locator.registerLazySingleton<SplashLocalDataSource>(
    () => SplashLocalDataSourceImpl(),
  );

  // Repositories
  locator.registerLazySingleton<SplashRepository>(
    () =>
        SplashRepositoryImpl(localDataSource: locator<SplashLocalDataSource>()),
  );

  // Use Cases
  locator.registerLazySingleton<CheckAuthenticationStatusUseCase>(
    () => CheckAuthenticationStatusUseCase(
      locator<SplashRepository>(),
    ),
  );

  // BLoCs
  locator.registerSingleton<SplashBloc>(
     SplashBloc(
      checkAuthenticationStatusUseCase:
          locator<CheckAuthenticationStatusUseCase>(),
    ),
  );
}
