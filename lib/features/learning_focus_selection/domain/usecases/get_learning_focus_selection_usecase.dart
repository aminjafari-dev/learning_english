import '../entities/learning_focus_selection.dart';
import '../repositories/learning_focus_selection_repository.dart';

/// Use case for retrieving the saved learning focus selection.
///
/// Usage Example:
///   final selection = await getLearningFocusSelectionUseCase();
///   print('Selected texts: ${selection.selectedTexts}');
class GetLearningFocusSelectionUseCase {
  final LearningFocusSelectionRepository repository;
  GetLearningFocusSelectionUseCase(this.repository);

  Future<LearningFocusSelection> call() async {
    try {
      print('🎯 [USE_CASE] Retrieving learning focus selection');
      final selection = await repository.getLearningFocusSelection();
      print('✅ [USE_CASE] Retrieved learning focus selection: $selection');
      return selection;
    } catch (e) {
      print('❌ [USE_CASE] Failed to retrieve learning focus selection: $e');
      throw Exception(
        'Failed to retrieve learning focus selection: ${e.toString()}',
      );
    }
  }
}
