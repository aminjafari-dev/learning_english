import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import '../../domain/usecases/save_learning_focus_selection_usecase.dart';

/// State class for LearningFocusSelectionCubit.
/// Holds a set of selected option indices, custom text input, and a flag for save success.
@immutable
class LearningFocusSelectionState extends Equatable {
  final Set<int> selectedIndices;
  final String customText;
  final bool saveSuccess;
  const LearningFocusSelectionState({
    this.selectedIndices = const {},
    this.customText = '',
    this.saveSuccess = false,
  });

  LearningFocusSelectionState copyWith({
    Set<int>? selectedIndices,
    String? customText,
    bool? saveSuccess,
  }) {
    return LearningFocusSelectionState(
      selectedIndices: selectedIndices ?? this.selectedIndices,
      customText: customText ?? this.customText,
      saveSuccess: saveSuccess ?? this.saveSuccess,
    );
  }

  @override
  List<Object?> get props => [selectedIndices, customText, saveSuccess];
}

/// Cubit for managing the selection state of learning focus options.
///
/// Usage Example:
/// ```dart
/// BlocProvider(
///   create: (_) => LearningFocusSelectionCubit(saveUseCase),
///   child: LearningFocusSelectionPage(),
/// )
/// ```
class LearningFocusSelectionCubit extends Cubit<LearningFocusSelectionState> {
  final SaveLearningFocusSelectionUseCase saveUseCase;
  LearningFocusSelectionCubit(this.saveUseCase)
    : super(const LearningFocusSelectionState());

  /// Toggle selection for a given option index.
  void toggleSelection(int index) {
    final newSet = Set<int>.from(state.selectedIndices);
    if (newSet.contains(index)) {
      newSet.remove(index);
    } else {
      newSet.add(index);
    }
    emit(state.copyWith(selectedIndices: newSet, saveSuccess: false));
  }

  /// Update custom text input.
  void updateCustomText(String text) {
    emit(state.copyWith(customText: text, saveSuccess: false));
  }

  /// Clear all selections.
  void clearSelection() {
    emit(state.copyWith(selectedIndices: {}, customText: '', saveSuccess: false));
  }

  /// Save the selected options and custom text using the use case.
  Future<void> saveSelection() async {
    try {
      // Combine selected indices with custom text if provided
      final selections = state.selectedIndices.toList();
      if (state.customText.isNotEmpty) {
        // You might want to handle custom text differently in your use case
        // For now, we'll just save the selected indices
        print('📝 [CUBIT] Custom text: ${state.customText}');
      }
      await saveUseCase(selections);
      emit(state.copyWith(saveSuccess: true));
    } catch (e) {
      print('❌ [CUBIT] Error saving learning focus selection: $e');
      // You could emit an error state here if needed
      // For now, we'll just log the error
    }
  }
}
