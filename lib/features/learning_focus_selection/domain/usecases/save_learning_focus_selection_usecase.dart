import '../repositories/learning_focus_selection_repository.dart';

/// Use case for saving selected learning focus options.
///
/// Usage Example:
///   await saveLearningFocusSelectionUseCase([1, 2, 3]);
class SaveLearningFocusSelectionUseCase {
  final LearningFocusSelectionRepository repository;
  SaveLearningFocusSelectionUseCase(this.repository);

  Future<void> call(List<int> selectedOptionIds) async {
    try {
      await repository.saveSelectedOptions(selectedOptionIds);
    } catch (e) {
      throw Exception(
        'Failed to save learning focus selection: ${e.toString()}',
      );
    }
  }
}
