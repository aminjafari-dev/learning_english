import 'package:flutter/material.dart';
import 'package:learning_english/core/dependency%20injection/locator.dart';
import 'package:learning_english/core/widgets/global_widget/g_scaffold.dart';
import 'package:learning_english/core/widgets/global_widget/g_text.dart';
import 'package:learning_english/core/widgets/global_widget/g_gap.dart';
import 'package:learning_english/l10n/app_localizations.dart';
import 'package:learning_english/core/widgets/global_widget/g_text_form_field.dart';
import 'package:learning_english/features/learning_focus_selection/presentation/widgets/continue_button.dart';
import 'package:learning_english/features/learning_focus_selection/presentation/widgets/learnin_focus_option_grid.dart';
import '../bloc/learning_focus_selection_cubit.dart';

/// The main page for selecting learning focus options.
///
/// Usage Example:
/// ```dart
/// Navigator.of(context).pushNamed(PageName.learningFocusSelection);
/// ```
/// This page displays a title, a back button, a grid of selectable options, and a continue button.
/// Custom text input is tracked separately and only added to selections when the continue button is pressed.
class LearningFocusSelectionPage extends StatefulWidget {
  final String? selectedLevel;

  const LearningFocusSelectionPage({super.key, this.selectedLevel});

  @override
  State<LearningFocusSelectionPage> createState() =>
      _LearningFocusSelectionPageState();
}

class _LearningFocusSelectionPageState
    extends State<LearningFocusSelectionPage> {
  late TextEditingController _customTextController;

  @override
  void initState() {
    super.initState();
    _customTextController = TextEditingController();
  }

  @override
  void dispose() {
    _customTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GScaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top section: Title and Back Button
            Row(
              children: [
                // Back button with localized text
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.arrow_back_ios_new_rounded, size: 24),
                ),
                // Title
                GText(
                  l10n.learningFocusTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),

            GGap.g16,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GTextFormField(
                controller: _customTextController,
                hintText: l10n.learningFocusCustomHint,
                labelText: l10n.learningFocusCustomLabel,
                onChanged: (value) {
                  // Only update the custom text in the cubit state, don't add to selections yet
                  getIt<LearningFocusSelectionCubit>().updateCustomText(value);
                },
              ),
            ),
            GGap.g16,
            // Grid of learning focus options with selection logic
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: LearningFocusOptionsGrid(),
              ),
            ),
            // Continue button at the bottom, enabled only if at least one option is selected or custom text is entered
            SafeArea(
              minimum: const EdgeInsets.all(16),
              child: ContinueButton(selectedLevel: widget.selectedLevel),
            ),
          ],
        ),
      ),
    );
  }
}
