// daily_lessons_repository_impl_test.dart
// Tests for the repository implementation that integrates local and remote data sources.

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:learning_english/features/daily_lessons/data/repositories/daily_lessons_repository_impl.dart';
import 'package:learning_english/features/daily_lessons/data/datasources/remote/ai_lessons_remote_data_source.dart';
import 'package:learning_english/features/daily_lessons/data/datasources/local/daily_lessons_local_data_source.dart';
import 'package:learning_english/features/daily_lessons/data/datasources/ai_provider_type.dart';
import 'package:learning_english/features/daily_lessons/data/models/vocabulary_model.dart';
import 'package:learning_english/features/daily_lessons/data/models/phrase_model.dart';
import 'package:learning_english/features/daily_lessons/domain/entities/vocabulary.dart';
import 'package:learning_english/features/daily_lessons/domain/entities/phrase.dart';
import 'package:learning_english/core/error/failure.dart';

class MockAiLessonsRemoteDataSource extends Mock
    implements AiLessonsRemoteDataSource {}

class MockDailyLessonsLocalDataSource extends Mock
    implements DailyLessonsLocalDataSource {}

@GenerateMocks([AiLessonsRemoteDataSource, DailyLessonsLocalDataSource])
void main() {
  group('DailyLessonsRepositoryImpl', () {
    late DailyLessonsRepositoryImpl repository;
    late MockAiLessonsRemoteDataSource mockRemoteDataSource;
    late MockDailyLessonsLocalDataSource mockLocalDataSource;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      mockRemoteDataSource = MockAiLessonsRemoteDataSource();
      mockLocalDataSource = MockDailyLessonsLocalDataSource();
      repository = DailyLessonsRepositoryImpl(
        remoteDataSource: mockRemoteDataSource,
        localDataSource: mockLocalDataSource,
      );
    });

    group('getDailyVocabularies', () {
      test(
        'should return unused vocabularies from local storage when available',
        () async {
          // Arrange
          final unusedVocabularies = [
            VocabularyModel(
              english: 'Word 1',
              persian: 'کلمه ۱',
              userId: 'current_user',
              aiProvider: AiProviderType.openai,
              generatedAt: DateTime.now(),
              tokensUsed: 30,
              requestId: 'req_1',
              isUsed: false,
            ),
            VocabularyModel(
              english: 'Word 2',
              persian: 'کلمه ۲',
              userId: 'current_user',
              aiProvider: AiProviderType.gemini,
              generatedAt: DateTime.now(),
              tokensUsed: 35,
              requestId: 'req_2',
              isUsed: false,
            ),
            VocabularyModel(
              english: 'Word 3',
              persian: 'کلمه ۳',
              userId: 'current_user',
              aiProvider: AiProviderType.openai,
              generatedAt: DateTime.now(),
              tokensUsed: 40,
              requestId: 'req_3',
              isUsed: false,
            ),
            VocabularyModel(
              english: 'Word 4',
              persian: 'کلمه ۴',
              userId: 'current_user',
              aiProvider: AiProviderType.gemini,
              generatedAt: DateTime.now(),
              tokensUsed: 45,
              requestId: 'req_4',
              isUsed: false,
            ),
          ];

          when(
            mockLocalDataSource.getUnusedVocabularies(),
          ).thenAnswer((_) async => unusedVocabularies);

          // Act
          final result = await repository.getDailyVocabularies();

          // Assert
          expect(result.isRight(), true);
          final vocabularies = result.fold((l) => [], (r) => r);
          expect(vocabularies.length, 4);
          expect(vocabularies[0].english, 'Word 1');
          expect(vocabularies[1].english, 'Word 2');
          expect(vocabularies[2].english, 'Word 3');
          expect(vocabularies[3].english, 'Word 4');

          verify(mockLocalDataSource.getUnusedVocabularies()).called(1);
          verifyNever(mockRemoteDataSource.fetchDailyVocabularies());
        },
      );

      test(
        'should fetch from remote when insufficient unused vocabularies',
        () async {
          // Arrange
          final unusedVocabularies = [
            VocabularyModel(
              english: 'Word 1',
              persian: 'کلمه ۱',
              userId: 'current_user',
              aiProvider: AiProviderType.openai,
              generatedAt: DateTime.now(),
              tokensUsed: 30,
              requestId: 'req_1',
              isUsed: false,
            ),
          ];

          final remoteVocabularies = [
            const Vocabulary(english: 'Remote Word 1', persian: 'کلمه ریموت ۱'),
            const Vocabulary(english: 'Remote Word 2', persian: 'کلمه ریموت ۲'),
            const Vocabulary(english: 'Remote Word 3', persian: 'کلمه ریموت ۳'),
            const Vocabulary(english: 'Remote Word 4', persian: 'کلمه ریموت ۴'),
          ];

          when(
            mockLocalDataSource.getUnusedVocabularies(),
          ).thenAnswer((_) async => unusedVocabularies);
          when(
            mockRemoteDataSource.fetchDailyVocabularies(),
          ).thenAnswer((_) async => Right(remoteVocabularies));
          when(
            mockLocalDataSource.saveUserVocabulary(any),
          ).thenAnswer((_) async {});

          // Act
          final result = await repository.getDailyVocabularies();

          // Assert
          expect(result.isRight(), true);
          final vocabularies = result.fold((l) => [], (r) => r);
          expect(vocabularies.length, 4);
          expect(vocabularies[0].english, 'Remote Word 1');
          expect(vocabularies[1].english, 'Remote Word 2');
          expect(vocabularies[2].english, 'Remote Word 3');
          expect(vocabularies[3].english, 'Remote Word 4');

          verify(mockLocalDataSource.getUnusedVocabularies()).called(1);
          verify(mockRemoteDataSource.fetchDailyVocabularies()).called(1);
          verify(mockLocalDataSource.saveUserVocabulary(any)).called(4);
        },
      );

      test('should return failure when remote data source fails', () async {
        // Arrange
        when(
          mockLocalDataSource.getUnusedVocabularies(),
        ).thenAnswer((_) async => []);
        when(
          mockRemoteDataSource.fetchDailyVocabularies(),
        ).thenAnswer((_) async => Left(ServerFailure('Network error')));

        // Act
        final result = await repository.getDailyVocabularies();

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<ServerFailure>()),
          (vocabularies) => fail('Should return failure'),
        );

        verify(mockLocalDataSource.getUnusedVocabularies()).called(1);
        verify(mockRemoteDataSource.fetchDailyVocabularies()).called(1);
        verifyNever(mockLocalDataSource.saveUserVocabulary(any));
      });
    });

    group('getDailyPhrases', () {
      test(
        'should return unused phrases from local storage when available',
        () async {
          // Arrange
          final unusedPhrases = [
            PhraseModel(
              english: 'Phrase 1',
              persian: 'عبارت ۱',
              userId: 'current_user',
              aiProvider: AiProviderType.openai,
              generatedAt: DateTime.now(),
              tokensUsed: 30,
              requestId: 'req_1',
              isUsed: false,
            ),
            PhraseModel(
              english: 'Phrase 2',
              persian: 'عبارت ۲',
              userId: 'current_user',
              aiProvider: AiProviderType.gemini,
              generatedAt: DateTime.now(),
              tokensUsed: 35,
              requestId: 'req_2',
              isUsed: false,
            ),
          ];

          when(
            mockLocalDataSource.getUnusedPhrases(),
          ).thenAnswer((_) async => unusedPhrases);

          // Act
          final result = await repository.getDailyPhrases();

          // Assert
          expect(result.isRight(), true);
          final phrases = result.fold((l) => [], (r) => r);
          expect(phrases.length, 2);
          expect(phrases[0].english, 'Phrase 1');
          expect(phrases[1].english, 'Phrase 2');

          verify(mockLocalDataSource.getUnusedPhrases()).called(1);
          verifyNever(mockRemoteDataSource.fetchDailyPhrases());
        },
      );

      test(
        'should fetch from remote when insufficient unused phrases',
        () async {
          // Arrange
          when(
            mockLocalDataSource.getUnusedPhrases(),
          ).thenAnswer((_) async => []);

          final remotePhrases = [
            const Phrase(english: 'Remote Phrase 1', persian: 'عبارت ریموت ۱'),
            const Phrase(english: 'Remote Phrase 2', persian: 'عبارت ریموت ۲'),
          ];

          when(
            mockRemoteDataSource.fetchDailyPhrases(),
          ).thenAnswer((_) async => Right(remotePhrases));
          when(
            mockLocalDataSource.saveUserPhrase(any),
          ).thenAnswer((_) async {});

          // Act
          final result = await repository.getDailyPhrases();

          // Assert
          expect(result.isRight(), true);
          final phrases = result.fold((l) => [], (r) => r);
          expect(phrases.length, 2);
          expect(phrases[0].english, 'Remote Phrase 1');
          expect(phrases[1].english, 'Remote Phrase 2');

          verify(mockLocalDataSource.getUnusedPhrases()).called(1);
          verify(mockRemoteDataSource.fetchDailyPhrases()).called(1);
          verify(mockLocalDataSource.saveUserPhrase(any)).called(2);
        },
      );
    });

    group('getDailyLessons', () {
      test(
        'should return unused content from local storage when available',
        () async {
          // Arrange
          final unusedVocabularies = [
            VocabularyModel(
              english: 'Word 1',
              persian: 'کلمه ۱',
              userId: 'current_user',
              aiProvider: AiProviderType.openai,
              generatedAt: DateTime.now(),
              tokensUsed: 30,
              requestId: 'req_1',
              isUsed: false,
            ),
            VocabularyModel(
              english: 'Word 2',
              persian: 'کلمه ۲',
              userId: 'current_user',
              aiProvider: AiProviderType.gemini,
              generatedAt: DateTime.now(),
              tokensUsed: 35,
              requestId: 'req_2',
              isUsed: false,
            ),
            VocabularyModel(
              english: 'Word 3',
              persian: 'کلمه ۳',
              userId: 'current_user',
              aiProvider: AiProviderType.openai,
              generatedAt: DateTime.now(),
              tokensUsed: 40,
              requestId: 'req_3',
              isUsed: false,
            ),
            VocabularyModel(
              english: 'Word 4',
              persian: 'کلمه ۴',
              userId: 'current_user',
              aiProvider: AiProviderType.gemini,
              generatedAt: DateTime.now(),
              tokensUsed: 45,
              requestId: 'req_4',
              isUsed: false,
            ),
          ];

          final unusedPhrases = [
            PhraseModel(
              english: 'Phrase 1',
              persian: 'عبارت ۱',
              userId: 'current_user',
              aiProvider: AiProviderType.openai,
              generatedAt: DateTime.now(),
              tokensUsed: 50,
              requestId: 'req_5',
              isUsed: false,
            ),
            PhraseModel(
              english: 'Phrase 2',
              persian: 'عبارت ۲',
              userId: 'current_user',
              aiProvider: AiProviderType.gemini,
              generatedAt: DateTime.now(),
              tokensUsed: 55,
              requestId: 'req_6',
              isUsed: false,
            ),
          ];

          when(
            mockLocalDataSource.getUnusedVocabularies(),
          ).thenAnswer((_) async => unusedVocabularies);
          when(
            mockLocalDataSource.getUnusedPhrases(),
          ).thenAnswer((_) async => unusedPhrases);

          // Act
          final result = await repository.getDailyLessons();

          // Assert
          expect(result.isRight(), true);
          final lessons = result.fold(
            (l) => (vocabularies: <Vocabulary>[], phrases: <Phrase>[]),
            (r) => r,
          );
          expect(lessons.vocabularies.length, 4);
          expect(lessons.phrases.length, 2);
          expect(lessons.vocabularies[0].english, 'Word 1');
          expect(lessons.phrases[0].english, 'Phrase 1');

          verify(mockLocalDataSource.getUnusedVocabularies()).called(1);
          verify(mockLocalDataSource.getUnusedPhrases()).called(1);
          verifyNever(mockRemoteDataSource.fetchDailyLessons());
        },
      );

      test(
        'should fetch from remote when insufficient unused content',
        () async {
          // Arrange
          when(
            mockLocalDataSource.getUnusedVocabularies(),
          ).thenAnswer((_) async => []);
          when(
            mockLocalDataSource.getUnusedPhrases(),
          ).thenAnswer((_) async => []);

          final remoteData = (
            vocabularies: [
              const Vocabulary(
                english: 'Remote Word 1',
                persian: 'کلمه ریموت ۱',
              ),
              const Vocabulary(
                english: 'Remote Word 2',
                persian: 'کلمه ریموت ۲',
              ),
              const Vocabulary(
                english: 'Remote Word 3',
                persian: 'کلمه ریموت ۳',
              ),
              const Vocabulary(
                english: 'Remote Word 4',
                persian: 'کلمه ریموت ۴',
              ),
            ],
            phrases: [
              const Phrase(
                english: 'Remote Phrase 1',
                persian: 'عبارت ریموت ۱',
              ),
              const Phrase(
                english: 'Remote Phrase 2',
                persian: 'عبارت ریموت ۲',
              ),
            ],
          );

          when(
            mockRemoteDataSource.fetchDailyLessons(),
          ).thenAnswer((_) async => Right(remoteData));
          when(
            mockLocalDataSource.saveUserVocabulary(any),
          ).thenAnswer((_) async {});
          when(
            mockLocalDataSource.saveUserPhrase(any),
          ).thenAnswer((_) async {});

          // Act
          final result = await repository.getDailyLessons();

          // Assert
          expect(result.isRight(), true);
          final lessons = result.fold(
            (l) => (vocabularies: <Vocabulary>[], phrases: <Phrase>[]),
            (r) => r,
          );
          expect(lessons.vocabularies.length, 4);
          expect(lessons.phrases.length, 2);
          expect(lessons.vocabularies[0].english, 'Remote Word 1');
          expect(lessons.phrases[0].english, 'Remote Phrase 1');

          verify(mockLocalDataSource.getUnusedVocabularies()).called(1);
          verify(mockLocalDataSource.getUnusedPhrases()).called(1);
          verify(mockRemoteDataSource.fetchDailyLessons()).called(1);
          verify(mockLocalDataSource.saveUserVocabulary(any)).called(4);
          verify(mockLocalDataSource.saveUserPhrase(any)).called(2);
        },
      );
    });

    group('User Data Management', () {
      test('should mark vocabulary as used successfully', () async {
        // Arrange
        when(
          mockLocalDataSource.markVocabularyAsUsed('Test Word'),
        ).thenAnswer((_) async {});

        // Act
        final result = await repository.markVocabularyAsUsed('Test Word');

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should return success'),
          (success) => expect(success, true),
        );

        verify(mockLocalDataSource.markVocabularyAsUsed('Test Word')).called(1);
      });

      test('should mark phrase as used successfully', () async {
        // Arrange
        when(
          mockLocalDataSource.markPhraseAsUsed('Test Phrase'),
        ).thenAnswer((_) async {});

        // Act
        final result = await repository.markPhraseAsUsed('Test Phrase');

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should return success'),
          (success) => expect(success, true),
        );

        verify(mockLocalDataSource.markPhraseAsUsed('Test Phrase')).called(1);
      });

      test('should clear user data successfully', () async {
        // Arrange
        when(mockLocalDataSource.clearUserData()).thenAnswer((_) async {});

        // Act
        final result = await repository.clearUserData();

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should return success'),
          (success) => expect(success, true),
        );

        verify(mockLocalDataSource.clearUserData()).called(1);
      });

      test('should handle errors in user data management', () async {
        // Arrange
        when(
          mockLocalDataSource.markVocabularyAsUsed('Test Word'),
        ).thenThrow(Exception('Storage error'));

        // Act
        final result = await repository.markVocabularyAsUsed('Test Word');

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<CacheFailure>()),
          (success) => fail('Should return failure'),
        );

        verify(mockLocalDataSource.markVocabularyAsUsed('Test Word')).called(1);
      });
    });

    group('Analytics', () {
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
          mockLocalDataSource.getUserAnalytics(),
        ).thenAnswer((_) async => analytics);

        // Act
        final result = await repository.getUserAnalytics();

        // Assert
        expect(result.isRight(), true);
        result.fold((failure) => fail('Should return success'), (
          analyticsData,
        ) {
          expect(analyticsData['totalVocabularies'], 10);
          expect(analyticsData['totalPhrases'], 5);
          expect(analyticsData['totalTokens'], 500);
          expect(analyticsData['usedVocabularies'], 7);
          expect(analyticsData['usedPhrases'], 3);
        });

        verify(mockLocalDataSource.getUserAnalytics()).called(1);
      });

      test('should get vocabularies by provider successfully', () async {
        // Arrange
        final vocabularies = [
          VocabularyModel(
            english: 'OpenAI Word',
            persian: 'کلمه OpenAI',
            userId: 'current_user',
            aiProvider: AiProviderType.openai,
            generatedAt: DateTime.now(),
            tokensUsed: 30,
            requestId: 'req_1',
            isUsed: false,
          ),
        ];

        when(
          mockLocalDataSource.getVocabulariesByProvider(AiProviderType.openai),
        ).thenAnswer((_) async => vocabularies);

        // Act
        final result = await repository.getVocabulariesByProvider(
          AiProviderType.openai,
        );

        // Assert
        expect(result.isRight(), true);
        result.fold((failure) => fail('Should return success'), (
          vocabulariesList,
        ) {
          expect(vocabulariesList.length, 1);
          expect(vocabulariesList[0].english, 'OpenAI Word');
        });

        verify(
          mockLocalDataSource.getVocabulariesByProvider(AiProviderType.openai),
        ).called(1);
      });

      test('should get phrases by provider successfully', () async {
        // Arrange
        final phrases = [
          PhraseModel(
            english: 'Gemini Phrase',
            persian: 'عبارت Gemini',
            userId: 'current_user',
            aiProvider: AiProviderType.gemini,
            generatedAt: DateTime.now(),
            tokensUsed: 35,
            requestId: 'req_1',
            isUsed: false,
          ),
        ];

        when(
          mockLocalDataSource.getPhrasesByProvider(AiProviderType.gemini),
        ).thenAnswer((_) async => phrases);

        // Act
        final result = await repository.getPhrasesByProvider(
          AiProviderType.gemini,
        );

        // Assert
        expect(result.isRight(), true);
        result.fold((failure) => fail('Should return success'), (phrasesList) {
          expect(phrasesList.length, 1);
          expect(phrasesList[0].english, 'Gemini Phrase');
        });

        verify(
          mockLocalDataSource.getPhrasesByProvider(AiProviderType.gemini),
        ).called(1);
      });
    });

    group('Error Handling', () {
      test('should handle local data source errors gracefully', () async {
        // Arrange
        when(
          mockLocalDataSource.getUserAnalytics(),
        ).thenThrow(Exception('Local storage error'));

        // Act
        final result = await repository.getUserAnalytics();

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<CacheFailure>()),
          (analytics) => fail('Should return failure'),
        );
      });

      test('should handle remote data source errors gracefully', () async {
        // Arrange
        when(
          mockLocalDataSource.getUnusedVocabularies(),
        ).thenAnswer((_) async => []);
        when(
          mockRemoteDataSource.fetchDailyVocabularies(),
        ).thenAnswer((_) async => Left(ServerFailure('API error')));

        // Act
        final result = await repository.getDailyVocabularies();

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<ServerFailure>()),
          (vocabularies) => fail('Should return failure'),
        );
      });
    });
  });
}
