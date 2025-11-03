// courses_page.dart
// Main page for the Courses feature.
// This page displays vocabularies, phrases, and lesson sections, using Bloc for state management.
// Now supports course-specific content when launched from learning paths.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_english/core/dependency%20injection/locator.dart';
import 'package:learning_english/core/widgets/global_widget/g_scaffold.dart';
import 'package:learning_english/core/theme/app_theme.dart';
import 'package:learning_english/features/course/presentation/bloc/courses_bloc.dart';
import 'package:learning_english/features/course/presentation/bloc/courses_event.dart';
import 'package:learning_english/features/course/presentation/bloc/courses_state.dart';
import 'package:learning_english/features/course/presentation/widgets/courses_content.dart';
import 'package:learning_english/features/course/presentation/widgets/course_header.dart';
import 'package:learning_english/features/learning_paths/domain/entities/learning_path.dart';
import 'package:learning_english/core/router/page_name.dart';

/// The main Courses page widget.
/// Can be used for general courses or course-specific content.
class CoursesPage extends StatefulWidget {
  /// Optional course context for personalized content
  final String? pathId;
  final int? courseNumber;
  final LearningPath? learningPath;

  const CoursesPage({
    super.key,
    this.pathId,
    this.courseNumber,
    this.learningPath,
  });

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  CoursesBloc? _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = getIt<CoursesBloc>();
    _fetchLessons();
  }

  @override
  void didUpdateWidget(CoursesPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Fetch lessons when course number or pathId changes
    // This ensures data is refreshed when navigating to a new course
    if (widget.courseNumber != oldWidget.courseNumber ||
        widget.pathId != oldWidget.pathId) {
      _fetchLessons();
    }
  }

  /// Fetches lessons based on the current context
  /// Only fetches when course context actually changes to avoid duplicate requests
  void _fetchLessons() {
    if (_bloc == null) return;

    // Fetch lessons based on context
    if (widget.pathId != null &&
        widget.courseNumber != null &&
        widget.learningPath != null) {
      // Course-specific content (can be new or review of completed course)
      _bloc!.add(
        CoursesEvent.fetchLessonsWithCourseContext(
          pathId: widget.pathId!,
          courseNumber: widget.courseNumber!,
          learningPath: widget.learningPath!,
        ),
      );
    } else {
      // General courses
      _bloc!.add(const CoursesEvent.fetchLessons());
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = _bloc!;

    return GScaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.background(context),
        elevation: 0,
        title: CoursesHeader(
          pathId: widget.pathId,
          courseNumber: widget.courseNumber,
          isCompleted:
              widget.learningPath?.courses
                  .where((course) => course.courseNumber == widget.courseNumber)
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
        child: BlocListener<CoursesBloc, CoursesState>(
          bloc: bloc,
          listener: (context, state) {
            // Handle course completion
            state.courseCompletion.when(
              initial: () {},
              loading: () {},
              completed: (pathId, courseNumber) {
                // After completing current course, navigate to the next course lesson
                // final nextCourse = courseNumber + 1;
                // WidgetsBinding.instance.addPostFrameCallback((_) {
                //   if (context.mounted && widget.learningPath != null) {
                //     Navigator.of(context).pushReplacementNamed(
                //       PageName.courses,
                //       arguments: {
                //         'pathId': pathId,
                //         'courseNumber': nextCourse,
                //         'learningPath': widget.learningPath,
                //       },
                //     );
                //   }
                // });
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
          child: BlocBuilder<CoursesBloc, CoursesState>(
            bloc: bloc,
            builder: (context, state) {
              // Check if current course is already completed
              final currentCourse =
                  widget.learningPath?.courses
                      .where(
                        (course) => course.courseNumber == widget.courseNumber,
                      )
                      .firstOrNull;
              final isCurrentCourseCompleted =
                  currentCourse?.isCompleted ?? false;

              return CoursesContent(
                state: state,
                pathId: widget.pathId,
                courseNumber: widget.courseNumber,
                learningPath: widget.learningPath,
                onNextLessons: () {
                  if (widget.pathId != null &&
                      widget.courseNumber != null &&
                      widget.learningPath != null) {
                    // If course is already completed, navigate directly to next course

                    final nextCourse = widget.courseNumber! + 1;
                    Navigator.of(context).pushReplacementNamed(
                      PageName.courses,
                      arguments: {
                        'pathId': widget.pathId,
                        'courseNumber': nextCourse,
                        'learningPath': widget.learningPath,
                      },
                    );

                    // If not completed, complete it first
                    // Navigation will happen in the BlocListener when completion succeeds
                    bloc.add(
                      CoursesEvent.completeCourse(
                        pathId: widget.pathId!,
                        courseNumber: widget.courseNumber!,
                      ),
                    );
                  }
                },
                // Retry callback - triggers appropriate fetch event based on context
                onRetry: () {
                  if (widget.pathId != null &&
                      widget.courseNumber != null &&
                      widget.learningPath != null) {
                    // Retry with course-specific context
                    bloc.add(
                      CoursesEvent.fetchLessonsWithCourseContext(
                        pathId: widget.pathId!,
                        courseNumber: widget.courseNumber!,
                        learningPath: widget.learningPath!,
                      ),
                    );
                  } else {
                    // Retry general lessons
                    bloc.add(const CoursesEvent.fetchLessons());
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

// Example usage:
// Navigator.of(context).pushNamed(PageName.courses);
