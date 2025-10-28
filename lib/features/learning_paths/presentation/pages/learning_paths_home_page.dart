// learning_paths_home_page.dart
// Main page for the Learning Paths feature
// Shows either empty state or course grid based on whether user has an active path

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_english/core/dependency%20injection/locator.dart';
import 'package:learning_english/core/theme/app_theme.dart';
import 'package:learning_english/core/widgets/global_widget/g_scaffold.dart';
import 'package:learning_english/core/widgets/global_widget/g_text.dart';
import 'package:learning_english/core/router/page_name.dart';
import 'package:learning_english/l10n/app_localizations.dart';
import '../bloc/learning_paths_bloc.dart';
import '../bloc/learning_paths_event.dart';
import '../bloc/learning_paths_state.dart';
import '../widgets/empty_path_card.dart';
import '../widgets/course_grid.dart';
import '../widgets/learning_path_card.dart';
import '../widgets/small_add_learning_path_card.dart';
import 'learning_path_detail_page.dart';

/// Main page for the Learning Paths feature
/// Shows either empty state or course grid based on whether user has an active path
class LearningPathsHomePage extends StatefulWidget {
  const LearningPathsHomePage({super.key});

  @override
  State<LearningPathsHomePage> createState() => _LearningPathsHomePageState();
}

class _LearningPathsHomePageState extends State<LearningPathsHomePage> {
  late final LearningPathsBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = getIt<LearningPathsBloc>();
    _bloc.add(const LearningPathsEvent.loadAllPaths());
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
      ),
      backgroundColor: AppTheme.background(context),
      body: BlocBuilder<LearningPathsBloc, LearningPathsState>(
        bloc: _bloc,
        builder: (context, state) {
          return state.when(
            initial: () => _buildEmptyState(),
            loadingSubCategories: () => _buildLoadingState(),
            subCategoriesLoaded: (subCategories) => _buildEmptyState(),
            allPathsLoaded:
                (learningPaths) => _buildAllPathsLoadedState(learningPaths),
            pathLoaded: (learningPath) => _buildPathLoadedState(learningPath),
            courseCompleted:
                (courseNumber, updatedPath) =>
                    _buildPathLoadedState(updatedPath),
            pathDeleted: () => _buildEmptyState(),
            error: (message) => _buildErrorState(message),
          );
        },
      ),
    );
  }

  /// Builds the empty state when no learning path exists
  Widget _buildEmptyState() {
    return EmptyPathCard(onTap: () => _navigateToSubCategorySelection());
  }

  /// Builds the state when all learning paths are loaded
  Widget _buildAllPathsLoadedState(List<dynamic> learningPaths) {
    return RefreshIndicator(
      onRefresh: () async {
        _bloc.add(const LearningPathsEvent.loadAllPaths());
      },
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: learningPaths.length + 1, // +1 for the add card
        itemBuilder: (context, index) {
          if (index == 0) {
            // Add new learning path card at the top - use smaller version when paths exist
            return SmallAddLearningPathCard(
              onTap: () => _navigateToSubCategorySelection(),
            );
          } else {
            // Learning path cards
            final learningPath = learningPaths[index - 1];
            return LearningPathCard(
              learningPath: learningPath,
              onTap: () => _navigateToLearningPathDetail(learningPath.id),
              onDelete: () => _showDeleteDialog(learningPath.id),
            );
          }
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
          // Path header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primary(context).withOpacity(0.1),
                  AppTheme.primary(context).withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
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
                const SizedBox(height: 8),
                GText(
                  learningPath.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.text(context).withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 16),
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
                          const SizedBox(height: 4),
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
                    const SizedBox(width: 16),
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

          const SizedBox(height: 24),

          // Course grid
          CourseGrid(
            learningPath: learningPath,
            onCourseTap: (courseNumber) => _navigateToCourse(courseNumber),
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
          const SizedBox(height: 16),
          GText(
            message,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _bloc.add(const LearningPathsEvent.refresh()),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  /// Navigates to level selection to start the learning path creation flow
  void _navigateToSubCategorySelection() {
    Navigator.of(context).pushNamed(PageName.levelSelection);
  }

  /// Navigates to learning path detail page
  void _navigateToLearningPathDetail(String pathId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LearningPathDetailPage(pathId: pathId),
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
