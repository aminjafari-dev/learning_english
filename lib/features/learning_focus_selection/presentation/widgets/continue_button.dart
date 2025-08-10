import 'package:flutter/material.dart';
import 'package:learning_english/core/dependency%20injection/locator.dart';
import 'package:learning_english/features/learning_focus_selection/presentation/bloc/learning_focus_selection_cubit.dart';
import 'package:learning_english/core/router/page_name.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_english/core/widgets/global_widget/g_button.dart';
import 'package:learning_english/l10n/app_localizations.dart';

/// Continue button widget that enables navigation to the next page.
///
/// This button is enabled when there are selected texts or custom text input.
/// When pressed, it saves the selection (including custom text) and navigates to the daily lessons page.
class ContinueButton extends StatelessWidget {
  const ContinueButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<
      LearningFocusSelectionCubit,
      LearningFocusSelectionState
    >(
      bloc: getIt<LearningFocusSelectionCubit>(),
      builder: (context, state) {
        // Enable button if there are any selected texts or custom text
        final isEnabled =
            state.selectedTexts.isNotEmpty ||
            state.customText.trim().isNotEmpty;
        return GButton(
          text: l10n.continue_,
          onPressed:
              isEnabled
                  ? () {
                    getIt<LearningFocusSelectionCubit>().saveSelection();
                    Navigator.of(context).pushNamed(PageName.dailyLessons);
                  }
                  : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
            minimumSize: const Size.fromHeight(56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        );
      },
    );
  }
}
