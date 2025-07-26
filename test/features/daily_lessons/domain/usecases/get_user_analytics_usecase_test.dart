// get_user_analytics_usecase_test.dart
// Tests for the use case that retrieves user analytics data.

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:learning_english/features/daily_lessons/domain/usecases/get_user_analytics_usecase.dart';
import 'package:learning_english/features/daily_lessons/domain/repositories/daily_lessons_repository.dart';
import 'package:learning_english/core/error/failure.dart';

class MockDailyLessonsRepository extends Mock
    implements DailyLessonsRepository {}

void main() {
  group('GetUserAnalyticsUseCase', () {
    late GetUserAnalyticsUseCase useCase;
    late MockDailyLessonsRepository mockRepository;

    setUp(() {
      mockRepository = MockDailyLessonsRepository();
      useCase = GetUserAnalyticsUseCase(mockRepository);
    });

    test('should get user analytics successfully', () async {
      // Arrange
      final analytics = {
        'totalVocabularies': 10,
        'totalPhrases': 5,
        'totalTokens': 500,
        'usedVocabularies': 7,
        'usedPhrases': 3,
        'providerStats': {
          'AiProviderType.openai': {
            'vocabularies': 6,
            'phrases': 3,
            'tokensUsed': 300,
            'usedVocabularies': 4,
            'usedPhrases': 2,
          },
          'AiProviderType.gemini': {
            'vocabularies': 4,
            'phrases': 2,
            'tokensUsed': 200,
            'usedVocabularies': 3,
            'usedPhrases': 1,
          },
        },
      };

      when(
        () => mockRepository.getUserAnalytics(),
      ).thenAnswer((_) async => Right(analytics));

      // Act
      final result = await useCase(null);

      // Assert
      expect(result.isRight(), true);
      result.fold((failure) => fail('Should return success'), (analyticsData) {
        expect(analyticsData['totalVocabularies'], 10);
        expect(analyticsData['totalPhrases'], 5);
        expect(analyticsData['totalTokens'], 500);
        expect(analyticsData['usedVocabularies'], 7);
        expect(analyticsData['usedPhrases'], 3);

        final providerStats =
            analyticsData['providerStats'] as Map<String, dynamic>;
        expect(providerStats['AiProviderType.openai']['vocabularies'], 6);
        expect(providerStats['AiProviderType.gemini']['vocabularies'], 4);
      });

      verify(() => mockRepository.getUserAnalytics()).called(1);
    });

    test('should return failure when repository fails', () async {
      // Arrange
      when(
        () => mockRepository.getUserAnalytics(),
      ).thenAnswer((_) async => const Left(CacheFailure('Analytics error')));

      // Act
      final result = await useCase(null);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<CacheFailure>()),
        (analytics) => fail('Should return failure'),
      );

      verify(() => mockRepository.getUserAnalytics()).called(1);
    });

    test('should handle empty analytics data', () async {
      // Arrange
      final emptyAnalytics = {
        'totalVocabularies': 0,
        'totalPhrases': 0,
        'totalTokens': 0,
        'usedVocabularies': 0,
        'usedPhrases': 0,
        'providerStats': {
          'AiProviderType.openai': {
            'vocabularies': 0,
            'phrases': 0,
            'tokensUsed': 0,
            'usedVocabularies': 0,
            'usedPhrases': 0,
          },
          'AiProviderType.gemini': {
            'vocabularies': 0,
            'phrases': 0,
            'tokensUsed': 0,
            'usedVocabularies': 0,
            'usedPhrases': 0,
          },
          'AiProviderType.deepseek': {
            'vocabularies': 0,
            'phrases': 0,
            'tokensUsed': 0,
            'usedVocabularies': 0,
            'usedPhrases': 0,
          },
        },
      };

      when(
        () => mockRepository.getUserAnalytics(),
      ).thenAnswer((_) async => Right(emptyAnalytics));

      // Act
      final result = await useCase(null);

      // Assert
      expect(result.isRight(), true);
      result.fold((failure) => fail('Should return success'), (analyticsData) {
        expect(analyticsData['totalVocabularies'], 0);
        expect(analyticsData['totalPhrases'], 0);
        expect(analyticsData['totalTokens'], 0);
        expect(analyticsData['usedVocabularies'], 0);
        expect(analyticsData['usedPhrases'], 0);
      });

      verify(() => mockRepository.getUserAnalytics()).called(1);
    });

    test('should handle large analytics data', () async {
      // Arrange
      final largeAnalytics = {
        'totalVocabularies': 1000,
        'totalPhrases': 500,
        'totalTokens': 50000,
        'usedVocabularies': 750,
        'usedPhrases': 375,
        'providerStats': {
          'AiProviderType.openai': {
            'vocabularies': 600,
            'phrases': 300,
            'tokensUsed': 30000,
            'usedVocabularies': 450,
            'usedPhrases': 225,
          },
          'AiProviderType.gemini': {
            'vocabularies': 400,
            'phrases': 200,
            'tokensUsed': 20000,
            'usedVocabularies': 300,
            'usedPhrases': 150,
          },
        },
      };

      when(
        () => mockRepository.getUserAnalytics(),
      ).thenAnswer((_) async => Right(largeAnalytics));

      // Act
      final result = await useCase(null);

      // Assert
      expect(result.isRight(), true);
      result.fold((failure) => fail('Should return success'), (analyticsData) {
        expect(analyticsData['totalVocabularies'], 1000);
        expect(analyticsData['totalPhrases'], 500);
        expect(analyticsData['totalTokens'], 50000);
        expect(analyticsData['usedVocabularies'], 750);
        expect(analyticsData['usedPhrases'], 375);
      });

      verify(() => mockRepository.getUserAnalytics()).called(1);
    });
  });
}
