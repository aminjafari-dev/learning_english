// mark_vocabulary_as_used_usecase_test.dart
// Tests for the use case that marks vocabulary as used.

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:learning_english/features/daily_lessons/domain/usecases/mark_vocabulary_as_used_usecase.dart';
import 'package:learning_english/features/daily_lessons/domain/repositories/daily_lessons_repository.dart';
import 'package:learning_english/core/error/failure.dart';

class MockDailyLessonsRepository extends Mock
    implements DailyLessonsRepository {}

void main() {
  group('MarkVocabularyAsUsedUseCase', () {
    late MarkVocabularyAsUsedUseCase useCase;
    late MockDailyLessonsRepository mockRepository;

    setUp(() {
      mockRepository = MockDailyLessonsRepository();
      useCase = MarkVocabularyAsUsedUseCase(mockRepository);
    });

    test('should mark vocabulary as used successfully', () async {
      // Arrange
      const english = 'Perseverance';
      when(
        () => mockRepository.markVocabularyAsUsed(english),
      ).thenAnswer((_) async => const Right(true));

      // Act
      final result = await useCase(english);

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should return success'),
        (success) => expect(success, true),
      );

      verify(() => mockRepository.markVocabularyAsUsed(english)).called(1);
    });

    test('should return failure when repository fails', () async {
      // Arrange
      const english = 'Perseverance';
      when(
        () => mockRepository.markVocabularyAsUsed(english),
      ).thenAnswer((_) async => const Left(CacheFailure('Storage error')));

      // Act
      final result = await useCase(english);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<CacheFailure>()),
        (success) => fail('Should return failure'),
      );

      verify(() => mockRepository.markVocabularyAsUsed(english)).called(1);
    });

    test('should handle empty string input', () async {
      // Arrange
      const english = '';
      when(
        () => mockRepository.markVocabularyAsUsed(english),
      ).thenAnswer((_) async => const Right(true));

      // Act
      final result = await useCase(english);

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should return success'),
        (success) => expect(success, true),
      );

      verify(() => mockRepository.markVocabularyAsUsed(english)).called(1);
    });

    test('should handle special characters in vocabulary', () async {
      // Arrange
      const english = 'Café & Résumé';
      when(
        () => mockRepository.markVocabularyAsUsed(english),
      ).thenAnswer((_) async => const Right(true));

      // Act
      final result = await useCase(english);

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should return success'),
        (success) => expect(success, true),
      );

      verify(() => mockRepository.markVocabularyAsUsed(english)).called(1);
    });
  });
}
