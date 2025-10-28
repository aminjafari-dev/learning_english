// learning_path_card.dart
// Widget for displaying individual learning path cards
// Shows learning path information with progress and actions

import 'package:flutter/material.dart';
import 'package:learning_english/core/theme/app_theme.dart';
import 'package:learning_english/core/widgets/global_widget/g_text.dart';
import 'package:learning_english/core/widgets/global_widget/g_gap.dart';
import '../../domain/entities/learning_path.dart';

/// Card widget for displaying a learning path
/// Shows title, description, progress, and action buttons
class LearningPathCard extends StatelessWidget {
  final LearningPath learningPath;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final bool showDeleteButton;

  const LearningPathCard({
    super.key,
    required this.learningPath,
    this.onTap,
    this.onDelete,
    this.showDeleteButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with title and delete button
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GText(
                          learningPath.title,
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.text(context),
                          ),
                        ),
                        GGap.g8,
                        GText(
                          learningPath.description,
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(
                            color: AppTheme.text(context).withOpacity(0.7),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  if (showDeleteButton && onDelete != null)
                    IconButton(
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete_outline),
                      color: Colors.red,
                      iconSize: 20,
                    ),
                ],
              ),

              GGap.g16,

              // Progress section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GText(
                        'Progress',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.text(context).withOpacity(0.6),
                        ),
                      ),
                      GText(
                        '${learningPath.completedCourses}/${learningPath.totalCourses}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.text(context).withOpacity(0.8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
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

              GGap.g16,

              // Footer with level and focus areas
              Row(
                children: [
                  // Level badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primary(context).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: GText(
                      learningPath.level.name.toUpperCase(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.primary(context),
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  GGap.g8,
                  // Focus areas
                  Expanded(
                    child: GText(
                      learningPath.focusAreas.join(', '),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.text(context).withOpacity(0.6),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
