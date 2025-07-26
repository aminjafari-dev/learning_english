// daily_lessons_integration_test.dart
// Integration tests for the complete daily lessons feature flow.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_it/get_it.dart';
import 'package:learning_english/features/daily_lessons/presentation/pages/daily_lessons_page.dart';
import 'package:learning_english/features/daily_lessons/presentation/bloc/daily_lessons_bloc.dart';
import 'package:learning_english/features/daily_lessons/data/datasources/local/daily_lessons_local_data_source.dart';
import 'package:learning_english/features/daily_lessons/data/datasources/remote/ai_lessons_remote_data_source.dart';
import 'package:learning_english/features/daily_lessons/data/repositories/daily_lessons_repository_impl.dart';
import 'package:learning_english/features/daily_lessons/domain/usecases/get_daily_lessons_usecase.dart';
import 'package:learning_english/features/daily_lessons/domain/usecases/mark_vocabulary_as_used_usecase.dart';
import 'package:learning_english/features/daily_lessons/domain/usecases/mark_phrase_as_used_usecase.dart';
import 'package:learning_english/features/daily_lessons/domain/usecases/get_user_analytics_usecase.dart';
import 'package:learning_english/features/daily_lessons/domain/usecases/clear_user_data_usecase.dart';
import 'package:learning_english/features/daily_lessons/domain/entities/vocabulary.dart';
import 'package:learning_english/features/daily_lessons/domain/entities/phrase.dart';
import 'package:learning_english/features/daily_lessons/data/datasources/ai_provider_type.dart';

class MockAiLessonsRemoteDataSource extends Mock
    implements AiLessonsRemoteDataSource {}

void main() {
  group('DailyLessons Integration Tests', () {
    late GetIt getIt;
    late SharedPreferences prefs;
    late DailyLessonsLocalDataSource localDataSource;
    late MockAiLessonsRemoteDataSource mockRemoteDataSource;
    late DailyLessonsRepositoryImpl repository;
    late DailyLessonsBloc bloc;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();

      getIt = GetIt.instance;

      // Setup local data source
      localDataSource = DailyLessonsLocalDataSource(prefs);

      // Setup mock remote data source
      mockRemoteDataSource = MockAiLessonsRemoteDataSource();

      // Setup repository
      repository = DailyLessonsRepositoryImpl(
        remoteDataSource: mockRemoteDataSource,
        localDataSource: localDataSource,
      );

      // Setup use cases
      final getDailyLessonsUseCase = GetDailyLessonsUseCase(repository);
      final markVocabularyAsUsedUseCase = MarkVocabularyAsUsedUseCase(
        repository,
      );
      final markPhraseAsUsedUseCase = MarkPhraseAsUsedUseCase(repository);
      final getUserAnalyticsUseCase = GetUserAnalyticsUseCase(repository);
      final clearUserDataUseCase = ClearUserDataUseCase(repository);

      // Setup bloc
      bloc = DailyLessonsBloc(
        getDailyLessonsUseCase: getDailyLessonsUseCase,
        markVocabularyAsUsedUseCase: markVocabularyAsUsedUseCase,
        markPhraseAsUsedUseCase: markPhraseAsUsedUseCase,
        getUserAnalyticsUseCase: getUserAnalyticsUseCase,
        clearUserDataUseCase: clearUserDataUseCase,
      );
    });

    tearDown(() async {
      await prefs.clear();
      bloc.close();
      getIt.reset();
    });

    group('Complete User Journey', () {
      testWidgets('should load lessons from remote and save to local storage', (
        WidgetTester tester,
      ) async {
        // Arrange
        final remoteLessons = (
          vocabularies: [
            const Vocabulary(english: 'Perseverance', persian: 'پشتکار'),
            const Vocabulary(english: 'Resilience', persian: 'انعطاف‌پذیری'),
            const Vocabulary(english: 'Determination', persian: 'عزم'),
            const Vocabulary(english: 'Commitment', persian: 'تعهد'),
          ],
          phrases: [
            const Phrase(
              english: 'I owe it to myself',
              persian: 'به خودم مدیونم',
            ),
            const Phrase(
              english: 'Keep pushing forward',
              persian: 'به جلو ادامه بده',
            ),
          ],
        );

        when(
          () => mockRemoteDataSource.fetchDailyLessons(),
        ).thenAnswer((_) async => Right(remoteLessons));

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider<DailyLessonsBloc>.value(
              value: bloc,
              child: const DailyLessonsPage(),
            ),
          ),
        );

        // Trigger fetch
        bloc.add(const DailyLessonsEvent.fetchLessons());
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Perseverance'), findsOneWidget);
        expect(find.text('پشتکار'), findsOneWidget);
        expect(find.text('I owe it to myself'), findsOneWidget);
        expect(find.text('به خودم مدیونم'), findsOneWidget);

        // Verify data was saved to local storage
        final savedVocabularies = await localDataSource.getUserVocabularies();
        final savedPhrases = await localDataSource.getUserPhrases();

        expect(savedVocabularies.length, 4);
        expect(savedPhrases.length, 2);
        expect(savedVocabularies.first.english, 'Perseverance');
        expect(savedPhrases.first.english, 'I owe it to myself');
      });

      testWidgets('should load lessons from local storage when available', (
        WidgetTester tester,
      ) async {
        // Arrange - Pre-populate local storage
        final vocabulary = VocabularyModel(
          english: 'Cached Word',
          persian: 'کلمه کش شده',
          userId: 'current_user',
          aiProvider: AiProviderType.openai,
          generatedAt: DateTime.now(),
          tokensUsed: 30,
          requestId: 'req_1',
          isUsed: false,
        );

        final phrase = PhraseModel(
          english: 'Cached Phrase',
          persian: 'عبارت کش شده',
          userId: 'current_user',
          aiProvider: AiProviderType.openai,
          generatedAt: DateTime.now(),
          tokensUsed: 35,
          requestId: 'req_2',
          isUsed: false,
        );

        await localDataSource.saveUserVocabulary(vocabulary);
        await localDataSource.saveUserPhrase(phrase);

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider<DailyLessonsBloc>.value(
              value: bloc,
              child: const DailyLessonsPage(),
            ),
          ),
        );

        bloc.add(const DailyLessonsEvent.fetchLessons());
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Cached Word'), findsOneWidget);
        expect(find.text('کلمه کش شده'), findsOneWidget);
        expect(find.text('Cached Phrase'), findsOneWidget);
        expect(find.text('عبارت کش شده'), findsOneWidget);

        // Verify remote data source was not called
        verifyNever(() => mockRemoteDataSource.fetchDailyLessons());
      });

      testWidgets('should mark vocabulary as used when tapped', (
        WidgetTester tester,
      ) async {
        // Arrange - Pre-populate local storage
        final vocabulary = VocabularyModel(
          english: 'Test Word',
          persian: 'کلمه تست',
          userId: 'current_user',
          aiProvider: AiProviderType.openai,
          generatedAt: DateTime.now(),
          tokensUsed: 30,
          requestId: 'req_1',
          isUsed: false,
        );

        await localDataSource.saveUserVocabulary(vocabulary);

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider<DailyLessonsBloc>.value(
              value: bloc,
              child: const DailyLessonsPage(),
            ),
          ),
        );

        bloc.add(const DailyLessonsEvent.fetchLessons());
        await tester.pumpAndSettle();

        // Tap on vocabulary card
        await tester.tap(find.text('Test Word'));
        await tester.pumpAndSettle();

        // Assert
        final updatedVocabularies = await localDataSource.getUserVocabularies();
        final updatedVocabulary = updatedVocabularies.firstWhere(
          (v) => v.english == 'Test Word',
        );
        expect(updatedVocabulary.isUsed, true);
      });

      testWidgets('should mark phrase as used when tapped', (
        WidgetTester tester,
      ) async {
        // Arrange - Pre-populate local storage
        final phrase = PhraseModel(
          english: 'Test Phrase',
          persian: 'عبارت تست',
          userId: 'current_user',
          aiProvider: AiProviderType.openai,
          generatedAt: DateTime.now(),
          tokensUsed: 35,
          requestId: 'req_1',
          isUsed: false,
        );

        await localDataSource.saveUserPhrase(phrase);

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider<DailyLessonsBloc>.value(
              value: bloc,
              child: const DailyLessonsPage(),
            ),
          ),
        );

        bloc.add(const DailyLessonsEvent.fetchLessons());
        await tester.pumpAndSettle();

        // Tap on phrase card
        await tester.tap(find.text('Test Phrase'));
        await tester.pumpAndSettle();

        // Assert
        final updatedPhrases = await localDataSource.getUserPhrases();
        final updatedPhrase = updatedPhrases.firstWhere(
          (p) => p.english == 'Test Phrase',
        );
        expect(updatedPhrase.isUsed, true);
      });
    });

    group('Analytics Integration', () {
      testWidgets('should display analytics when requested', (
        WidgetTester tester,
      ) async {
        // Arrange - Pre-populate local storage with data
        final vocabulary1 = VocabularyModel(
          english: 'Word 1',
          persian: 'کلمه ۱',
          userId: 'current_user',
          aiProvider: AiProviderType.openai,
          generatedAt: DateTime.now(),
          tokensUsed: 30,
          requestId: 'req_1',
          isUsed: true,
        );

        final vocabulary2 = VocabularyModel(
          english: 'Word 2',
          persian: 'کلمه ۲',
          userId: 'current_user',
          aiProvider: AiProviderType.gemini,
          generatedAt: DateTime.now(),
          tokensUsed: 35,
          requestId: 'req_2',
          isUsed: false,
        );

        final phrase1 = PhraseModel(
          english: 'Phrase 1',
          persian: 'عبارت ۱',
          userId: 'current_user',
          aiProvider: AiProviderType.openai,
          generatedAt: DateTime.now(),
          tokensUsed: 40,
          requestId: 'req_3',
          isUsed: true,
        );

        await localDataSource.saveUserVocabulary(vocabulary1);
        await localDataSource.saveUserVocabulary(vocabulary2);
        await localDataSource.saveUserPhrase(phrase1);

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider<DailyLessonsBloc>.value(
              value: bloc,
              child: const DailyLessonsPage(),
            ),
          ),
        );

        bloc.add(const DailyLessonsEvent.getUserAnalytics());
        await tester.pumpAndSettle();

        // Assert
        final analytics = await localDataSource.getUserAnalytics();
        expect(analytics['totalVocabularies'], 2);
        expect(analytics['totalPhrases'], 1);
        expect(analytics['totalTokens'], 105); // 30 + 35 + 40
        expect(analytics['usedVocabularies'], 1);
        expect(analytics['usedPhrases'], 1);
      });
    });

    group('Data Management Integration', () {
      testWidgets('should clear all user data when requested', (
        WidgetTester tester,
      ) async {
        // Arrange - Pre-populate local storage
        final vocabulary = VocabularyModel(
          english: 'Test Word',
          persian: 'کلمه تست',
          userId: 'current_user',
          aiProvider: AiProviderType.openai,
          generatedAt: DateTime.now(),
          tokensUsed: 30,
          requestId: 'req_1',
          isUsed: false,
        );

        final phrase = PhraseModel(
          english: 'Test Phrase',
          persian: 'عبارت تست',
          userId: 'current_user',
          aiProvider: AiProviderType.openai,
          generatedAt: DateTime.now(),
          tokensUsed: 35,
          requestId: 'req_2',
          isUsed: false,
        );

        await localDataSource.saveUserVocabulary(vocabulary);
        await localDataSource.saveUserPhrase(phrase);

        // Verify data exists
        expect((await localDataSource.getUserVocabularies()).length, 1);
        expect((await localDataSource.getUserPhrases()).length, 1);

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider<DailyLessonsBloc>.value(
              value: bloc,
              child: const DailyLessonsPage(),
            ),
          ),
        );

        bloc.add(const DailyLessonsEvent.clearUserData());
        await tester.pumpAndSettle();

        // Assert
        expect((await localDataSource.getUserVocabularies()).length, 0);
        expect((await localDataSource.getUserPhrases()).length, 0);
      });
    });

    group('Error Handling Integration', () {
      testWidgets('should handle remote data source failures gracefully', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(
          () => mockRemoteDataSource.fetchDailyLessons(),
        ).thenAnswer((_) async => const Left(ServerFailure('API error')));

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider<DailyLessonsBloc>.value(
              value: bloc,
              child: const DailyLessonsPage(),
            ),
          ),
        );

        bloc.add(const DailyLessonsEvent.fetchLessons());
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('API error'), findsOneWidget);
        expect(find.byType(ElevatedButton), findsOneWidget); // Retry button
      });

      testWidgets('should handle local storage failures gracefully', (
        WidgetTester tester,
      ) async {
        // Arrange - Corrupt local storage by setting invalid data
        await prefs.setStringList('user_vocabularies', ['invalid json']);

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider<DailyLessonsBloc>.value(
              value: bloc,
              child: const DailyLessonsPage(),
            ),
          ),
        );

        bloc.add(const DailyLessonsEvent.getUserAnalytics());
        await tester.pumpAndSettle();

        // Assert - Should handle the error gracefully
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });
    });

    group('Performance Integration', () {
      testWidgets('should handle large datasets efficiently', (
        WidgetTester tester,
      ) async {
        // Arrange - Create large dataset
        final vocabularies = List.generate(
          100,
          (index) => VocabularyModel(
            english: 'Word $index',
            persian: 'کلمه $index',
            userId: 'current_user',
            aiProvider: AiProviderType.openai,
            generatedAt: DateTime.now(),
            tokensUsed: 30,
            requestId: 'req_$index',
            isUsed: index % 2 == 0, // Half used, half unused
          ),
        );

        final phrases = List.generate(
          50,
          (index) => PhraseModel(
            english: 'Phrase $index',
            persian: 'عبارت $index',
            userId: 'current_user',
            aiProvider: AiProviderType.gemini,
            generatedAt: DateTime.now(),
            tokensUsed: 35,
            requestId: 'req_${index + 100}',
            isUsed: index % 2 == 0, // Half used, half unused
          ),
        );

        // Save all data
        for (final vocabulary in vocabularies) {
          await localDataSource.saveUserVocabulary(vocabulary);
        }
        for (final phrase in phrases) {
          await localDataSource.saveUserPhrase(phrase);
        }

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider<DailyLessonsBloc>.value(
              value: bloc,
              child: const DailyLessonsPage(),
            ),
          ),
        );

        bloc.add(const DailyLessonsEvent.fetchLessons());
        await tester.pumpAndSettle();

        // Assert
        final unusedVocabularies =
            await localDataSource.getUnusedVocabularies();
        final unusedPhrases = await localDataSource.getUnusedPhrases();

        expect(unusedVocabularies.length, 50); // Half of 100
        expect(unusedPhrases.length, 25); // Half of 50

        // Should display first 4 vocabularies and 2 phrases
        expect(find.text('Word 1'), findsOneWidget);
        expect(find.text('Word 3'), findsOneWidget);
        expect(find.text('Phrase 1'), findsOneWidget);
        expect(find.text('Phrase 3'), findsOneWidget);
      });
    });
  });
}
