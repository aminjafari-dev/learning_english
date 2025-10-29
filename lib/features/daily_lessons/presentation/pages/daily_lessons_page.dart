// daily_lessons_page.dart
// Main page for the Daily Lessons feature.
// This page displays vocabularies, phrases, and lesson sections, using Bloc for state management.
// Now supports course-specific content when launched from learning paths.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_english/core/dependency%20injection/locator.dart';
import 'package:learning_english/core/widgets/global_widget/g_scaffold.dart';
import 'package:learning_english/core/theme/app_theme.dart';
import 'package:learning_english/features/daily_lessons/presentation/bloc/daily_lessons_bloc.dart';
import 'package:learning_english/features/daily_lessons/presentation/bloc/daily_lessons_event.dart';
import 'package:learning_english/features/daily_lessons/presentation/bloc/daily_lessons_state.dart';
import 'package:learning_english/features/daily_lessons/presentation/widgets/daily_lessons_header.dart';
import 'package:learning_english/features/daily_lessons/presentation/widgets/daily_lessons_content.dart';
import 'package:learning_english/features/learning_paths/domain/entities/learning_path.dart';

/// The main Daily Lessons page widget.
/// Can be used for general daily lessons or course-specific content.
class DailyLessonsPage extends StatelessWidget {
  /// Optional course context for personalized content
  final String? pathId;
  final int? courseNumber;
  final LearningPath? learningPath;

  const DailyLessonsPage({
    super.key,
    this.pathId,
    this.courseNumber,
    this.learningPath,
  });

  @override
  Widget build(BuildContext context) {
    // Use getIt for dependency injection instead of BlocProvider in the UI
    final bloc = getIt<DailyLessonsBloc>();

    // Fetch lessons based on context
    if (pathId != null && courseNumber != null && learningPath != null) {
      // Course-specific content (can be new or review of completed course)
      bloc.add(
        DailyLessonsEvent.fetchLessonsWithCourseContext(
          pathId: pathId!,
          courseNumber: courseNumber!,
          learningPath: learningPath!,
        ),
      );
    } else {
      // General daily lessons
      bloc.add(const DailyLessonsEvent.fetchLessons());
    }

    // Always fetch user preferences for personalization
    bloc.add(const DailyLessonsEvent.getUserPreferences());

    return GScaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.background(context),
        elevation: 0,
        title: DailyLessonsHeader(
          pathId: pathId,
          courseNumber: courseNumber,
          isCompleted:
              learningPath?.courses
                  .where((course) => course.courseNumber == courseNumber)
                  .firstOrNull
                  ?.isCompleted,
        ),
        leading:
        // Back button with localized text
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 24),
        ),
        centerTitle: true,
      ),
      backgroundColor: AppTheme.background(context),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocListener<DailyLessonsBloc, DailyLessonsState>(
          bloc: bloc,
          listener: (context, state) {
            // Handle course completion
            state.courseCompletion.when(
              initial: () {},
              loading: () {},
              completed: (pathId, courseNumber) {
                // Show success message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Course $courseNumber completed successfully!',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );

                // Navigate back to learning path detail with result indicating course completion
                // Use addPostFrameCallback to defer navigation until after the current frame completes
                // This prevents the "Navigator is locked" error
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (context.mounted) {
                    Navigator.of(context).pop(true);
                  }
                });
              },
              error: (message) {
                // Show error message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error completing course: $message'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
            );
          },
          child: BlocBuilder<DailyLessonsBloc, DailyLessonsState>(
            bloc: bloc,
            builder: (context, state) {
              return DailyLessonsContent(
                state: state,
                pathId: pathId,
                courseNumber: courseNumber,
                onCompleteCourse: () {
                  if (pathId != null && courseNumber != null) {
                    bloc.add(
                      DailyLessonsEvent.completeCourse(
                        pathId: pathId!,
                        courseNumber: courseNumber!,
                      ),
                    );
                  }
                },
                isCompletingCourse: state.courseCompletion.maybeWhen(
                  loading: () => true,
                  orElse: () => false,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// Example usage:
// Navigator.of(context).pushNamed(PageName.dailyLessons);
