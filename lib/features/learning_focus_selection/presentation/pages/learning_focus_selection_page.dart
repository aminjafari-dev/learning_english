import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_english/core/widgets/g_scaffold.dart';
import 'package:learning_english/core/widgets/g_text.dart';
import 'package:learning_english/core/widgets/g_gap.dart';
import 'package:learning_english/core/widgets/g_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../widgets/learning_focus_option_card.dart';
import '../bloc/learning_focus_selection_cubit.dart';
import '../../domain/usecases/save_learning_focus_selection_usecase.dart';
import '../../data/repositories/learning_focus_selection_repository_impl.dart';

/// The main page for selecting learning focus options.
///
/// Usage Example:
/// ```dart
/// Navigator.of(context).pushNamed(PageName.learningFocusSelection);
/// ```
/// This page displays a title, a back button, a grid of selectable options, and a continue button.
class LearningFocusSelectionPage extends StatelessWidget {
  const LearningFocusSelectionPage({Key? key}) : super(key: key);

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

    // Set up repository and use case for DI (in real app, use getIt or similar)
    final repository = LearningFocusSelectionRepositoryImpl();
    final saveUseCase = SaveLearningFocusSelectionUseCase(repository);

    return BlocProvider(
      create: (_) => LearningFocusSelectionCubit(saveUseCase),
      child: GScaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top section: Title and Back Button
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Title
                    GText(
                      l10n.learningFocusTitle,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Back button with localized text
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: GText(
                        l10n.learningFocusBack,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
              GGap.v16,
              // Grid of learning focus options with selection logic
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: BlocBuilder<
                    LearningFocusSelectionCubit,
                    LearningFocusSelectionState
                  >(
                    builder: (context, state) {
                      return GridView.builder(
                        itemCount: options.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                              childAspectRatio: 2.6,
                            ),
                        itemBuilder: (context, index) {
                          final option = options[index];
                          final selected = state.selectedIndices.contains(
                            index,
                          );
                          // Only one line of text per card, so pass the same string for both title and subtitle
                          return LearningFocusOptionCard(
                            icon: option.icon,
                            title: option.title,
                            subtitle: '',
                            selected: selected,
                            onTap: () {
                              context
                                  .read<LearningFocusSelectionCubit>()
                                  .toggleSelection(index);
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              // Continue button at the bottom, enabled only if at least one option is selected
              SafeArea(
                minimum: const EdgeInsets.all(16),
                child: BlocConsumer<
                  LearningFocusSelectionCubit,
                  LearningFocusSelectionState
                >(
                  listenWhen:
                      (prev, curr) => curr.saveSuccess && !prev.saveSuccess,
                  listener: (context, state) {
                    // Show localized SnackBar after save
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.learningFocusSavedSnack)),
                    );
                    // TODO: Replace with actual navigation
                  },
                  builder: (context, state) {
                    final isEnabled = state.selectedIndices.isNotEmpty;
                    return GButton(
                      text: l10n.continue_,
                      onPressed:
                          isEnabled
                              ? () {
                                context
                                    .read<LearningFocusSelectionCubit>()
                                    .saveSelection();
                              }
                              : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        textStyle: Theme.of(
                          context,
                        ).textTheme.bodyLarge?.copyWith(
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Private helper class to represent a learning focus option.
class _LearningFocusOption {
  final IconData icon;
  final String title;
  const _LearningFocusOption(this.icon, this.title);
}
