import '../entities/learning_focus_selection.dart';
import '../repositories/learning_focus_selection_repository.dart';

/// Use case for saving learning focus selection (list of selected texts).
///
/// Usage Example:
///   final selection = LearningFocusSelection(
///     selectedTexts: ['Business English', 'Medical Terminology'],
///   );
///   await saveLearningFocusSelectionUseCase(selection);
class SaveLearningFocusSelectionUseCase {
  final LearningFocusSelectionRepository repository;
  SaveLearningFocusSelectionUseCase(this.repository);

  Future<void> call(LearningFocusSelection selection) async {
    try {
      print('🎯 [USE_CASE] Saving learning focus selection: $selection');
      await repository.saveLearningFocusSelection(selection);
      print('✅ [USE_CASE] Successfully saved learning focus selection');
    } catch (e) {
      print('❌ [USE_CASE] Failed to save learning focus selection: $e');
      throw Exception(
        'Failed to save learning focus selection: ${e.toString()}',
      );
    }
  }
}
