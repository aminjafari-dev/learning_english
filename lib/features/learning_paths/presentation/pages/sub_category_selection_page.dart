// sub_category_selection_page.dart
// Page for selecting AI-generated sub-categories
// Shows generated sub-categories and allows user to select one to create a learning path

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
import '../widgets/sub_category_card.dart';
import '../../domain/entities/sub_category.dart';
import '../../../level_selection/domain/entities/user_profile.dart';

/// Page for selecting AI-generated sub-categories
/// Shows generated sub-categories and allows user to select one to create a learning path
class SubCategorySelectionPage extends StatefulWidget {
  final String? selectedLevel;
  final List<String>? focusAreas;

  const SubCategorySelectionPage({
    super.key,
    this.selectedLevel,
    this.focusAreas,
  });

  @override
  State<SubCategorySelectionPage> createState() =>
      _SubCategorySelectionPageState();
}

class _SubCategorySelectionPageState extends State<SubCategorySelectionPage> {
  late final LearningPathsBloc _bloc;
  SubCategory? _selectedSubCategory;

  @override
  void initState() {
    super.initState();
    _bloc = getIt<LearningPathsBloc>();

    // Get level and focus areas from the previous pages
    final level = _parseLevel(widget.selectedLevel ?? 'intermediate');
    final focusAreas = widget.focusAreas ?? ['general'];

    _bloc.add(
      LearningPathsEvent.generateSubCategories(
        level: level,
        focusAreas: focusAreas,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GScaffold(
      appBar: AppBar(
        title: GText(
          l10n.selectSubCategory,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        backgroundColor: AppTheme.surface(context),
        foregroundColor: AppTheme.text(context),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      backgroundColor: AppTheme.background(context),
      body: BlocListener<LearningPathsBloc, LearningPathsState>(
        bloc: _bloc,
        listener: (context, state) {
          state.when(
            initial: () {},
            loadingSubCategories: () {},
            subCategoriesLoaded: (subCategories) {},
            allPathsLoaded: (learningPaths) {},
            pathLoaded: (learningPath) {
              // Navigate to learning paths home page when path is created
              Navigator.of(context).pushNamedAndRemoveUntil(
                PageName.learningPathsHome,
                (route) => false,
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Learning path "${learningPath.title}" created successfully!',
                  ),
                  backgroundColor: Colors.green,
                ),
              );
            },
            courseCompleted: (courseNumber, updatedPath) {},
            pathDeleted: () {},
            error: (message) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message), backgroundColor: Colors.red),
              );
            },
          );
        },
        child: BlocBuilder<LearningPathsBloc, LearningPathsState>(
          bloc: _bloc,
          builder: (context, state) {
            return state.when(
              initial: () => _buildLoadingState(),
              loadingSubCategories: () => _buildLoadingState(),
              subCategoriesLoaded:
                  (subCategories) => _buildSubCategoriesList(subCategories),
              allPathsLoaded: (learningPaths) => _buildLoadingState(),
              pathLoaded: (learningPath) => _buildLoadingState(),
              courseCompleted:
                  (courseNumber, updatedPath) => _buildLoadingState(),
              pathDeleted: () => _buildLoadingState(),
              error: (message) => _buildErrorState(message),
            );
          },
        ),
      ),
      bottomNavigationBar:
          _selectedSubCategory != null
              ? Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.surface(context),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _createLearningPath,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary(context),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: GText(
                        l10n.continueText,
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              )
              : null,
    );
  }

  /// Builds the loading state
  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Generating sub-categories...'),
        ],
      ),
    );
  }

  /// Builds the list of sub-categories
  Widget _buildSubCategoriesList(List<SubCategory> subCategories) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          GText(
            'Choose Your Focus Area',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.text(context),
            ),
          ),
          const SizedBox(height: 8),
          GText(
            'Select a sub-category to start your learning journey',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.text(context).withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 24),

          // Sub-categories list
          ...subCategories.map((subCategory) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: SubCategoryCard(
                subCategory: subCategory,
                isSelected: _selectedSubCategory?.id == subCategory.id,
                onTap: () => _selectSubCategory(subCategory),
              ),
            );
          }).toList(),

          const SizedBox(height: 100), // Space for bottom button
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
            onPressed: () {
              final level = _parseLevel(widget.selectedLevel ?? 'intermediate');
              final focusAreas = widget.focusAreas ?? ['general'];

              _bloc.add(
                LearningPathsEvent.generateSubCategories(
                  level: level,
                  focusAreas: focusAreas,
                ),
              );
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  /// Selects a sub-category
  void _selectSubCategory(SubCategory subCategory) {
    setState(() {
      _selectedSubCategory = subCategory;
    });
  }

  /// Creates a learning path with the selected sub-category
  void _createLearningPath() {
    if (_selectedSubCategory != null) {
      final level = _parseLevel(widget.selectedLevel ?? 'intermediate');
      final focusAreas = widget.focusAreas ?? ['general'];

      _bloc.add(
        LearningPathsEvent.selectSubCategory(
          subCategory: _selectedSubCategory!,
          level: level,
          focusAreas: focusAreas,
        ),
      );
    }
  }

  /// Parses string level to Level enum
  Level _parseLevel(String levelString) {
    switch (levelString.toLowerCase()) {
      case 'beginner':
        return Level.beginner;
      case 'elementary':
        return Level.elementary;
      case 'intermediate':
        return Level.intermediate;
      case 'advanced':
        return Level.advanced;
      default:
        return Level.intermediate;
    }
  }
}
