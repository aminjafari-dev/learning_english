// courses_content.dart
// Main content widget for the Courses page.
// Combines vocabularies section, phrases section, and refresh button.
// Uses a single scroll view for the entire content.
// Now shows a dedicated error UI when lessons fail to load, instead of showing
// errors at the bottom of vocabularies/phrases sections.

import 'package:flutter/material.dart';
import 'package:learning_english/core/widgets/global_widget/g_gap.dart';
import 'package:learning_english/features/course/presentation/widgets/section_header.dart';
import 'package:learning_english/core/widgets/vocabulary_section.dart';
import 'package:learning_english/core/widgets/phrases_list_section.dart';
import 'package:learning_english/features/course/presentation/widgets/user_preferences_display.dart';
import 'package:learning_english/features/learning_paths/domain/entities/learning_path.dart';
import 'package:learning_english/features/course/presentation/widgets/next_lessons_button.dart';
import 'package:learning_english/features/course/presentation/widgets/courses_error_widget.dart';
import 'package:learning_english/features/course/presentation/bloc/courses_state.dart';
import 'package:learning_english/l10n/app_localizations.dart';

/// Main content widget for the Courses page
/// Combines vocabularies section, phrases section, and refresh button
/// Uses a single scroll view for unified scrolling experience
/// Shows a dedicated error UI when lessons fail to load
class CoursesContent extends StatelessWidget {
  final CoursesState state;
  final String? pathId;
  final int? courseNumber;
  final LearningPath? learningPath;
  final VoidCallback? onNextLessons;

  /// Callback function triggered when retry button is pressed in error state
  final VoidCallback? onRetry;

  const CoursesContent({
    super.key,
    required this.state,
    this.pathId,
    this.courseNumber,
    this.learningPath,
    this.onNextLessons,
    this.onRetry,
  });

  /// Checks if vocabularies or phrases are in error state
  /// Returns true if either section has errors, false otherwise
  /// This ensures we show a clean error UI instead of partial content with errors
  bool _hasError() {
    return state.vocabularies.maybeWhen(
          error: (_) => true,
          orElse: () => false,
        ) ||
        state.phrases.maybeWhen(error: (_) => true, orElse: () => false);
  }

  /// Gets the error message from either vocabularies or phrases state
  /// Prefers vocabularies error message if both are available
  String _getErrorMessage() {
    return state.vocabularies.maybeWhen(
      error: (message) => message,
      orElse:
          () => state.phrases.maybeWhen(
            error: (message) => message,
            orElse: () => 'Unknown error',
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Show error UI if both vocabularies and phrases have errors
    // This ensures we show a clean error state instead of partial content
    if (_hasError()) {
      return CoursesErrorWidget(
        errorMessage: _getErrorMessage(),
        onRetry: onRetry ?? () {},
      );
    }

    // Show normal content when there's no error or only partial errors
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GGap.g16,
          // Learning Path Info Display - shows learning path level and focus areas
          LearningPathInfoDisplay(learningPath: learningPath),
          GGap.g16,
          SectionHeader(title: AppLocalizations.of(context)!.vocabularies),
          GGap.g4,
          VocabularySection(state: state.vocabularies),
          GGap.g24,
          SectionHeader(title: AppLocalizations.of(context)!.phrases),
          GGap.g8,
          PhrasesListSection(phrasesState: state.phrases),
          GGap.g16,
          // Next Lessons button (only shown when course context is available and not in error state)
          // Hide next button when there are errors
          if (!_hasError())
            NextLessonsButton(
              pathId: pathId,
              courseNumber: courseNumber,
              onNext: onNextLessons,
            ),
          GGap.g32,
        ],
      ),
    );
  }
}

// Example usage:
// CoursesContent(state: state)
