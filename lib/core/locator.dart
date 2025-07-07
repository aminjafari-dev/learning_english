// locator.dart
// Registers all dependencies for the authentication feature and core.

import 'package:get_it/get_it.dart';
import 'package:learning_english/features/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:learning_english/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:learning_english/features/authentication/domain/repositories/auth_repository.dart';
import 'package:learning_english/features/authentication/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:learning_english/features/authentication/presentation/bloc/authentication_bloc.dart';

final getIt = GetIt.instance;

void initDependencies() {
  // Data sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(),
  );

  // Repository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: getIt<AuthRemoteDataSource>()),
  );

  // Use case
  getIt.registerLazySingleton<SignInWithGoogleUseCase>(() => SignInWithGoogleUseCase(getIt<AuthRepository>()));

  // Bloc
  getIt.registerFactory<AuthenticationBloc>(
    () => AuthenticationBloc(signInWithGoogleUseCase: getIt()),
  );
}
