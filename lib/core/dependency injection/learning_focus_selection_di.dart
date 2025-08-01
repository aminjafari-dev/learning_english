import 'package:get_it/get_it.dart';
import 'package:learning_english/features/learning_focus_selection/data/repositories/learning_focus_selection_repository_impl.dart';
import 'package:learning_english/features/learning_focus_selection/domain/repositories/learning_focus_selection_repository.dart';
import 'package:learning_english/features/learning_focus_selection/domain/usecases/get_learning_focus_selection_usecase.dart';
import 'package:learning_english/features/learning_focus_selection/domain/usecases/save_learning_focus_selection_usecase.dart';
import 'package:learning_english/features/learning_focus_selection/presentation/bloc/learning_focus_selection_cubit.dart';

/// Dependency injection setup for the Learning Focus Selection feature.
///
/// Registers repository, use cases, and Cubit for use throughout the app.
///
/// Usage Example:
///   await setupLearningFocusSelectionLocator(GetIt.I);
Future<void> setupLearningFocusSelectionDI(GetIt getIt) async {
  try {
    // Register repository implementation as the interface
    getIt.registerLazySingleton<LearningFocusSelectionRepository>(
      () => LearningFocusSelectionRepositoryImpl(),
    );

    // Register use case for saving learning focus selection
    getIt.registerFactory<SaveLearningFocusSelectionUseCase>(
      () => SaveLearningFocusSelectionUseCase(getIt()),
    );

    // Register use case for getting learning focus selection
    getIt.registerFactory<GetLearningFocusSelectionUseCase>(
      () => GetLearningFocusSelectionUseCase(getIt()),
    );

    // Register Cubit for managing selection state
    getIt.registerSingleton(
      LearningFocusSelectionCubit(saveUseCase: getIt(), getUseCase: getIt()),
    );

    print(
      '✅ [DI] Learning Focus Selection dependencies registered successfully',
    );
  } catch (e) {
    print('❌ [DI] Error setting up Learning Focus Selection dependencies: $e');
    rethrow; // Re-throw to let the caller handle the error
  }
}
