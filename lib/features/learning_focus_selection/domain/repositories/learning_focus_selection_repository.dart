import '../entities/learning_focus_selection.dart';

/// Abstract repository for learning focus selection feature.
///
/// Defines contract for saving and retrieving selected learning focus texts.
abstract class LearningFocusSelectionRepository {
  /// Save the learning focus selection (list of selected texts).
  Future<void> saveLearningFocusSelection(LearningFocusSelection selection);

  /// Retrieve the saved learning focus selection.
  Future<LearningFocusSelection> getLearningFocusSelection();

  /// Clear all saved learning focus selections.
  Future<void> clearLearningFocusSelection();
}
