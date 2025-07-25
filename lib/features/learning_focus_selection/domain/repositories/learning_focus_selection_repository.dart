/// Abstract repository for learning focus selection feature.
///
/// Defines contract for saving and retrieving selected options.
abstract class LearningFocusSelectionRepository {
  /// Save the selected learning focus option IDs.
  Future<void> saveSelectedOptions(List<int> selectedOptionIds);

  /// Retrieve the saved selected option IDs (if any).
  Future<List<int>> getSelectedOptions();
}
