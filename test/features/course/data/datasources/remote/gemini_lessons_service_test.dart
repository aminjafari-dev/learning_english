import 'package:flutter_test/flutter_test.dart';
import 'package:learning_english/features/course/data/datasources/remote/gemini_lessons_service.dart';
import 'package:learning_english/features/course/data/datasources/local/courses_local_data_source.dart';
import 'package:learning_english/features/learning_paths/domain/entities/learning_path.dart';
import 'package:learning_english/features/learning_paths/domain/entities/sub_category.dart';
import 'package:learning_english/features/learning_paths/domain/entities/course.dart';
import 'package:learning_english/features/level_selection/domain/entities/user_profile.dart';

void main() {
  group('GeminiLessonsService.generateLessonsResponse', () {
    test('throws when API key is missing', () async {
      // Arrange: Provide a fake local data source and an empty API key.
      final service = GeminiLessonsService(CoursesLocalDataSource(), '');

      final learningPath = LearningPath(
        id: 'lp_1',
        title: 'Conversation Mastery',
        description: 'Improve real-world conversation skills.',
        level: Level.intermediate,
        focusAreas: const ['speaking', 'listening'],
        subCategory: const SubCategory(
          id: 'sub_1',
          title: 'Travel Conversations',
          description: 'Handle travel-related dialogues.',
          difficulty: Level.intermediate,
          estimatedLessons: 10,
          keyTopics: ['airport', 'hotel', 'directions'],
        ),
        courses: const <Course>[],
        createdAt: DateTime(2024, 1, 1),
      );

      // Act + Assert: Calling the method without an API key should throw.
      await expectLater(
        service.generateLessonsResponse(learningPath),
        throwsA(
          predicate<Exception>(
            (error) =>
                error.toString().contains('Gemini API key is not configured'),
          ),
        ),
      );
    });
  });
}
