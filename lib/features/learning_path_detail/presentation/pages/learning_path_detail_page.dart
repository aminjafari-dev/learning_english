// learning_path_detail_page.dart
// Detail page for a specific learning path
// Shows learning path information and course grid

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_english/core/dependency%20injection/locator.dart';
import 'package:learning_english/core/theme/app_theme.dart';
import 'package:learning_english/core/widgets/global_widget/g_scaffold.dart';
import 'package:learning_english/core/widgets/global_widget/g_text.dart';
import 'package:learning_english/core/widgets/global_widget/g_gap.dart';
import 'package:learning_english/core/router/page_name.dart';
import 'package:learning_english/l10n/app_localizations.dart';
import 'package:learning_english/features/learning_paths/domain/entities/learning_path.dart';
import '../bloc/learning_path_detail_bloc.dart';
import '../bloc/learning_path_detail_event.dart';
import '../bloc/learning_path_detail_state.dart';
import '../widgets/course_grid.dart';

/// Detail page for a specific learning path
/// Shows learning path information and course grid
class LearningPathDetailPage extends StatefulWidget {
  final String pathId;

  const LearningPathDetailPage({super.key, required this.pathId});

  @override
  State<LearningPathDetailPage> createState() => _LearningPathDetailPageState();
}

class _LearningPathDetailPageState extends State<LearningPathDetailPage> {
  late final LearningPathDetailBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = getIt<LearningPathDetailBloc>();
    _bloc.add(LearningPathDetailEvent.loadPathById(pathId: widget.pathId));
  }

  /// Refreshes the learning path data
  /// This method is called when the page needs to refresh
  void _refreshLearningPath() {
    _bloc.add(LearningPathDetailEvent.loadPathById(pathId: widget.pathId));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    _refreshLearningPath();
    return GScaffold(
      appBar: AppBar(
        title: GText(
          l10n.learningPaths,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        backgroundColor: AppTheme.surface(context),
        foregroundColor: AppTheme.text(context),
        // Removed refresh button - page now refreshes automatically
      ),
      backgroundColor: AppTheme.background(context),
      body: BlocBuilder<LearningPathDetailBloc, LearningPathDetailState>(
        bloc: _bloc,
        builder: (context, state) {
          return state.when(
            initial: () => _buildLoadingState(),
            loading: () => _buildLoadingState(),
            pathLoaded: (learningPath) => _buildPathLoadedState(learningPath),
            courseCompleted:
                (courseNumber, updatedPath) =>
                    _buildPathLoadedState(updatedPath),
            pathDeleted: () => _buildPathDeletedState(),
            error: (message) => _buildErrorState(message),
          );
        },
      ),
    );
  }

  /// Builds the loading state
  Widget _buildLoadingState() {
    return const Center(child: CircularProgressIndicator());
  }

  /// Builds the state when a learning path is loaded
  Widget _buildPathLoadedState(learningPath) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Learning path header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.surface(context),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GText(
                  learningPath.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.text(context),
                  ),
                ),
                GGap.g8,
                GText(
                  learningPath.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.text(context).withOpacity(0.7),
                  ),
                ),
                GGap.g16,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Progress indicator
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GText(
                            'Progress',
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(
                              color: AppTheme.text(context).withOpacity(0.6),
                            ),
                          ),
                          GGap.g8,
                          LinearProgressIndicator(
                            value: learningPath.progressPercentage / 100,
                            backgroundColor: Colors.grey.withOpacity(0.3),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.primary(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          GGap.g24,

          // Course grid
          CourseGrid(
            learningPath: learningPath,
            onCourseTap: (courseNumber) => _navigateToCourse(courseNumber),
          ),
        ],
      ),
    );
  }

  /// Builds the path deleted state
  Widget _buildPathDeletedState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, size: 64, color: Colors.green),
          GGap.g16,
          GText(
            'Learning path deleted successfully',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          GGap.g16,
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }

  /// Builds the error state
  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red),
          GGap.g16,
          GText(
            message,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          GGap.g16,
          ElevatedButton(
            onPressed:
                () => _bloc.add(
                  LearningPathDetailEvent.loadPathById(pathId: widget.pathId),
                ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  /// Navigates to a specific course
  void _navigateToCourse(int courseNumber) async {
    // Get the current learning path from the state
    final currentState = _bloc.state;
    LearningPath? learningPath;

    currentState.when(
      initial: () {},
      loading: () {},
      pathLoaded: (path) => learningPath = path,
      courseCompleted: (courseNum, updatedPath) => learningPath = updatedPath,
      pathDeleted: () {},
      error: (message) {},
    );

    if (learningPath != null) {
      // Navigate to daily lessons page with course context
      final result = await Navigator.of(context).pushNamed(
        PageName.courses,
        arguments: {
          'pathId': learningPath!.id,
          'courseNumber': courseNumber,
          'learningPath': learningPath!,
        },
      );

      // If a course was completed, refresh the learning path data
      if (result == true) {
        _refreshLearningPath();
      }
    } else {
      // Fallback if learning path is not available
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to start course. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
