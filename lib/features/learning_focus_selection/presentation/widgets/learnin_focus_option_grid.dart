import 'package:flutter/material.dart';
import 'package:learning_english/core/dependency%20injection/locator.dart';
import 'package:learning_english/features/learning_focus_selection/presentation/bloc/learning_focus_selection_cubit.dart';
import 'package:learning_english/features/learning_focus_selection/presentation/widgets/learning_focus_option_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LearningFocusOptionsGrid extends StatelessWidget {
  const LearningFocusOptionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // List of static learning focus options with icons and localized labels
    final options = [
      _LearningFocusOption(Icons.work, l10n.learningFocusBusiness),
      _LearningFocusOption(Icons.flight, l10n.learningFocusTravel),
      _LearningFocusOption(Icons.people, l10n.learningFocusSocial),
      _LearningFocusOption(Icons.home, l10n.learningFocusHome),
      _LearningFocusOption(Icons.menu_book, l10n.learningFocusAcademic),
      _LearningFocusOption(Icons.movie, l10n.learningFocusMovie),
      _LearningFocusOption(Icons.music_note, l10n.learningFocusMusic),
      _LearningFocusOption(Icons.tv, l10n.learningFocusTV),
      _LearningFocusOption(Icons.shopping_bag, l10n.learningFocusShopping),
      _LearningFocusOption(Icons.restaurant, l10n.learningFocusRestaurant),
      _LearningFocusOption(Icons.favorite, l10n.learningFocusHealth),
      _LearningFocusOption(Icons.emoji_emotions, l10n.learningFocusEveryday),
    ];
    return BlocBuilder<
      LearningFocusSelectionCubit,
      LearningFocusSelectionState
    >(
      bloc: getIt<LearningFocusSelectionCubit>(),
      builder: (context, state) {
        return GridView.builder(
          itemCount: options.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 2, // Reduced for more vertical space
          ),
          itemBuilder: (context, index) {
            final option = options[index];
            // Check if this option's text is selected in the state
            final selected = state.selectedTexts.contains(option.title);
            // Only one line of text per card, so pass the same string for both title and subtitle
            return LearningFocusOptionCard(
              icon: option.icon,
              title: option.title,
              subtitle: '',
              selected: selected,
              onTap: () {
                // Toggle the selection of this option's text
                getIt<LearningFocusSelectionCubit>().toggleText(option.title);
              },
            );
          },
        );
      },
    );
  }
}

/// Private helper class to represent a learning focus option.
class _LearningFocusOption {
  final IconData icon;
  final String title;
  const _LearningFocusOption(this.icon, this.title);
}
