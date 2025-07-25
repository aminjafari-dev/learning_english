import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import '../../domain/usecases/save_learning_focus_selection_usecase.dart';

/// State class for LearningFocusSelectionCubit.
/// Holds a set of selected option indices and a flag for save success.
@immutable
class LearningFocusSelectionState extends Equatable {
  final Set<int> selectedIndices;
  final bool saveSuccess;
  const LearningFocusSelectionState({
    this.selectedIndices = const {},
    this.saveSuccess = false,
  });

  LearningFocusSelectionState copyWith({
    Set<int>? selectedIndices,
    bool? saveSuccess,
  }) {
    return LearningFocusSelectionState(
      selectedIndices: selectedIndices ?? this.selectedIndices,
      saveSuccess: saveSuccess ?? this.saveSuccess,
    );
  }

  @override
  List<Object?> get props => [selectedIndices, saveSuccess];
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

  /// Clear all selections.
  void clearSelection() {
    emit(state.copyWith(selectedIndices: {}, saveSuccess: false));
  }

  /// Save the selected options using the use case.
  Future<void> saveSelection() async {
    await saveUseCase(state.selectedIndices.toList());
    emit(state.copyWith(saveSuccess: true));
  }
}
