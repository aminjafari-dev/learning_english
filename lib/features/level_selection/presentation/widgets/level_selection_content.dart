// level_selection_content.dart
// Main content widget for the Level Selection page.
// Combines header, level options list, and continue button.

import 'package:flutter/material.dart';
import 'package:learning_english/features/level_selection/presentation/widgets/level_selection_header.dart';
import 'package:learning_english/features/level_selection/presentation/widgets/level_options_list.dart';
import 'package:learning_english/features/level_selection/presentation/widgets/level_selection_button.dart';
import 'package:learning_english/features/level_selection/domain/entities/user_profile.dart';
import 'package:learning_english/features/level_selection/presentation/blocs/level_state.dart';

/// Main content widget for the Level Selection page
/// Combines header, level options list, and continue button
class LevelSelectionContent extends StatelessWidget {
  final LevelState state;
  final Level? selectedLevel;

  const LevelSelectionContent({
    super.key,
    required this.state,
    required this.selectedLevel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const LevelSelectionHeader(),
        LevelOptionsList(selectedLevel: selectedLevel),
        const Spacer(),
        LevelSelectionButton(state: state),
      ],
    );
  }
}

// Example usage:
// LevelSelectionContent(state: state, selectedLevel: selectedLevel)
