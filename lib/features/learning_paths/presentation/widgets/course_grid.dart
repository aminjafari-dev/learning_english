// course_grid.dart
// Widget for displaying the 4x5 grid of courses (1-20)
// Shows course cards with lock/unlock states and progress

import 'package:flutter/material.dart';
import 'package:learning_english/core/theme/app_theme.dart';
import 'package:learning_english/core/widgets/global_widget/g_text.dart';
import '../../domain/entities/learning_path.dart';
import 'course_card.dart';

/// Widget for displaying the 4x5 grid of courses (1-20)
/// Shows course cards with lock/unlock states and progress
class CourseGrid extends StatelessWidget {
  final LearningPath learningPath;
  final Function(int courseNumber) onCourseTap;

  const CourseGrid({
    super.key,
    required this.learningPath,
    required this.onCourseTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with progress
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GText(
                '${learningPath.completedCourses}/${learningPath.totalCourses} courses completed',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.text(context),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primary(context).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: GText(
                  '${learningPath.progressPercentage.toInt()}%',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.primary(context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Course grid (4x5)
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemCount: learningPath.courses.length,
          itemBuilder: (context, index) {
            final course = learningPath.courses[index];
            return CourseCard(
              course: course,
              onTap: () => onCourseTap(course.courseNumber),
            );
          },
        ),

        const SizedBox(height: 24),

        // Next course info
        if (learningPath.nextUnlockedCourse != null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppTheme.primary(context).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.primary(context).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GText(
                  'Next Course: ${learningPath.nextUnlockedCourse}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primary(context),
                  ),
                ),
                const SizedBox(height: 4),
                GText(
                  learningPath.courses
                      .firstWhere(
                        (c) =>
                            c.courseNumber == learningPath.nextUnlockedCourse,
                      )
                      .title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.text(context).withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

