// daily_lessons_bloc_test.dart
// Tests for the BLoC that manages daily lessons state and user-specific operations.

import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:learning_english/features/daily_lessons/presentation/bloc/daily_lessons_bloc.dart';
import 'package:learning_english/features/daily_lessons/presentation/bloc/daily_lessons_event.dart';
import 'package:learning_english/features/daily_lessons/presentation/bloc/daily_lessons_state.dart';
import 'package:learning_english/features/daily_lessons/domain/usecases/get_daily_lessons_usecase.dart';
import 'package:learning_english/features/daily_lessons/domain/usecases/mark_vocabulary_as_used_usecase.dart';
import 'package:learning_english/features/daily_lessons/domain/usecases/mark_phrase_as_used_usecase.dart';
import 'package:learning_english/features/daily_lessons/domain/usecases/get_user_analytics_usecase.dart';
import 'package:learning_english/features/daily_lessons/domain/usecases/clear_user_data_usecase.dart';
import 'package:learning_english/features/daily_lessons/domain/entities/vocabulary.dart';
import 'package:learning_english/features/daily_lessons/domain/entities/phrase.dart';
import 'package:learning_english/core/error/failure.dart';

class MockGetDailyLessonsUseCase extends Mock
    implements GetDailyLessonsUseCase {}

class MockMarkVocabularyAsUsedUseCase extends Mock
    implements MarkVocabularyAsUsedUseCase {}

class MockMarkPhraseAsUsedUseCase extends Mock
    implements MarkPhraseAsUsedUseCase {}

class MockGetUserAnalyticsUseCase extends Mock
    implements GetUserAnalyticsUseCase {}

class MockClearUserDataUseCase extends Mock implements ClearUserDataUseCase {}

void main() {
  group('DailyLessonsBloc', () {
    late DailyLessonsBloc bloc;
    late MockGetDailyLessonsUseCase mockGetDailyLessonsUseCase;
    late MockMarkVocabularyAsUsedUseCase mockMarkVocabularyAsUsedUseCase;
    late MockMarkPhraseAsUsedUseCase mockMarkPhraseAsUsedUseCase;
    late MockGetUserAnalyticsUseCase mockGetUserAnalyticsUseCase;
    late MockClearUserDataUseCase mockClearUserDataUseCase;

    setUp(() {
      mockGetDailyLessonsUseCase = MockGetDailyLessonsUseCase();
      mockMarkVocabularyAsUsedUseCase = MockMarkVocabularyAsUsedUseCase();
      mockMarkPhraseAsUsedUseCase = MockMarkPhraseAsUsedUseCase();
      mockGetUserAnalyticsUseCase = MockGetUserAnalyticsUseCase();
      mockClearUserDataUseCase = MockClearUserDataUseCase();

      bloc = DailyLessonsBloc(
        getDailyLessonsUseCase: mockGetDailyLessonsUseCase,
        markVocabularyAsUsedUseCase: mockMarkVocabularyAsUsedUseCase,
        markPhraseAsUsedUseCase: mockMarkPhraseAsUsedUseCase,
        getUserAnalyticsUseCase: mockGetUserAnalyticsUseCase,
        clearUserDataUseCase: mockClearUserDataUseCase,
      );
    });

    tearDown(() {
      bloc.close();
    });

    group('Initial State', () {
      test('should have correct initial state', () {
        expect(
          bloc.state,
          const DailyLessonsState(
            vocabularies: VocabulariesState.initial(),
            phrases: PhrasesState.initial(),
            analytics: UserAnalyticsState.initial(),
            dataManagement: UserDataManagementState.initial(),
            isRefreshing: false,
          ),
        );
      });
    });

    group('Fetch Lessons', () {
      test(
        'should emit loading and then success states when fetch is successful',
        () async {
          // Arrange
          final lessons = (
            vocabularies: [
              const Vocabulary(english: 'Word 1', persian: 'کلمه ۱'),
              const Vocabulary(english: 'Word 2', persian: 'کلمه ۲'),
              const Vocabulary(english: 'Word 3', persian: 'کلمه ۳'),
              const Vocabulary(english: 'Word 4', persian: 'کلمه ۴'),
            ],
            phrases: [
              const Phrase(english: 'Phrase 1', persian: 'عبارت ۱'),
              const Phrase(english: 'Phrase 2', persian: 'عبارت ۲'),
            ],
          );

          when(
            () => mockGetDailyLessonsUseCase(null),
          ).thenAnswer((_) async => Right(lessons));

          // Act & Assert
          await expectLater(
            bloc.stream,
            emitsInOrder([
              const DailyLessonsState(
                vocabularies: VocabulariesState.loading(),
                phrases: PhrasesState.loading(),
                analytics: UserAnalyticsState.initial(),
                dataManagement: UserDataManagementState.initial(),
                isRefreshing: false,
              ),
              DailyLessonsState(
                vocabularies: VocabulariesState.completed(lessons.vocabularies),
                phrases: PhrasesState.completed(lessons.phrases),
                analytics: UserAnalyticsState.initial(),
                dataManagement: UserDataManagementState.initial(),
                isRefreshing: false,
              ),
            ]),
          );

          bloc.add(const DailyLessonsEvent.fetchLessons());
        },
      );

      test(
        'should emit loading and then error states when fetch fails',
        () async {
          // Arrange
          when(
            () => mockGetDailyLessonsUseCase(null),
          ).thenAnswer((_) async => const Left(ServerFailure('Network error')));

          // Act & Assert
          await expectLater(
            bloc.stream,
            emitsInOrder([
              const DailyLessonsState(
                vocabularies: VocabulariesState.loading(),
                phrases: PhrasesState.loading(),
                analytics: UserAnalyticsState.initial(),
                dataManagement: UserDataManagementState.initial(),
                isRefreshing: false,
              ),
              const DailyLessonsState(
                vocabularies: VocabulariesState.error('Network error'),
                phrases: PhrasesState.error('Network error'),
                analytics: UserAnalyticsState.initial(),
                dataManagement: UserDataManagementState.initial(),
                isRefreshing: false,
              ),
            ]),
          );

          bloc.add(const DailyLessonsEvent.fetchLessons());
        },
      );
    });

    group('Mark Vocabulary As Used', () {
      test(
        'should emit loading and then success states when marking vocabulary succeeds',
        () async {
          // Arrange
          const english = 'Perseverance';
          when(
            () => mockMarkVocabularyAsUsedUseCase(english),
          ).thenAnswer((_) async => const Right(true));

          // Act & Assert
          await expectLater(
            bloc.stream,
            emitsInOrder([
              const DailyLessonsState(
                vocabularies: VocabulariesState.initial(),
                phrases: PhrasesState.initial(),
                analytics: UserAnalyticsState.initial(),
                dataManagement: UserDataManagementState.loading(),
                isRefreshing: false,
              ),
              const DailyLessonsState(
                vocabularies: VocabulariesState.initial(),
                phrases: PhrasesState.initial(),
                analytics: UserAnalyticsState.initial(),
                dataManagement: UserDataManagementState.success(),
                isRefreshing: false,
              ),
            ]),
          );

          bloc.add(
            const DailyLessonsEvent.markVocabularyAsUsed(english: english),
          );
        },
      );

      test(
        'should emit loading and then error states when marking vocabulary fails',
        () async {
          // Arrange
          const english = 'Perseverance';
          when(
            () => mockMarkVocabularyAsUsedUseCase(english),
          ).thenAnswer((_) async => const Left(CacheFailure('Storage error')));

          // Act & Assert
          await expectLater(
            bloc.stream,
            emitsInOrder([
              const DailyLessonsState(
                vocabularies: VocabulariesState.initial(),
                phrases: PhrasesState.initial(),
                analytics: UserAnalyticsState.initial(),
                dataManagement: UserDataManagementState.loading(),
                isRefreshing: false,
              ),
              const DailyLessonsState(
                vocabularies: VocabulariesState.initial(),
                phrases: PhrasesState.initial(),
                analytics: UserAnalyticsState.initial(),
                dataManagement: UserDataManagementState.error('Storage error'),
                isRefreshing: false,
              ),
            ]),
          );

          bloc.add(
            const DailyLessonsEvent.markVocabularyAsUsed(english: english),
          );
        },
      );
    });

    group('Mark Phrase As Used', () {
      test(
        'should emit loading and then success states when marking phrase succeeds',
        () async {
          // Arrange
          const english = 'I owe it to myself';
          when(
            () => mockMarkPhraseAsUsedUseCase(english),
          ).thenAnswer((_) async => const Right(true));

          // Act & Assert
          await expectLater(
            bloc.stream,
            emitsInOrder([
              const DailyLessonsState(
                vocabularies: VocabulariesState.initial(),
                phrases: PhrasesState.initial(),
                analytics: UserAnalyticsState.initial(),
                dataManagement: UserDataManagementState.loading(),
                isRefreshing: false,
              ),
              const DailyLessonsState(
                vocabularies: VocabulariesState.initial(),
                phrases: PhrasesState.initial(),
                analytics: UserAnalyticsState.initial(),
                dataManagement: UserDataManagementState.success(),
                isRefreshing: false,
              ),
            ]),
          );

          bloc.add(const DailyLessonsEvent.markPhraseAsUsed(english: english));
        },
      );

      test(
        'should emit loading and then error states when marking phrase fails',
        () async {
          // Arrange
          const english = 'I owe it to myself';
          when(
            () => mockMarkPhraseAsUsedUseCase(english),
          ).thenAnswer((_) async => const Left(CacheFailure('Storage error')));

          // Act & Assert
          await expectLater(
            bloc.stream,
            emitsInOrder([
              const DailyLessonsState(
                vocabularies: VocabulariesState.initial(),
                phrases: PhrasesState.initial(),
                analytics: UserAnalyticsState.initial(),
                dataManagement: UserDataManagementState.loading(),
                isRefreshing: false,
              ),
              const DailyLessonsState(
                vocabularies: VocabulariesState.initial(),
                phrases: PhrasesState.initial(),
                analytics: UserAnalyticsState.initial(),
                dataManagement: UserDataManagementState.error('Storage error'),
                isRefreshing: false,
              ),
            ]),
          );

          bloc.add(const DailyLessonsEvent.markPhraseAsUsed(english: english));
        },
      );
    });

    group('Get User Analytics', () {
      test(
        'should emit loading and then success states when getting analytics succeeds',
        () async {
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
            },
          };

          when(
            () => mockGetUserAnalyticsUseCase(null),
          ).thenAnswer((_) async => Right(analytics));

          // Act & Assert
          await expectLater(
            bloc.stream,
            emitsInOrder([
              const DailyLessonsState(
                vocabularies: VocabulariesState.initial(),
                phrases: PhrasesState.initial(),
                analytics: UserAnalyticsState.loading(),
                dataManagement: UserDataManagementState.initial(),
                isRefreshing: false,
              ),
              DailyLessonsState(
                vocabularies: VocabulariesState.initial(),
                phrases: PhrasesState.initial(),
                analytics: UserAnalyticsState.loaded(analytics),
                dataManagement: UserDataManagementState.initial(),
                isRefreshing: false,
              ),
            ]),
          );

          bloc.add(const DailyLessonsEvent.getUserAnalytics());
        },
      );

      test(
        'should emit loading and then error states when getting analytics fails',
        () async {
          // Arrange
          when(() => mockGetUserAnalyticsUseCase(null)).thenAnswer(
            (_) async => const Left(CacheFailure('Analytics error')),
          );

          // Act & Assert
          await expectLater(
            bloc.stream,
            emitsInOrder([
              const DailyLessonsState(
                vocabularies: VocabulariesState.initial(),
                phrases: PhrasesState.initial(),
                analytics: UserAnalyticsState.loading(),
                dataManagement: UserDataManagementState.initial(),
                isRefreshing: false,
              ),
              const DailyLessonsState(
                vocabularies: VocabulariesState.initial(),
                phrases: PhrasesState.initial(),
                analytics: UserAnalyticsState.error('Analytics error'),
                dataManagement: UserDataManagementState.initial(),
                isRefreshing: false,
              ),
            ]),
          );

          bloc.add(const DailyLessonsEvent.getUserAnalytics());
        },
      );
    });

    group('Clear User Data', () {
      test(
        'should emit loading and then success states when clearing data succeeds',
        () async {
          // Arrange
          when(
            () => mockClearUserDataUseCase(null),
          ).thenAnswer((_) async => const Right(true));

          // Act & Assert
          await expectLater(
            bloc.stream,
            emitsInOrder([
              const DailyLessonsState(
                vocabularies: VocabulariesState.initial(),
                phrases: PhrasesState.initial(),
                analytics: UserAnalyticsState.initial(),
                dataManagement: UserDataManagementState.loading(),
                isRefreshing: false,
              ),
              const DailyLessonsState(
                vocabularies: VocabulariesState.initial(),
                phrases: PhrasesState.initial(),
                analytics: UserAnalyticsState.initial(),
                dataManagement: UserDataManagementState.success(),
                isRefreshing: false,
              ),
            ]),
          );

          bloc.add(const DailyLessonsEvent.clearUserData());
        },
      );

      test(
        'should emit loading and then error states when clearing data fails',
        () async {
          // Arrange
          when(() => mockClearUserDataUseCase(null)).thenAnswer(
            (_) async => const Left(CacheFailure('Clear data error')),
          );

          // Act & Assert
          await expectLater(
            bloc.stream,
            emitsInOrder([
              const DailyLessonsState(
                vocabularies: VocabulariesState.initial(),
                phrases: PhrasesState.initial(),
                analytics: UserAnalyticsState.initial(),
                dataManagement: UserDataManagementState.loading(),
                isRefreshing: false,
              ),
              const DailyLessonsState(
                vocabularies: VocabulariesState.initial(),
                phrases: PhrasesState.initial(),
                analytics: UserAnalyticsState.initial(),
                dataManagement: UserDataManagementState.error(
                  'Clear data error',
                ),
                isRefreshing: false,
              ),
            ]),
          );

          bloc.add(const DailyLessonsEvent.clearUserData());
        },
      );
    });

    group('Refresh Lessons', () {
      test(
        'should emit refreshing states when refresh is successful',
        () async {
          // Arrange
          final lessons = (
            vocabularies: [
              const Vocabulary(english: 'New Word 1', persian: 'کلمه جدید ۱'),
              const Vocabulary(english: 'New Word 2', persian: 'کلمه جدید ۲'),
              const Vocabulary(english: 'New Word 3', persian: 'کلمه جدید ۳'),
              const Vocabulary(english: 'New Word 4', persian: 'کلمه جدید ۴'),
            ],
            phrases: [
              const Phrase(english: 'New Phrase 1', persian: 'عبارت جدید ۱'),
              const Phrase(english: 'New Phrase 2', persian: 'عبارت جدید ۲'),
            ],
          );

          when(
            () => mockGetDailyLessonsUseCase(null),
          ).thenAnswer((_) async => Right(lessons));

          // Act & Assert
          await expectLater(
            bloc.stream,
            emitsInOrder([
              DailyLessonsState(
                vocabularies: VocabulariesState.loading(),
                phrases: PhrasesState.loading(),
                analytics: UserAnalyticsState.initial(),
                dataManagement: UserDataManagementState.initial(),
                isRefreshing: true,
              ),
              DailyLessonsState(
                vocabularies: VocabulariesState.completed(lessons.vocabularies),
                phrases: PhrasesState.completed(lessons.phrases),
                analytics: UserAnalyticsState.initial(),
                dataManagement: UserDataManagementState.initial(),
                isRefreshing: false,
              ),
            ]),
          );

          bloc.add(const DailyLessonsEvent.refreshLessons());
        },
      );
    });

    group('Error Handling', () {
      test('should handle network failures gracefully', () async {
        // Arrange
        when(() => mockGetDailyLessonsUseCase(null)).thenAnswer(
          (_) async => const Left(NetworkFailure('No internet connection')),
        );

        // Act & Assert
        await expectLater(
          bloc.stream,
          emitsInOrder([
            const DailyLessonsState(
              vocabularies: VocabulariesState.loading(),
              phrases: PhrasesState.loading(),
              analytics: UserAnalyticsState.initial(),
              dataManagement: UserDataManagementState.initial(),
              isRefreshing: false,
            ),
            const DailyLessonsState(
              vocabularies: VocabulariesState.error('No internet connection'),
              phrases: PhrasesState.error('No internet connection'),
              analytics: UserAnalyticsState.initial(),
              dataManagement: UserDataManagementState.initial(),
              isRefreshing: false,
            ),
          ]),
        );

        bloc.add(const DailyLessonsEvent.fetchLessons());
      });

      test('should handle server failures gracefully', () async {
        // Arrange
        when(
          () => mockGetDailyLessonsUseCase(null),
        ).thenAnswer((_) async => const Left(ServerFailure('Server is down')));

        // Act & Assert
        await expectLater(
          bloc.stream,
          emitsInOrder([
            const DailyLessonsState(
              vocabularies: VocabulariesState.loading(),
              phrases: PhrasesState.loading(),
              analytics: UserAnalyticsState.initial(),
              dataManagement: UserDataManagementState.initial(),
              isRefreshing: false,
            ),
            const DailyLessonsState(
              vocabularies: VocabulariesState.error('Server is down'),
              phrases: PhrasesState.error('Server is down'),
              analytics: UserAnalyticsState.initial(),
              dataManagement: UserDataManagementState.initial(),
              isRefreshing: false,
            ),
          ]),
        );

        bloc.add(const DailyLessonsEvent.fetchLessons());
      });
    });

    group('State Transitions', () {
      test('should maintain other states when updating vocabularies', () async {
        // Arrange
        final lessons = (
          vocabularies: [
            const Vocabulary(english: 'Word 1', persian: 'کلمه ۱'),
          ],
          phrases: [const Phrase(english: 'Phrase 1', persian: 'عبارت ۱')],
        );

        when(
          () => mockGetDailyLessonsUseCase(null),
        ).thenAnswer((_) async => Right(lessons));

        // Act & Assert
        await expectLater(
          bloc.stream,
          emitsInOrder([
            const DailyLessonsState(
              vocabularies: VocabulariesState.loading(),
              phrases: PhrasesState.loading(),
              analytics: UserAnalyticsState.initial(),
              dataManagement: UserDataManagementState.initial(),
              isRefreshing: false,
            ),
            DailyLessonsState(
              vocabularies: VocabulariesState.completed(lessons.vocabularies),
              phrases: PhrasesState.completed(lessons.phrases),
              analytics: UserAnalyticsState.initial(),
              dataManagement: UserDataManagementState.initial(),
              isRefreshing: false,
            ),
          ]),
        );

        bloc.add(const DailyLessonsEvent.fetchLessons());
      });

      test('should maintain other states when updating analytics', () async {
        // Arrange
        final analytics = {'totalVocabularies': 5};
        when(
          () => mockGetUserAnalyticsUseCase(null),
        ).thenAnswer((_) async => Right(analytics));

        // Act & Assert
        await expectLater(
          bloc.stream,
          emitsInOrder([
            const DailyLessonsState(
              vocabularies: VocabulariesState.initial(),
              phrases: PhrasesState.initial(),
              analytics: UserAnalyticsState.loading(),
              dataManagement: UserDataManagementState.initial(),
              isRefreshing: false,
            ),
            DailyLessonsState(
              vocabularies: VocabulariesState.initial(),
              phrases: PhrasesState.initial(),
              analytics: UserAnalyticsState.loaded(analytics),
              dataManagement: UserDataManagementState.initial(),
              isRefreshing: false,
            ),
          ]),
        );

        bloc.add(const DailyLessonsEvent.getUserAnalytics());
      });
    });
  });
}
