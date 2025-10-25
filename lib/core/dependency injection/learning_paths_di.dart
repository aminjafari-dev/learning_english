// learning_paths_di.dart
// Dependency injection setup for the Learning Paths feature
// Registers all services, repositories, use cases, and blocs

import 'package:get_it/get_it.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../features/learning_paths/data/datasources/local/learning_paths_local_data_source.dart';
import '../../features/learning_paths/data/datasources/remote/sub_category_generation_service.dart';
import '../../features/learning_paths/data/repositories/learning_paths_repository_impl.dart';
import '../../features/learning_paths/data/repositories/sub_categories_repository_impl.dart';
import '../../features/learning_paths/domain/repositories/learning_paths_repository.dart';
import '../../features/learning_paths/domain/repositories/sub_categories_repository.dart';
import '../../features/learning_paths/domain/usecases/create_learning_path_usecase.dart';
import '../../features/learning_paths/domain/usecases/get_active_learning_path_usecase.dart';
import '../../features/learning_paths/domain/usecases/complete_course_usecase.dart';
import '../../features/learning_paths/domain/usecases/generate_sub_categories_usecase.dart';
import '../../features/learning_paths/domain/usecases/delete_learning_path_usecase.dart';
import '../../features/learning_paths/presentation/bloc/learning_paths_bloc.dart';

// Import the generated adapters
import '../../features/learning_paths/data/models/learning_path_model.dart';
import '../../features/learning_paths/data/models/course_model.dart';
import '../../features/learning_paths/data/models/sub_category_model.dart';

/// Initialize all learning paths dependencies
Future<void> initLearningPathsDependencies(GetIt getIt) async {
  // Register Hive adapters for the models
  if (!Hive.isAdapterRegistered(4)) {
    Hive.registerAdapter(SubCategoryModelAdapter());
  }
  if (!Hive.isAdapterRegistered(10)) {
    Hive.registerAdapter(LearningPathModelAdapter());
  }
  if (!Hive.isAdapterRegistered(11)) {
    Hive.registerAdapter(CourseModelAdapter());
  }

  // Data Sources
  getIt.registerLazySingleton<LearningPathsLocalDataSource>(
    () => LearningPathsLocalDataSource(),
  );

  getIt.registerLazySingleton<SubCategoryGenerationService>(
    () => SubCategoryGenerationService(dotenv.env['GEMINI_API_KEY'] ?? ''),
  );

  // Repositories
  getIt.registerLazySingleton<LearningPathsRepository>(
    () => LearningPathsRepositoryImpl(localDataSource: getIt()),
  );

  getIt.registerLazySingleton<SubCategoriesRepository>(
    () => SubCategoriesRepositoryImpl(
      generationService: getIt<SubCategoryGenerationService>(),
    ),
  );

  // Use Cases
  getIt.registerLazySingleton<CreateLearningPathUseCase>(
    () => CreateLearningPathUseCase(repository: getIt()),
  );

  getIt.registerLazySingleton<GetActiveLearningPathUseCase>(
    () => GetActiveLearningPathUseCase(repository: getIt()),
  );

  getIt.registerLazySingleton<CompleteCourseUseCase>(
    () => CompleteCourseUseCase(repository: getIt()),
  );

  getIt.registerLazySingleton<GenerateSubCategoriesUseCase>(
    () => GenerateSubCategoriesUseCase(repository: getIt()),
  );

  getIt.registerLazySingleton<DeleteLearningPathUseCase>(
    () => DeleteLearningPathUseCase(repository: getIt()),
  );

  // BLoC
  getIt.registerFactory<LearningPathsBloc>(
    () => LearningPathsBloc(
      createLearningPathUseCase: getIt(),
      getActiveLearningPathUseCase: getIt(),
      completeCourseUseCase: getIt(),
      generateSubCategoriesUseCase: getIt(),
      deleteLearningPathUseCase: getIt(),
    ),
  );

  // Initialize local data source
  await getIt<LearningPathsLocalDataSource>().initialize();

  print('✅ [LEARNING_PATHS_DI] All dependencies registered successfully');
}
