import 'package:flutter_test/flutter_test.dart';
import 'package:learning_english/features/course/data/datasources/remote/lesson_prompts.dart';
import 'package:learning_english/features/learning_paths/domain/entities/course.dart';
import 'package:learning_english/features/learning_paths/domain/entities/learning_path.dart';
import 'package:learning_english/features/learning_paths/domain/entities/sub_category.dart';
import 'package:learning_english/features/level_selection/domain/entities/user_profile.dart';

void main() {
  group('LessonPrompts.getLessonPrompt', () {
    test('includes instructions to avoid previously used vocabulary and phrases', () {
      // Arrange: Build the learning path data the prompt needs.
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

      // Act: Generate the prompt while telling the method what to avoid repeating.
      final prompt = LessonPrompts.getLessonPrompt(
        learningPath,
        previousVocabularies: const ['boarding pass', 'luggage'],
        previousPhrases: const ['Where is the gate?'],
      );

      // Assert: Confirm the prompt contains the avoidance instructions we expect.
      expect(
        prompt,
        contains(
          'Generate a daily English lesson for a intermediate level learner focusing on: speaking, listening',
        ),
      );
      expect(prompt, contains('AVOID using these vocabulary words'));
      expect(prompt, contains('boarding pass, luggage'));
      expect(prompt, contains('AVOID using these phrases'));
      expect(prompt, contains('Where is the gate?'));
      expect(
        prompt,
        contains(
          'Generate completely NEW vocabulary words and phrases that are different from the ones listed above',
        ),
      );
    });
  });

  group('lessonPrompts.getCourseLessonPrompt', () {
    test(
      'includes instructions to avoid previously used vocabulary and phrases',
      () {
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

        final prompt = LessonPrompts.getCourseLessonPrompt(
          learningPath,
          'Travel Conversations',
          1,
          previousVocabularies: const ['airport', 'hotel', 'directions'],
          previousPhrases: const ['Where is the gate?'],
        );

        expect(prompt, contains('AVOID using these vocabulary words that were already used in previous courses of this learning path:'));
        expect(prompt, contains('airport, hotel, directions'));
        expect(prompt, contains('AVOID using these phrases'));
        expect(prompt, contains('Where is the gate?'));
        expect(
          prompt,
          contains('Generate completely NEW vocabulary words and phrases that are different from the ones listed above'),
        );
      },
    );
  });
}
