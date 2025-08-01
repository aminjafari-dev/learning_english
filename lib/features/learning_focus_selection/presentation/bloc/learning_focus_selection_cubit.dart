import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import '../../domain/entities/learning_focus_selection.dart';
import '../../domain/usecases/get_learning_focus_selection_usecase.dart';
import '../../domain/usecases/save_learning_focus_selection_usecase.dart';

/// State class for LearningFocusSelectionCubit.
/// Holds a list of selected texts, custom text input, and a flag for save success.
@immutable
class LearningFocusSelectionState extends Equatable {
  final List<String> selectedTexts;
  final String customText;
  final bool saveSuccess;
  final bool isLoading;
  final String? errorMessage;

  const LearningFocusSelectionState({
    this.selectedTexts = const [],
    this.customText = '',
    this.saveSuccess = false,
    this.isLoading = false,
    this.errorMessage,
  });

  LearningFocusSelectionState copyWith({
    List<String>? selectedTexts,
    String? customText,
    bool? saveSuccess,
    bool? isLoading,
    String? errorMessage,
  }) {
    return LearningFocusSelectionState(
      selectedTexts: selectedTexts ?? this.selectedTexts,
      customText: customText ?? this.customText,
      saveSuccess: saveSuccess ?? this.saveSuccess,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    selectedTexts,
    customText,
    saveSuccess,
    isLoading,
    errorMessage,
  ];
}

/// Cubit for managing the selection state of learning focus options.
///
/// Usage Example:
/// ```dart
/// BlocProvider(
///   create: (_) => LearningFocusSelectionCubit(saveUseCase, getUseCase),
///   child: LearningFocusSelectionPage(),
/// )
/// ```
class LearningFocusSelectionCubit extends Cubit<LearningFocusSelectionState> {
  final SaveLearningFocusSelectionUseCase saveUseCase;
  final GetLearningFocusSelectionUseCase getUseCase;

  LearningFocusSelectionCubit({
    required this.saveUseCase,
    required this.getUseCase,
  }) : super(const LearningFocusSelectionState());

  /// Load the previously saved learning focus selection.
  Future<void> loadSavedSelection() async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));

      final savedSelection = await getUseCase();

      emit(
        state.copyWith(
          selectedTexts: savedSelection.selectedTexts,
          isLoading: false,
        ),
      );

      print('📖 [CUBIT] Loaded saved selection: $savedSelection');
    } catch (e) {
      print('❌ [CUBIT] Error loading saved selection: $e');
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to load saved selection: $e',
        ),
      );
    }
  }

  /// Update the custom text input without adding it to selections yet.
  void updateCustomText(String text) {
    emit(state.copyWith(customText: text, errorMessage: null));
    print('✏️ [CUBIT] Updated custom text: "$text"');
  }

  /// Add a text to the selection (from predefined options or custom text).
  void addText(String text) {
    if (text.trim().isNotEmpty && !state.selectedTexts.contains(text.trim())) {
      final newTexts = [...state.selectedTexts, text.trim()];
      emit(
        state.copyWith(
          selectedTexts: newTexts,
          saveSuccess: false,
          errorMessage: null,
        ),
      );
      print('➕ [CUBIT] Added text to selection: "${text.trim()}"');
    }
  }

  /// Remove a text from the selection.
  void removeText(String text) {
    final newTexts = state.selectedTexts.where((t) => t != text).toList();
    emit(
      state.copyWith(
        selectedTexts: newTexts,
        saveSuccess: false,
        errorMessage: null,
      ),
    );
    print('➖ [CUBIT] Removed text from selection: "$text"');
  }

  /// Toggle selection for a given option text.
  void toggleText(String text) {
    if (state.selectedTexts.contains(text)) {
      removeText(text);
    } else {
      addText(text);
    }
  }

  /// Clear all selections.
  void clearSelection() {
    emit(
      state.copyWith(
        selectedTexts: [],
        customText: '',
        saveSuccess: false,
        errorMessage: null,
      ),
    );
    print('🗑️ [CUBIT] Cleared all selections');
  }

  /// Save the selected texts using the use case.
  /// This method will also add any custom text to the selection before saving.
  Future<void> saveSelection() async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));

      // Create a list that includes both selected texts and custom text (if any)
      List<String> allTexts = [...state.selectedTexts];

      // Add custom text if it's not empty and not already in selections
      if (state.customText.trim().isNotEmpty &&
          !state.selectedTexts.contains(state.customText.trim())) {
        allTexts.add(state.customText.trim());
      }

      // Create the learning focus selection
      final selection = LearningFocusSelection(selectedTexts: allTexts);

      print('💾 [CUBIT] Saving selection: $selection');
      await saveUseCase(selection);

      emit(state.copyWith(saveSuccess: true, isLoading: false));

      print('✅ [CUBIT] Successfully saved learning focus selection');
    } catch (e) {
      print('❌ [CUBIT] Error saving learning focus selection: $e');
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to save selection: $e',
        ),
      );
    }
  }

  /// Get the combined content of selected texts.
  String get combinedContent {
    return state.selectedTexts.join('; ');
  }

  /// Check if the current selection is empty.
  bool get isEmpty =>
      state.selectedTexts.isEmpty && state.customText.trim().isEmpty;

  /// Check if the current selection has any content.
  bool get isNotEmpty => !isEmpty;

  /// Check if a specific text is selected.
  bool isTextSelected(String text) {
    return state.selectedTexts.contains(text);
  }
}
