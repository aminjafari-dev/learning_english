// small_add_learning_path_card.dart
// Compact widget for adding a new learning path when other paths exist
// Shows a smaller, more subtle design that doesn't dominate the UI

import 'package:flutter/material.dart';
import 'package:learning_english/core/theme/app_theme.dart';
import 'package:learning_english/core/widgets/global_widget/g_text.dart';
import 'package:learning_english/core/widgets/global_widget/g_gap.dart';

/// Compact card widget for adding a new learning path
/// Used when there are existing learning paths to keep the UI balanced
class SmallAddLearningPathCard extends StatelessWidget {
  final VoidCallback? onTap;

  const SmallAddLearningPathCard({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: AppTheme.primary(context).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppTheme.primary(context).withOpacity(0.05),
          ),
          child: Row(
            children: [
              // Small icon
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primary(context).withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.add_rounded,
                  size: 20,
                  color: AppTheme.primary(context),
                ),
              ),

              GGap.g12,

              // Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GText(
                      'Add New Learning Path',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.text(context),
                      ),
                    ),
                    GGap.g4,
                    GText(
                      'Create another personalized learning journey',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.text(context).withOpacity(0.6),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Arrow icon
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppTheme.primary(context).withOpacity(0.7),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
