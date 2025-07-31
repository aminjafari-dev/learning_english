// LevelSelectionPage allows users to select their English proficiency level.
// Usage: Navigated to after Google sign-in. Saves selection to Firestore and navigates to subject selection.
// Example:
//   Navigator.of(context).pushNamed(PageName.levelSelection);

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_english/core/router/page_name.dart';
import 'package:learning_english/core/theme/app_theme.dart';
import 'package:learning_english/core/widgets/g_scaffold.dart';
import 'package:learning_english/core/widgets/g_text.dart';
import 'package:learning_english/features/level_selection/presentation/widgets/level_selection_content.dart';
import 'package:learning_english/features/level_selection/domain/entities/user_profile.dart';
import 'package:learning_english/features/level_selection/presentation/blocs/level_bloc.dart';
import 'package:learning_english/features/level_selection/presentation/blocs/level_state.dart';
import 'package:learning_english/core/dependency%20injection/locator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// LevelSelectionPage allows users to select their English proficiency level.
/// Now navigates immediately when a level is selected, without waiting for Firebase response.
/// Errors are handled silently without showing anything to the user.
class LevelSelectionPage extends StatelessWidget {
  const LevelSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LevelBloc, LevelState>(
      bloc: getIt<LevelBloc>(),
      listener: (context, state) {
        state.when(
          initial: () {},
          selectionMade: (_) {},
          loading: (_) {},
          success: (_) {
            // Navigate to the learning focus selection page immediately when level is selected
            Navigator.of(context).pushNamed(PageName.learningFocusSelection);
          },
          error: (message, _) {
            // Errors are handled silently - no UI feedback to user
            // Firebase operations happen in background and errors are logged only
          },
        );
      },
      builder: (context, state) {
        // Extract selected level from any state that has it
        Level? selectedLevel = state.when(
          initial: () => null,
          selectionMade: (level) => level,
          loading: (level) => level,
          success: (level) => level,
          error: (message, level) => level,
        );

        return GScaffold(


      appBar: AppBar(
        title: GText(
          AppLocalizations.of(context)!.levelSelectionTitle,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        backgroundColor: AppTheme.surface,
        foregroundColor: AppTheme.white,
      ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
            child: LevelSelectionContent(
              state: state,
              selectedLevel: selectedLevel,
            ),
          ),
        );
      },
    );
  }
}
