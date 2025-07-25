// level_options_list.dart
// Widget that displays all level option cards in a list.
// Handles level selection and displays selected state.

import 'package:flutter/material.dart';
import 'package:learning_english/features/level_selection/presentation/widgets/level_option_card.dart';
import 'package:learning_english/features/level_selection/domain/entities/user_profile.dart';
import 'package:learning_english/features/level_selection/presentation/blocs/level_bloc.dart';
import 'package:learning_english/features/level_selection/presentation/blocs/level_event.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:learning_english/core/dependency%20injection/locator.dart';

/// Widget that displays all level option cards
/// Handles level selection and displays selected state
class LevelOptionsList extends StatelessWidget {
  final Level? selectedLevel;

  const LevelOptionsList({super.key, required this.selectedLevel});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bloc = getIt<LevelBloc>();

    return Column(
      children: [
        // Beginner
        LevelOptionCard(
          title: l10n.levelBeginner,
          subtitle: l10n.levelBeginnerDesc,
          selected: selectedLevel == Level.beginner,
          onTap: () => bloc.add(const LevelEvent.levelSelected(Level.beginner)),
        ),
        // Elementary
        LevelOptionCard(
          title: l10n.levelElementary,
          subtitle: l10n.levelElementaryDesc,
          selected: selectedLevel == Level.elementary,
          onTap:
              () => bloc.add(const LevelEvent.levelSelected(Level.elementary)),
        ),
        // Intermediate
        LevelOptionCard(
          title: l10n.levelIntermediate,
          subtitle: l10n.levelIntermediateDesc,
          selected: selectedLevel == Level.intermediate,
          onTap:
              () =>
                  bloc.add(const LevelEvent.levelSelected(Level.intermediate)),
        ),
        // Advanced
        LevelOptionCard(
          title: l10n.levelAdvanced,
          subtitle: l10n.levelAdvancedDesc,
          selected: selectedLevel == Level.advanced,
          onTap: () => bloc.add(const LevelEvent.levelSelected(Level.advanced)),
        ),
      ],
    );
  }
}

// Example usage:
// LevelOptionsList(selectedLevel: selectedLevel)
