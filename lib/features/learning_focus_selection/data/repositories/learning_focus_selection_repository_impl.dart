import '../../domain/repositories/learning_focus_selection_repository.dart';

/// Implementation of LearningFocusSelectionRepository using local storage.
/// Replace the TODO with actual shared_preferences or persistent storage logic.
class LearningFocusSelectionRepositoryImpl
    implements LearningFocusSelectionRepository {
  List<int> _selectedOptionIds = [];

  @override
  Future<void> saveSelectedOptions(List<int> selectedOptionIds) async {
    // TODO: Replace with shared_preferences or persistent storage
    _selectedOptionIds = List<int>.from(selectedOptionIds);
  }

  @override
  Future<List<int>> getSelectedOptions() async {
    // TODO: Replace with shared_preferences or persistent storage
    return _selectedOptionIds;
  }
}
