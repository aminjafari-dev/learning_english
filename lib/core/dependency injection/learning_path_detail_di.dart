// learning_path_detail_di.dart
// Dependency injection setup for Learning Path Detail feature
// Registers all dependencies needed for the learning path detail functionality

import 'package:get_it/get_it.dart';
import '../../features/learning_path_detail/data/datasources/local/learning_path_detail_local_data_source.dart';
import '../../features/learning_path_detail/data/repositories/learning_path_detail_repository_impl.dart';
import '../../features/learning_path_detail/domain/repositories/learning_path_detail_repository.dart';
import '../../features/learning_path_detail/domain/usecases/get_learning_path_by_id_usecase.dart';
import '../../features/learning_path_detail/domain/usecases/complete_course_usecase.dart';
import '../../features/learning_path_detail/domain/usecases/delete_learning_path_by_id_usecase.dart';
import '../../features/learning_path_detail/domain/usecases/get_progress_statistics_usecase.dart';
import '../../features/learning_path_detail/presentation/bloc/learning_path_detail_bloc.dart';

/// Sets up dependency injection for Learning Path Detail feature
/// Registers all dependencies needed for the learning path detail functionality
Future<void> setupLearningPathDetailLocator(GetIt locator) async {
  // Data Sources
  locator.registerLazySingleton<LearningPathDetailLocalDataSource>(
    () => LearningPathDetailLocalDataSource(),
  );

  // Repositories
  locator.registerLazySingleton<LearningPathDetailRepository>(
    () => LearningPathDetailRepositoryImpl(
      localDataSource: locator<LearningPathDetailLocalDataSource>(),
    ),
  );

  // Use Cases
  locator.registerLazySingleton<GetLearningPathByIdUseCase>(
    () => GetLearningPathByIdUseCase(
      repository: locator<LearningPathDetailRepository>(),
    ),
  );

  locator.registerLazySingleton<CompleteCourseUseCase>(
    () => CompleteCourseUseCase(
      repository: locator<LearningPathDetailRepository>(),
    ),
  );

  locator.registerLazySingleton<DeleteLearningPathByIdUseCase>(
    () => DeleteLearningPathByIdUseCase(
      repository: locator<LearningPathDetailRepository>(),
    ),
  );

  locator.registerLazySingleton<GetProgressStatisticsUseCase>(
    () => GetProgressStatisticsUseCase(
      repository: locator<LearningPathDetailRepository>(),
    ),
  );

  // BLoC
  locator.registerFactory<LearningPathDetailBloc>(
    () => LearningPathDetailBloc(
      getLearningPathByIdUseCase: locator<GetLearningPathByIdUseCase>(),
      completeCourseUseCase: locator<CompleteCourseUseCase>(),
      deleteLearningPathByIdUseCase: locator<DeleteLearningPathByIdUseCase>(),
    ),
  );

  print('✅ [LEARNING_PATH_DETAIL_DI] All dependencies registered successfully');
}
