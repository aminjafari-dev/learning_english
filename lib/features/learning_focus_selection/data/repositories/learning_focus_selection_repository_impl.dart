import '../../domain/repositories/learning_focus_selection_repository.dart';

/// Implementation of LearningFocusSelectionRepository using local storage.
/// Replace the TODO with actual shared_preferences or persistent storage logic.
class LearningFocusSelectionRepositoryImpl
    implements LearningFocusSelectionRepository {
  List<int> _selectedOptionIds = [];

  @override
  Future<void> saveSelectedOptions(List<int> selectedOptionIds) async {
    try {
      // TODO: Replace with shared_preferences or persistent storage
      _selectedOptionIds = List<int>.from(selectedOptionIds);
    } catch (e) {
      throw Exception('Failed to save selected options: ${e.toString()}');
    }
  }

  @override
  Future<List<int>> getSelectedOptions() async {
    try {
      // TODO: Replace with shared_preferences or persistent storage
      return _selectedOptionIds;
    } catch (e) {
      throw Exception('Failed to get selected options: ${e.toString()}');
    }
  }
}
