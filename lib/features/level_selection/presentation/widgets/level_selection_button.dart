// level_selection_button.dart
// Continue button widget for the Level Selection page.
// Changes appearance and behavior based on the current state.

import 'package:flutter/material.dart';
import 'package:learning_english/core/widgets/g_button.dart';
import 'package:learning_english/features/level_selection/domain/entities/user_profile.dart';
import 'package:learning_english/features/level_selection/presentation/blocs/level_bloc.dart';
import 'package:learning_english/features/level_selection/presentation/blocs/level_event.dart';
import 'package:learning_english/features/level_selection/presentation/blocs/level_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:learning_english/core/dependency%20injection/locator.dart';

/// Continue button widget for the Level Selection page
/// Changes appearance and behavior based on the current state
class LevelSelectionButton extends StatelessWidget {
  final LevelState state;

  const LevelSelectionButton({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bloc = getIt<LevelBloc>();

    return state.when(
      initial: () => _buildDisabledButton(context, l10n.continue_),
      selectionMade:
          (level) => _buildEnabledButton(
            context,
            l10n.continue_,
            () => bloc.add(const LevelEvent.levelSubmitted()),
          ),
      loading: (level) => const Center(child: CircularProgressIndicator()),
      success:
          (level) => _buildEnabledButton(
            context,
            l10n.continue_,
            () => bloc.add(const LevelEvent.levelSubmitted()),
          ),
      error:
          (message, level) => _buildConditionalButton(
            context,
            l10n.continue_,
            level,
            () => bloc.add(const LevelEvent.levelSubmitted()),
          ),
    );
  }

  /// Builds a disabled button (when no level is selected)
  Widget _buildDisabledButton(BuildContext context, String text) {
    return GButton(
      text: text,
      onPressed: null,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        backgroundColor: Theme.of(context).disabledColor,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  /// Builds an enabled button (when level is selected)
  Widget _buildEnabledButton(
    BuildContext context,
    String text,
    VoidCallback onPressed,
  ) {
    return GButton(
      text: text,
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  /// Builds a conditional button (enabled/disabled based on level)
  Widget _buildConditionalButton(
    BuildContext context,
    String text,
    Level? level,
    VoidCallback onPressed,
  ) {
    return GButton(
      text: text,
      onPressed: level == null ? null : onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        backgroundColor:
            level == null
                ? Theme.of(context).disabledColor
                : Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

// Example usage:
// LevelSelectionButton(state: state)
