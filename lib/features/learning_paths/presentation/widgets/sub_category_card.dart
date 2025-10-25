// sub_category_card.dart
// Widget for displaying sub-category selection cards
// Shows title, description, and key topics for each AI-generated sub-category

import 'package:flutter/material.dart';
import 'package:learning_english/core/theme/app_theme.dart';
import 'package:learning_english/core/widgets/global_widget/g_text.dart';
import '../../domain/entities/sub_category.dart';

/// Widget for displaying sub-category selection cards
/// Shows title, description, and key topics for each AI-generated sub-category
class SubCategoryCard extends StatelessWidget {
  final SubCategory subCategory;
  final bool isSelected;
  final VoidCallback onTap;

  const SubCategoryCard({
    super.key,
    required this.subCategory,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 8 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color:
              isSelected
                  ? AppTheme.primary(context)
                  : Colors.grey.withOpacity(0.2),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              GText(
                subCategory.title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color:
                      isSelected
                          ? AppTheme.primary(context)
                          : AppTheme.text(context),
                ),
              ),

              const SizedBox(height: 8),

              // Description
              GText(
                subCategory.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.text(context).withOpacity(0.7),
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 16),

              // Key topics
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    subCategory.keyTopics.take(3).map((topic) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? AppTheme.primary(context).withOpacity(0.1)
                                  : Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: GText(
                          topic,
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(
                            color:
                                isSelected
                                    ? AppTheme.primary(context)
                                    : Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
              ),

              if (subCategory.keyTopics.length > 3) ...[
                const SizedBox(height: 8),
                GText(
                  '+${subCategory.keyTopics.length - 3} more topics',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],

              const SizedBox(height: 16),

              // Difficulty and lessons info
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getDifficultyColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: GText(
                      subCategory.difficultyDescription,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: _getDifficultyColor(),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  GText(
                    '${subCategory.estimatedLessons} lessons',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Gets the color for difficulty level
  Color _getDifficultyColor() {
    switch (subCategory.difficulty.name) {
      case 'beginner':
        return Colors.green;
      case 'elementary':
        return Colors.blue;
      case 'intermediate':
        return Colors.orange;
      case 'advanced':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

