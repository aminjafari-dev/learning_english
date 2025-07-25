// level_selection_header.dart
// Header widget for the Level Selection page.
// Displays the title and subtitle for level selection.

import 'package:flutter/material.dart';
import 'package:learning_english/core/widgets/g_text.dart';
import 'package:learning_english/core/widgets/g_gap.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Header widget for the Level Selection page
/// Displays the main title for level selection
class LevelSelectionHeader extends StatelessWidget {
  const LevelSelectionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        Center(
          child: GText(
            l10n.levelSelectionTitle,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
        ),
        GGap.g24,
      ],
    );
  }
}

// Example usage:
// LevelSelectionHeader()
