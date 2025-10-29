// course_completion_button.dart
// Widget for completing a course in the daily lessons page
// Shows a completion button when course context is available

import 'package:flutter/material.dart';
import 'package:learning_english/core/theme/app_theme.dart';
import 'package:learning_english/core/widgets/global_widget/g_button.dart';
import 'package:learning_english/core/widgets/global_widget/g_gap.dart';
import 'package:learning_english/core/widgets/global_widget/g_text.dart';

/// Widget for completing a course in the daily lessons page
/// Shows a completion button when course context is available
class CourseCompletionButton extends StatelessWidget {
  final String? pathId;
  final int? courseNumber;
  final VoidCallback? onComplete;
  final bool isLoading;

  const CourseCompletionButton({
    super.key,
    this.pathId,
    this.courseNumber,
    this.onComplete,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    // Only show if we have course context
    if (pathId == null || courseNumber == null) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppTheme.primary(context).withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primary(context).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          GText(
            'Course Completion',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.primary(context),
            ),
            textAlign: TextAlign.center,
          ),
          GGap.g8,
          GText(
            'You\'ve completed this course! Tap the button below to mark it as finished and unlock the next course.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.text(context).withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
          GGap.g16,
          GButton(
            text: isLoading ? 'Completing...' : 'Complete Course',
            onPressed: isLoading ? null : onComplete,
          ),
        ],
      ),
    );
  }
}

// Example usage:
// CourseCompletionButton(
//   pathId: 'path123',
//   courseNumber: 1,
//   onComplete: () => _completeCourse(),
//   isLoading: false,
// )
