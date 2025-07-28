import '../../domain/entities/learning_focus_selection.dart';
import '../../domain/repositories/learning_focus_selection_repository.dart';

/// Implementation of LearningFocusSelectionRepository using local storage.
/// Handles saving and retrieving a list of selected learning focus texts.
/// Replace the TODO with actual shared_preferences or persistent storage logic.
class LearningFocusSelectionRepositoryImpl
    implements LearningFocusSelectionRepository {
  LearningFocusSelection _currentSelection = const LearningFocusSelection();

  @override
  Future<void> saveLearningFocusSelection(LearningFocusSelection selection) async {
    try {
      // TODO: Replace with shared_preferences or persistent storage
      // Example with shared_preferences:
      // final prefs = await SharedPreferences.getInstance();
      // await prefs.setStringList('learning_focus_texts', selection.selectedTexts);
      
      _currentSelection = selection;
      print('💾 [REPOSITORY] Saved learning focus selection: $selection');
    } catch (e) {
      throw Exception('Failed to save learning focus selection: ${e.toString()}');
    }
  }

  @override
  Future<LearningFocusSelection> getLearningFocusSelection() async {
    try {
      // TODO: Replace with shared_preferences or persistent storage
      // Example with shared_preferences:
      // final prefs = await SharedPreferences.getInstance();
      // final texts = prefs.getStringList('learning_focus_texts') ?? [];
      // return LearningFocusSelection(selectedTexts: texts);
      
      print('📖 [REPOSITORY] Retrieved learning focus selection: $_currentSelection');
      return _currentSelection;
    } catch (e) {
      throw Exception('Failed to get learning focus selection: ${e.toString()}');
    }
  }

  @override
  Future<void> clearLearningFocusSelection() async {
    try {
      // TODO: Replace with shared_preferences or persistent storage
      // Example with shared_preferences:
      // final prefs = await SharedPreferences.getInstance();
      // await prefs.remove('learning_focus_texts');
      
      _currentSelection = const LearningFocusSelection();
      print('🗑️ [REPOSITORY] Cleared learning focus selection');
    } catch (e) {
      throw Exception('Failed to clear learning focus selection: ${e.toString()}');
    }
  }
}
