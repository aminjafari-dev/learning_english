// LevelSelectionPage allows users to select their English proficiency level.
// Usage: Navigated to after Google sign-in. Saves selection to Firestore and navigates to subject selection.
// Example:
//   Navigator.of(context).pushNamed(PageName.levelSelection);

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_english/core/router/page_name.dart';
import 'package:learning_english/core/theme/app_theme.dart';
import 'package:learning_english/core/widgets/global_widget/g_scaffold.dart';
import 'package:learning_english/core/widgets/global_widget/g_text.dart';
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
    return BlocBuilder<LevelBloc, LevelState>(
      bloc: getIt<LevelBloc>(),
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
            backgroundColor: AppTheme.surface(context),
            foregroundColor: AppTheme.text(context),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
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
