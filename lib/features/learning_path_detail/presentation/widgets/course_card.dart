// course_card.dart
// Widget for displaying individual course cards in the grid
// Shows course number, lock/unlock state, and completion status

import 'package:flutter/material.dart';
import 'package:learning_english/core/theme/app_theme.dart';
import 'package:learning_english/core/widgets/global_widget/g_text.dart';
import '../../domain/entities/course.dart';

/// Widget for displaying individual course cards in the grid
/// Shows course number, lock/unlock state, and completion status
class CourseCard extends StatelessWidget {
  final Course course;
  final VoidCallback onTap;

  const CourseCard({super.key, required this.course, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: course.canAccess ? onTap : null,
      child: Container(
        decoration: BoxDecoration(
          color: _getCardColor(context),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _getBorderColor(context), width: 2),
          boxShadow:
              course.canAccess
                  ? [
                    BoxShadow(
                      color:
                          course.isCompleted
                              ? Colors.green.withOpacity(0.3)
                              : AppTheme.primary(context).withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                  : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Course number or lock icon
            if (course.isCompleted)
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    GText(
                      '${course.courseNumber}',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.green,
                          size: 8,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else if (course.isUnlocked)
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppTheme.primary(context),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: GText(
                    '${course.courseNumber}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            else
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(Icons.lock, color: Colors.grey[600], size: 20),
              ),

            const SizedBox(height: 8),

            // Course status text
            GText(
              _getStatusText(),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: _getTextColor(context),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Gets the card background color based on course state
  Color _getCardColor(BuildContext context) {
    if (course.isCompleted) {
      return Colors.green.withOpacity(0.1);
    } else if (course.isUnlocked) {
      return AppTheme.primary(context).withOpacity(0.1);
    } else {
      return Colors.grey.withOpacity(0.05);
    }
  }

  /// Gets the border color based on course state
  Color _getBorderColor(BuildContext context) {
    if (course.isCompleted) {
      return Colors.green.withOpacity(0.3);
    } else if (course.isUnlocked) {
      return AppTheme.primary(context).withOpacity(0.3);
    } else {
      return Colors.grey.withOpacity(0.2);
    }
  }

  /// Gets the text color based on course state
  Color _getTextColor(BuildContext context) {
    if (course.isCompleted) {
      return Colors.green[700]!;
    } else if (course.isUnlocked) {
      return AppTheme.primary(context);
    } else {
      return Colors.grey[600]!;
    }
  }

  /// Gets the status text for the course
  String _getStatusText() {
    if (course.isCompleted) {
      return 'Review';
    } else if (course.isUnlocked) {
      return 'Start';
    } else {
      return 'Locked';
    }
  }
}
