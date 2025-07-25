// LevelSelectionPage allows users to select their English proficiency level.
// Usage: Navigated to after Google sign-in. Saves selection to Firestore and navigates to subject selection.
// Example:
//   Navigator.of(context).pushNamed(PageName.levelSelection);

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_english/core/router/page_name.dart';
import 'package:learning_english/core/widgets/g_scaffold.dart';
import 'package:learning_english/core/widgets/g_text.dart';
import 'package:learning_english/core/widgets/g_button.dart';
import 'package:learning_english/core/widgets/g_gap.dart';
import 'package:learning_english/features/level_selection/presentation/widgets/level_option_card.dart';
import 'package:learning_english/features/level_selection/domain/entities/user_profile.dart';
import 'package:learning_english/features/level_selection/presentation/blocs/level_bloc.dart';
import 'package:learning_english/features/level_selection/presentation/blocs/level_event.dart';
import 'package:learning_english/features/level_selection/presentation/blocs/level_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:learning_english/core/dependency%20injection/locator.dart';
// import 'package:learning_english/core/constants/page_name.dart'; // Uncomment and use your actual PageName class

/// LevelSelectionPage allows users to select their English proficiency level.
/// Now retrieves userId from local storage using GetUserIdUseCase (DI), not via constructor.
class LevelSelectionPage extends StatelessWidget {
  const LevelSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocConsumer<LevelBloc, LevelState>(
      bloc: getIt<LevelBloc>(),
      listener: (context, state) {
        state.when(
          initial: () {},
          selectionMade: (_) {},
          loading: (_) {},
          success: (_) {
            // Navigate to the learning focus selection page after level selection
            Navigator.of(context).pushNamed(PageName.learningFocusSelection);
          },
          error: (message, _) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: GText(message)));
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
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: GText(
                    l10n.levelSelectionTitle,
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
                GGap.g24,
                // Beginner
                LevelOptionCard(
                  title: l10n.levelBeginner,
                  subtitle: l10n.levelBeginnerDesc,
                  selected: selectedLevel == Level.beginner,
                  onTap:
                      () => getIt<LevelBloc>().add(
                        const LevelEvent.levelSelected(Level.beginner),
                      ),
                ),
                // Elementary
                LevelOptionCard(
                  title: l10n.levelElementary,
                  subtitle: l10n.levelElementaryDesc,
                  selected: selectedLevel == Level.elementary,
                  onTap:
                      () => getIt<LevelBloc>().add(
                        const LevelEvent.levelSelected(Level.elementary),
                      ),
                ),
                // Intermediate
                LevelOptionCard(
                  title: l10n.levelIntermediate,
                  subtitle: l10n.levelIntermediateDesc,
                  selected: selectedLevel == Level.intermediate,
                  onTap:
                      () => getIt<LevelBloc>().add(
                        const LevelEvent.levelSelected(Level.intermediate),
                      ),
                ),
                // Advanced
                LevelOptionCard(
                  title: l10n.levelAdvanced,
                  subtitle: l10n.levelAdvancedDesc,
                  selected: selectedLevel == Level.advanced,
                  onTap:
                      () => getIt<LevelBloc>().add(
                        const LevelEvent.levelSelected(Level.advanced),
                      ),
                ),
                const Spacer(),
                state.when(
                  initial:
                      () => GButton(
                        text: l10n.continue_,
                        onPressed: null,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                          backgroundColor: Theme.of(context).disabledColor,
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                  selectionMade:
                      (level) => GButton(
                        text: l10n.continue_,
                        onPressed:
                            () => getIt<LevelBloc>().add(
                              const LevelEvent.levelSubmitted(),
                            ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                  loading:
                      (level) =>
                          const Center(child: CircularProgressIndicator()),
                  success:
                      (level) => GButton(
                        text: l10n.continue_,
                        onPressed:
                            () => getIt<LevelBloc>().add(
                              const LevelEvent.levelSubmitted(),
                            ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                  error:
                      (message, level) => GButton(
                        text: l10n.continue_,
                        onPressed:
                            level == null
                                ? null
                                : () => getIt<LevelBloc>().add(
                                  const LevelEvent.levelSubmitted(),
                                ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                          backgroundColor:
                              level == null
                                  ? Theme.of(context).disabledColor
                                  : Theme.of(context).colorScheme.primary,
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
