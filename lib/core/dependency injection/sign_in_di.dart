import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:learning_english/core/dependency%20injection/locator.dart';
import 'package:learning_english/features/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:learning_english/features/authentication/data/datasources/user_local_data_source.dart';
import 'package:learning_english/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:learning_english/features/authentication/domain/repositories/auth_repository.dart';
import 'package:learning_english/features/authentication/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:learning_english/core/usecase/get_user_id_usecase.dart';
import 'package:learning_english/core/repositories/user_repository.dart';
import 'package:learning_english/features/authentication/presentation/bloc/authentication_bloc.dart';

void signInDi(GetIt locator) {
  // Data sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(),
  );
  // Local data source for userId
  getIt.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSourceImpl(getIt<SharedPreferences>()),
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

  // Bloc
  getIt.registerSingleton(
    AuthenticationBloc(
      signInWithGoogleUseCase: getIt<SignInWithGoogleUseCase>(),
      getUserIdUseCase: getIt<GetUserIdUseCase>(),
      userRepository: getIt<UserRepository>(),
    ),
  );
}
