import 'package:flutter/material.dart';
import 'package:learning_english/core/dependency%20injection/locator.dart';
import 'package:learning_english/features/learning_focus_selection/presentation/bloc/learning_focus_selection_cubit.dart';
import 'package:learning_english/core/router/page_name.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_english/core/widgets/g_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ContinueButton extends StatelessWidget {
  const ContinueButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocConsumer<
      LearningFocusSelectionCubit,
      LearningFocusSelectionState
    >(
      bloc: getIt<LearningFocusSelectionCubit>(),
      listenWhen: (prev, curr) => curr.saveSuccess && !prev.saveSuccess,
      listener: (context, state) {
        // Navigate to Daily Lessons page after successful save
        Navigator.of(context).pushNamed(PageName.dailyLessons);
      },
      builder: (context, state) {
        // Enable button if there are any selected texts
        final isEnabled = state.selectedTexts.isNotEmpty;
        return GButton(
          text: l10n.continue_,
          onPressed:
              isEnabled
                  ? () {
                    getIt<LearningFocusSelectionCubit>().saveSelection();
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
