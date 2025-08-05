// level_selection_content.dart
// Main content widget for the Level Selection page.
// Now only combines header and level options list since level selection is immediate.

import 'package:flutter/material.dart';
import 'package:learning_english/features/level_selection/presentation/widgets/level_options_list.dart';
import 'package:learning_english/features/level_selection/domain/entities/user_profile.dart';
import 'package:learning_english/features/level_selection/presentation/blocs/level_state.dart';

/// Main content widget for the Level Selection page
/// Now only combines header and level options list since level selection is immediate
/// The continue button has been removed as level selection now happens automatically
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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LevelOptionsList(selectedLevel: selectedLevel, state: state),
          // Continue button removed - level selection now happens immediately
          // when user taps on any level option
        ],
      ),
    );
  }
}

// Example usage:
// LevelSelectionContent(state: state, selectedLevel: selectedLevel)
