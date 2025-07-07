// LevelSelectionPage allows users to select their English proficiency level.
// Usage: Navigated to after Google sign-in. Saves selection to Firestore and navigates to subject selection.
// Example:
//   Navigator.of(context).pushNamed(PageName.levelSelection);

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:learning_english/core/locator.dart';
// import 'package:learning_english/core/constants/page_name.dart'; // Uncomment and use your actual PageName class

class LevelSelectionPage extends StatelessWidget {
  /// The user's Firebase UID. Pass this from the previous page after sign-in.
  final String userId;
  const LevelSelectionPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocProvider<LevelBloc>(
      create: (_) => getIt<LevelBloc>(),
      child: BlocConsumer<LevelBloc, LevelState>(
        listener: (context, state) {
          if (state is LevelSuccess) {
            // TODO: Replace with your actual subject selection route
            Navigator.of(context).pushReplacementNamed('/subjectSelection');
          } else if (state is LevelError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: GText(state.message)));
          }
        },
        builder: (context, state) {
          Level? selectedLevel;
          if (state is LevelSelectionMade) {
            selectedLevel = state.level;
          } else if (state is LevelInitial) {
            selectedLevel = null;
          }
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
                  GGap.v24,
                  // Beginner
                  LevelOptionCard(
                    title: l10n.levelBeginner,
                    subtitle: l10n.levelBeginnerDesc,
                    selected: selectedLevel == Level.beginner,
                    onTap:
                        () => context.read<LevelBloc>().add(
                          const LevelEvent.levelSelected(Level.beginner),
                        ),
                  ),
                  // Elementary
                  LevelOptionCard(
                    title: l10n.levelElementary,
                    subtitle: l10n.levelElementaryDesc,
                    selected: selectedLevel == Level.elementary,
                    onTap:
                        () => context.read<LevelBloc>().add(
                          const LevelEvent.levelSelected(Level.elementary),
                        ),
                  ),
                  // Intermediate
                  LevelOptionCard(
                    title: l10n.levelIntermediate,
                    subtitle: l10n.levelIntermediateDesc,
                    selected: selectedLevel == Level.intermediate,
                    onTap:
                        () => context.read<LevelBloc>().add(
                          const LevelEvent.levelSelected(Level.intermediate),
                        ),
                  ),
                  // Advanced
                  LevelOptionCard(
                    title: l10n.levelAdvanced,
                    subtitle: l10n.levelAdvancedDesc,
                    selected: selectedLevel == Level.advanced,
                    onTap:
                        () => context.read<LevelBloc>().add(
                          const LevelEvent.levelSelected(Level.advanced),
                        ),
                  ),
                  const Spacer(),
                  if (state is LevelLoading)
                    const Center(child: CircularProgressIndicator())
                  else
                    GButton(
                      text: l10n.continue_,
                      onPressed:
                          selectedLevel == null
                              ? null
                              : () => context.read<LevelBloc>().add(
                                LevelEvent.levelSubmitted(userId),
                              ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                        backgroundColor:
                            selectedLevel == null
                                ? Theme.of(context).disabledColor
                                : Theme.of(context).colorScheme.primary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
