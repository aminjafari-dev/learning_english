/// Entity representing a learning focus selection in the domain layer.
/// Stores a list of strings that includes both selected option texts and custom text.
///
/// Usage Example:
///   final selection = LearningFocusSelection(
///     selectedTexts: ['Business English', 'Medical Terminology', 'Custom focus area'],
///   );
class LearningFocusSelection {
  final List<String> selectedTexts;

  const LearningFocusSelection({this.selectedTexts = const []});

  /// Check if the selection is empty
  bool get isEmpty => selectedTexts.isEmpty;

  /// Check if the selection has any content
  bool get isNotEmpty => !isEmpty;

  /// Get all selected content as a combined string
  String get combinedContent {
    return selectedTexts.join('; ');
  }

  /// Add a text to the selection
  LearningFocusSelection addText(String text) {
    if (text.trim().isNotEmpty && !selectedTexts.contains(text.trim())) {
      return copyWith(selectedTexts: [...selectedTexts, text.trim()]);
    }
    return this;
  }

  /// Remove a text from the selection
  LearningFocusSelection removeText(String text) {
    return copyWith(
      selectedTexts: selectedTexts.where((t) => t != text).toList(),
    );
  }

  /// Clear all selections
  LearningFocusSelection clear() {
    return const LearningFocusSelection();
  }

  LearningFocusSelection copyWith({List<String>? selectedTexts}) {
    return LearningFocusSelection(
      selectedTexts: selectedTexts ?? this.selectedTexts,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LearningFocusSelection &&
        other.selectedTexts.length == selectedTexts.length &&
        other.selectedTexts.every((text) => selectedTexts.contains(text));
  }

  @override
  int get hashCode => Object.hashAll(selectedTexts);

  @override
  String toString() {
    return 'LearningFocusSelection(selectedTexts: $selectedTexts)';
  }
}
