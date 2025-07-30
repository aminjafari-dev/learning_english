import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:learning_english/features/localization/data/datasources/localization_local_data_source.dart';
import 'package:learning_english/features/localization/data/datasources/localization_local_data_source_impl.dart';
import 'package:learning_english/features/localization/data/repositories/localization_repository_impl.dart';
import 'package:learning_english/features/localization/domain/repositories/localization_repository.dart';
import 'package:learning_english/features/localization/domain/usecases/get_current_locale_usecase.dart';
import 'package:learning_english/features/localization/domain/usecases/get_supported_locales_usecase.dart';
import 'package:learning_english/features/localization/domain/usecases/set_locale_usecase.dart';
import 'package:learning_english/features/localization/presentation/bloc/localization_bloc.dart';

/// Setup dependency injection for localization feature
///
/// This function registers all dependencies required for the localization feature
/// including data sources, repositories, use cases, and BLoCs. It follows the
/// Clean Architecture principle of dependency injection.
///
/// Parameters:
///   - getIt: The GetIt instance for dependency registration
Future<void> setupLocalizationDI(GetIt getIt) async {
  // Data sources
  getIt.registerLazySingleton<LocalizationLocalDataSource>(
    () => LocalizationLocalDataSourceImpl(getIt<SharedPreferences>()),
  );

  // Repository
  getIt.registerLazySingleton<LocalizationRepository>(
    () => LocalizationRepositoryImpl(getIt<LocalizationLocalDataSource>()),
  );

  // Use cases
  getIt.registerLazySingleton<GetCurrentLocaleUseCase>(
    () => GetCurrentLocaleUseCase(getIt<LocalizationRepository>()),
  );

  getIt.registerLazySingleton<SetLocaleUseCase>(
    () => SetLocaleUseCase(getIt<LocalizationRepository>()),
  );

  getIt.registerLazySingleton<GetSupportedLocalesUseCase>(
    () => GetSupportedLocalesUseCase(getIt<LocalizationRepository>()),
  );

  // BLoC
  getIt.registerSingleton<LocalizationBloc>(
    LocalizationBloc(
      getCurrentLocaleUseCase: getIt<GetCurrentLocaleUseCase>(),
      setLocaleUseCase: getIt<SetLocaleUseCase>(),
      getSupportedLocalesUseCase: getIt<GetSupportedLocalesUseCase>(),
    ),
  );
}
