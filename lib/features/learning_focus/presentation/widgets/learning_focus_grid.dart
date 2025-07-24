// learning_focus_grid.dart
// Widget for displaying a grid of learning focus options.
//
// Usage Example:
//   LearningFocusGrid(
//     options: learningFocusOptions,
//     onFocusSelected: (type) => bloc.add(LearningFocusEvent.toggleSelection(type)),
//   );
//
// This widget displays all learning focus options in a responsive grid layout.

import 'package:flutter/material.dart';
import '../../domain/entities/learning_focus.dart';
import 'learning_focus_card.dart';

class LearningFocusGrid extends StatelessWidget {
  final List<LearningFocus> options;
  final Function(LearningFocusType) onFocusSelected;

  const LearningFocusGrid({
    super.key,
    required this.options,
    required this.onFocusSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: options.length,
      itemBuilder: (context, index) {
        final option = options[index];
        return LearningFocusCard(
          learningFocus: option,
          onTap: () => onFocusSelected(option.type),
        );
      },
    );
  }
}
