// clear_user_data_usecase_test.dart
// Tests for the use case that clears all user data.

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:learning_english/features/daily_lessons/domain/usecases/clear_user_data_usecase.dart';
import 'package:learning_english/features/daily_lessons/domain/repositories/daily_lessons_repository.dart';
import 'package:learning_english/core/error/failure.dart';

class MockDailyLessonsRepository extends Mock
    implements DailyLessonsRepository {}

void main() {
  group('ClearUserDataUseCase', () {
    late ClearUserDataUseCase useCase;
    late MockDailyLessonsRepository mockRepository;

    setUp(() {
      mockRepository = MockDailyLessonsRepository();
      useCase = ClearUserDataUseCase(mockRepository);
    });

    test('should clear user data successfully', () async {
      // Arrange
      when(
        () => mockRepository.clearUserData(),
      ).thenAnswer((_) async => const Right(true));

      // Act
      final result = await useCase(null);

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should return success'),
        (success) => expect(success, true),
      );

      verify(() => mockRepository.clearUserData()).called(1);
    });

    test('should return failure when repository fails', () async {
      // Arrange
      when(
        () => mockRepository.clearUserData(),
      ).thenAnswer((_) async => const Left(CacheFailure('Clear data error')));

      // Act
      final result = await useCase(null);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<CacheFailure>()),
        (success) => fail('Should return failure'),
      );

      verify(() => mockRepository.clearUserData()).called(1);
    });

    test('should handle server failure', () async {
      // Arrange
      when(
        () => mockRepository.clearUserData(),
      ).thenAnswer((_) async => const Left(ServerFailure('Server error')));

      // Act
      final result = await useCase(null);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (success) => fail('Should return failure'),
      );

      verify(() => mockRepository.clearUserData()).called(1);
    });

    test('should handle network failure', () async {
      // Arrange
      when(
        () => mockRepository.clearUserData(),
      ).thenAnswer((_) async => const Left(NetworkFailure('Network error')));

      // Act
      final result = await useCase(null);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<NetworkFailure>()),
        (success) => fail('Should return failure'),
      );

      verify(() => mockRepository.clearUserData()).called(1);
    });

    test('should return false when clear operation fails', () async {
      // Arrange
      when(
        () => mockRepository.clearUserData(),
      ).thenAnswer((_) async => const Right(false));

      // Act
      final result = await useCase(null);

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should return success'),
        (success) => expect(success, false),
      );

      verify(() => mockRepository.clearUserData()).called(1);
    });
  });
}
