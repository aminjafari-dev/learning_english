/// Navigation DI (Dependency Injection) setup for the navigation feature.
///
/// This file configures all dependencies for the navigation feature including
/// data sources, repositories, use cases, and BLoC.
import 'package:get_it/get_it.dart';
import 'package:learning_english/features/navigation/data/datasources/navigation_local_data_source.dart';
import 'package:learning_english/features/navigation/data/datasources/navigation_local_data_source_impl.dart';
import 'package:learning_english/features/navigation/data/repositories/navigation_repository_impl.dart';
import 'package:learning_english/features/navigation/domain/repositories/navigation_repository.dart';
import 'package:learning_english/features/navigation/domain/usecases/get_navigation_state_usecase.dart';
import 'package:learning_english/features/navigation/domain/usecases/update_navigation_state_usecase.dart';

/// Sets up dependency injection for the navigation feature
Future<void> setupNavigationDI(GetIt locator) async {
  // Register Data Sources
  locator.registerLazySingleton<NavigationLocalDataSource>(
    () => NavigationLocalDataSourceImpl(sharedPreferences: locator()),
  );

  // Register Repository
  locator.registerLazySingleton<NavigationRepository>(
    () => NavigationRepositoryImpl(localDataSource: locator()),
  );

  // Register Use Cases
  locator.registerLazySingleton<GetNavigationStateUseCase>(
    () => GetNavigationStateUseCase(locator()),
  );
  locator.registerLazySingleton<UpdateNavigationStateUseCase>(
    () => UpdateNavigationStateUseCase(locator()),
  );
}
