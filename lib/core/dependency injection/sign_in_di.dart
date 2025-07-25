import 'package:get_it/get_it.dart';
import 'package:learning_english/core/dependency%20injection/locator.dart';
import 'package:learning_english/features/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:learning_english/features/authentication/data/datasources/user_local_data_source.dart';
import 'package:learning_english/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:learning_english/features/authentication/domain/repositories/auth_repository.dart';
import 'package:learning_english/features/authentication/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:learning_english/features/authentication/domain/usecases/save_user_id_usecase.dart';
import 'package:learning_english/features/authentication/domain/usecases/get_user_id_usecase.dart';
import 'package:learning_english/features/authentication/presentation/bloc/authentication_bloc.dart';

void signInDi(GetIt locator) {
  // Data sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(),
  );
  // Local data source for userId
  getIt.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSourceImpl(),
  );

  // Repository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt<AuthRemoteDataSource>(),
      localDataSource: getIt<UserLocalDataSource>(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton<SignInWithGoogleUseCase>(
    () => SignInWithGoogleUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<SaveUserIdUseCase>(
    () => SaveUserIdUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<GetUserIdUseCase>(
    () => GetUserIdUseCase(getIt<AuthRepository>()),
  );

  // Bloc
  getIt.registerSingleton(
    AuthenticationBloc(signInWithGoogleUseCase: getIt()),
  );
}
