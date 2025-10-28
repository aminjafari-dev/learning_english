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
import 'package:learning_english/l10n/app_localizations.dart';
import '../bloc/learning_paths_bloc.dart';
import '../bloc/learning_paths_event.dart';
import '../bloc/learning_paths_state.dart';
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
  late final LearningPathsBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = getIt<LearningPathsBloc>();
    _bloc.add(LearningPathsEvent.loadPathById(pathId: widget.pathId));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GScaffold(
      appBar: AppBar(
        title: GText(
          l10n.learningPaths,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        backgroundColor: AppTheme.surface(context),
        foregroundColor: AppTheme.text(context),
        actions: [
          // Refresh button
          IconButton(
            onPressed:
                () => _bloc.add(
                  LearningPathsEvent.loadPathById(pathId: widget.pathId),
                ),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      backgroundColor: AppTheme.background(context),
      body: BlocBuilder<LearningPathsBloc, LearningPathsState>(
        bloc: _bloc,
        builder: (context, state) {
          return state.when(
            initial: () => _buildLoadingState(),
            loadingSubCategories: () => _buildLoadingState(),
            subCategoriesLoaded: (subCategories) => _buildLoadingState(),
            allPathsLoaded: (learningPaths) => _buildLoadingState(),
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
                    GGap.g16,
                    // Delete button
                    IconButton(
                      onPressed: () => _showDeleteDialog(learningPath.id),
                      icon: const Icon(Icons.delete_outline),
                      color: Colors.red,
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
          Icon(Icons.check_circle_outline, size: 64, color: Colors.green),
          GGap.g16,
          GText(
            'Learning path deleted successfully',
            style: Theme.of(context).textTheme.titleMedium,
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
                  LearningPathsEvent.loadPathById(pathId: widget.pathId),
                ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  /// Navigates to a specific course
  void _navigateToCourse(int courseNumber) {
    // TODO: Navigate to daily lessons page with course context
    // This will be implemented when we enhance the daily lessons integration
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Starting Course $courseNumber...'),
        backgroundColor: AppTheme.primary(context),
      ),
    );
  }

  /// Shows delete confirmation dialog
  void _showDeleteDialog(String pathId) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Learning Path'),
            content: const Text(
              'Are you sure you want to delete this learning path? This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _bloc.add(LearningPathsEvent.deletePath(pathId: pathId));
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }
}
