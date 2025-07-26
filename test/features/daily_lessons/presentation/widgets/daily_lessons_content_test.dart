// daily_lessons_content_test.dart
// Tests for the daily lessons content widget that displays vocabularies and phrases.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:learning_english/features/daily_lessons/presentation/bloc/daily_lessons_bloc.dart';
import 'package:learning_english/features/daily_lessons/presentation/bloc/daily_lessons_event.dart';
import 'package:learning_english/features/daily_lessons/presentation/bloc/daily_lessons_state.dart';
import 'package:learning_english/features/daily_lessons/presentation/widgets/daily_lessons_content.dart';
import 'package:learning_english/features/daily_lessons/domain/entities/vocabulary.dart';
import 'package:learning_english/features/daily_lessons/domain/entities/phrase.dart';

class MockDailyLessonsBloc extends Mock implements DailyLessonsBloc {}

void main() {
  group('DailyLessonsContent', () {
    late MockDailyLessonsBloc mockBloc;

    setUp(() {
      mockBloc = MockDailyLessonsBloc();
    });

    Widget createWidgetUnderTest() {
      return MaterialApp(
        home: BlocProvider<DailyLessonsBloc>.value(
          value: mockBloc,
          child: const DailyLessonsContent(),
        ),
      );
    }

    group('Initial State', () {
      testWidgets('should show loading indicator when in initial state', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(() => mockBloc.state).thenReturn(
          const DailyLessonsState(
            vocabularies: VocabulariesState.initial(),
            phrases: PhrasesState.initial(),
            analytics: UserAnalyticsState.initial(),
            dataManagement: UserDataManagementState.initial(),
            isRefreshing: false,
          ),
        );

        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });
    });

    group('Loading State', () {
      testWidgets('should show loading indicator when loading', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(() => mockBloc.state).thenReturn(
          const DailyLessonsState(
            vocabularies: VocabulariesState.loading(),
            phrases: PhrasesState.loading(),
            analytics: UserAnalyticsState.initial(),
            dataManagement: UserDataManagementState.initial(),
            isRefreshing: false,
          ),
        );

        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });
    });

    group('Success State', () {
      testWidgets(
        'should display vocabularies and phrases when loaded successfully',
        (WidgetTester tester) async {
          // Arrange
          final vocabularies = [
            const Vocabulary(english: 'Perseverance', persian: 'پشتکار'),
            const Vocabulary(english: 'Resilience', persian: 'انعطاف‌پذیری'),
            const Vocabulary(english: 'Determination', persian: 'عزم'),
            const Vocabulary(english: 'Commitment', persian: 'تعهد'),
          ];

          final phrases = [
            const Phrase(
              english: 'I owe it to myself',
              persian: 'به خودم مدیونم',
            ),
            const Phrase(
              english: 'Keep pushing forward',
              persian: 'به جلو ادامه بده',
            ),
          ];

          when(() => mockBloc.state).thenReturn(
            DailyLessonsState(
              vocabularies: VocabulariesState.completed(vocabularies),
              phrases: PhrasesState.completed(phrases),
              analytics: UserAnalyticsState.initial(),
              dataManagement: UserDataManagementState.initial(),
              isRefreshing: false,
            ),
          );

          // Act
          await tester.pumpWidget(createWidgetUnderTest());

          // Assert
          expect(find.text('Perseverance'), findsOneWidget);
          expect(find.text('پشتکار'), findsOneWidget);
          expect(find.text('Resilience'), findsOneWidget);
          expect(find.text('انعطاف‌پذیری'), findsOneWidget);
          expect(find.text('I owe it to myself'), findsOneWidget);
          expect(find.text('به خودم مدیونم'), findsOneWidget);
          expect(find.text('Keep pushing forward'), findsOneWidget);
          expect(find.text('به جلو ادامه بده'), findsOneWidget);
        },
      );

      testWidgets('should display vocabulary cards with correct styling', (
        WidgetTester tester,
      ) async {
        // Arrange
        final vocabularies = [
          const Vocabulary(english: 'Test Word', persian: 'کلمه تست'),
        ];

        when(() => mockBloc.state).thenReturn(
          DailyLessonsState(
            vocabularies: VocabulariesState.completed(vocabularies),
            phrases: PhrasesState.initial(),
            analytics: UserAnalyticsState.initial(),
            dataManagement: UserDataManagementState.initial(),
            isRefreshing: false,
          ),
        );

        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert
        expect(find.byType(Card), findsWidgets);
        expect(find.text('Test Word'), findsOneWidget);
        expect(find.text('کلمه تست'), findsOneWidget);
      });

      testWidgets('should display phrase cards with correct styling', (
        WidgetTester tester,
      ) async {
        // Arrange
        final phrases = [
          const Phrase(english: 'Test Phrase', persian: 'عبارت تست'),
        ];

        when(() => mockBloc.state).thenReturn(
          DailyLessonsState(
            vocabularies: VocabulariesState.initial(),
            phrases: PhrasesState.completed(phrases),
            analytics: UserAnalyticsState.initial(),
            dataManagement: UserDataManagementState.initial(),
            isRefreshing: false,
          ),
        );

        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert
        expect(find.byType(Card), findsWidgets);
        expect(find.text('Test Phrase'), findsOneWidget);
        expect(find.text('عبارت تست'), findsOneWidget);
      });
    });

    group('Error State', () {
      testWidgets(
        'should display error message when vocabularies fail to load',
        (WidgetTester tester) async {
          // Arrange
          when(() => mockBloc.state).thenReturn(
            const DailyLessonsState(
              vocabularies: VocabulariesState.error(
                'Failed to load vocabularies',
              ),
              phrases: PhrasesState.initial(),
              analytics: UserAnalyticsState.initial(),
              dataManagement: UserDataManagementState.initial(),
              isRefreshing: false,
            ),
          );

          // Act
          await tester.pumpWidget(createWidgetUnderTest());

          // Assert
          expect(find.text('Failed to load vocabularies'), findsOneWidget);
          expect(find.byType(ElevatedButton), findsOneWidget); // Retry button
        },
      );

      testWidgets('should display error message when phrases fail to load', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(() => mockBloc.state).thenReturn(
          const DailyLessonsState(
            vocabularies: VocabulariesState.initial(),
            phrases: PhrasesState.error('Failed to load phrases'),
            analytics: UserAnalyticsState.initial(),
            dataManagement: UserDataManagementState.initial(),
            isRefreshing: false,
          ),
        );

        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert
        expect(find.text('Failed to load phrases'), findsOneWidget);
        expect(find.byType(ElevatedButton), findsOneWidget); // Retry button
      });

      testWidgets('should trigger retry when retry button is tapped', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(() => mockBloc.state).thenReturn(
          const DailyLessonsState(
            vocabularies: VocabulariesState.error('Network error'),
            phrases: PhrasesState.initial(),
            analytics: UserAnalyticsState.initial(),
            dataManagement: UserDataManagementState.initial(),
            isRefreshing: false,
          ),
        );

        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.tap(find.byType(ElevatedButton));
        await tester.pump();

        // Assert
        verify(
          () => mockBloc.add(const DailyLessonsEvent.fetchLessons()),
        ).called(1);
      });
    });

    group('Empty State', () {
      testWidgets(
        'should display empty state when no vocabularies are available',
        (WidgetTester tester) async {
          // Arrange
          when(() => mockBloc.state).thenReturn(
            const DailyLessonsState(
              vocabularies: VocabulariesState.completed([]),
              phrases: PhrasesState.initial(),
              analytics: UserAnalyticsState.initial(),
              dataManagement: UserDataManagementState.initial(),
              isRefreshing: false,
            ),
          );

          // Act
          await tester.pumpWidget(createWidgetUnderTest());

          // Assert
          expect(find.text('No vocabularies available'), findsOneWidget);
        },
      );

      testWidgets('should display empty state when no phrases are available', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(() => mockBloc.state).thenReturn(
          const DailyLessonsState(
            vocabularies: VocabulariesState.initial(),
            phrases: PhrasesState.completed([]),
            analytics: UserAnalyticsState.initial(),
            dataManagement: UserDataManagementState.initial(),
            isRefreshing: false,
          ),
        );

        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert
        expect(find.text('No phrases available'), findsOneWidget);
      });
    });

    group('User Interaction', () {
      testWidgets(
        'should trigger vocabulary marking when vocabulary card is tapped',
        (WidgetTester tester) async {
          // Arrange
          final vocabularies = [
            const Vocabulary(english: 'Test Word', persian: 'کلمه تست'),
          ];

          when(() => mockBloc.state).thenReturn(
            DailyLessonsState(
              vocabularies: VocabulariesState.completed(vocabularies),
              phrases: PhrasesState.initial(),
              analytics: UserAnalyticsState.initial(),
              dataManagement: UserDataManagementState.initial(),
              isRefreshing: false,
            ),
          );

          // Act
          await tester.pumpWidget(createWidgetUnderTest());
          await tester.tap(find.text('Test Word'));
          await tester.pump();

          // Assert
          verify(
            () => mockBloc.add(
              const DailyLessonsEvent.markVocabularyAsUsed(
                english: 'Test Word',
              ),
            ),
          ).called(1);
        },
      );

      testWidgets('should trigger phrase marking when phrase card is tapped', (
        WidgetTester tester,
      ) async {
        // Arrange
        final phrases = [
          const Phrase(english: 'Test Phrase', persian: 'عبارت تست'),
        ];

        when(() => mockBloc.state).thenReturn(
          DailyLessonsState(
            vocabularies: VocabulariesState.initial(),
            phrases: PhrasesState.completed(phrases),
            analytics: UserAnalyticsState.initial(),
            dataManagement: UserDataManagementState.initial(),
            isRefreshing: false,
          ),
        );

        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.tap(find.text('Test Phrase'));
        await tester.pump();

        // Assert
        verify(
          () => mockBloc.add(
            const DailyLessonsEvent.markPhraseAsUsed(english: 'Test Phrase'),
          ),
        ).called(1);
      });
    });

    group('Analytics Integration', () {
      testWidgets(
        'should display analytics button when analytics are available',
        (WidgetTester tester) async {
          // Arrange
          final analytics = {
            'totalVocabularies': 10,
            'totalPhrases': 5,
            'totalTokens': 500,
          };

          when(() => mockBloc.state).thenReturn(
            DailyLessonsState(
              vocabularies: VocabulariesState.initial(),
              phrases: PhrasesState.initial(),
              analytics: UserAnalyticsState.loaded(analytics),
              dataManagement: UserDataManagementState.initial(),
              isRefreshing: false,
            ),
          );

          // Act
          await tester.pumpWidget(createWidgetUnderTest());

          // Assert
          expect(find.byIcon(Icons.analytics), findsOneWidget);
        },
      );

      testWidgets(
        'should trigger analytics fetch when analytics button is tapped',
        (WidgetTester tester) async {
          // Arrange
          when(() => mockBloc.state).thenReturn(
            const DailyLessonsState(
              vocabularies: VocabulariesState.initial(),
              phrases: PhrasesState.initial(),
              analytics: UserAnalyticsState.initial(),
              dataManagement: UserDataManagementState.initial(),
              isRefreshing: false,
            ),
          );

          // Act
          await tester.pumpWidget(createWidgetUnderTest());
          await tester.tap(find.byIcon(Icons.analytics));
          await tester.pump();

          // Assert
          verify(
            () => mockBloc.add(const DailyLessonsEvent.getUserAnalytics()),
          ).called(1);
        },
      );
    });

    group('Data Management', () {
      testWidgets('should display clear data button', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(() => mockBloc.state).thenReturn(
          const DailyLessonsState(
            vocabularies: VocabulariesState.initial(),
            phrases: PhrasesState.initial(),
            analytics: UserAnalyticsState.initial(),
            dataManagement: UserDataManagementState.initial(),
            isRefreshing: false,
          ),
        );

        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert
        expect(find.byIcon(Icons.delete_forever), findsOneWidget);
      });

      testWidgets('should trigger clear data when clear button is tapped', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(() => mockBloc.state).thenReturn(
          const DailyLessonsState(
            vocabularies: VocabulariesState.initial(),
            phrases: PhrasesState.initial(),
            analytics: UserAnalyticsState.initial(),
            dataManagement: UserDataManagementState.initial(),
            isRefreshing: false,
          ),
        );

        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.tap(find.byIcon(Icons.delete_forever));
        await tester.pump();

        // Assert
        verify(
          () => mockBloc.add(const DailyLessonsEvent.clearUserData()),
        ).called(1);
      });

      testWidgets('should show loading indicator when clearing data', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(() => mockBloc.state).thenReturn(
          const DailyLessonsState(
            vocabularies: VocabulariesState.initial(),
            phrases: PhrasesState.initial(),
            analytics: UserAnalyticsState.initial(),
            dataManagement: UserDataManagementState.loading(),
            isRefreshing: false,
          ),
        );

        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets(
        'should show success message when data is cleared successfully',
        (WidgetTester tester) async {
          // Arrange
          when(() => mockBloc.state).thenReturn(
            const DailyLessonsState(
              vocabularies: VocabulariesState.initial(),
              phrases: PhrasesState.initial(),
              analytics: UserAnalyticsState.initial(),
              dataManagement: UserDataManagementState.success(),
              isRefreshing: false,
            ),
          );

          // Act
          await tester.pumpWidget(createWidgetUnderTest());

          // Assert
          expect(find.text('Data cleared successfully'), findsOneWidget);
        },
      );

      testWidgets('should show error message when clearing data fails', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(() => mockBloc.state).thenReturn(
          const DailyLessonsState(
            vocabularies: VocabulariesState.initial(),
            phrases: PhrasesState.initial(),
            analytics: UserAnalyticsState.initial(),
            dataManagement: UserDataManagementState.error(
              'Failed to clear data',
            ),
            isRefreshing: false,
          ),
        );

        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert
        expect(find.text('Failed to clear data'), findsOneWidget);
      });
    });

    group('Accessibility', () {
      testWidgets('should have proper semantic labels for vocabulary cards', (
        WidgetTester tester,
      ) async {
        // Arrange
        final vocabularies = [
          const Vocabulary(english: 'Test Word', persian: 'کلمه تست'),
        ];

        when(() => mockBloc.state).thenReturn(
          DailyLessonsState(
            vocabularies: VocabulariesState.completed(vocabularies),
            phrases: PhrasesState.initial(),
            analytics: UserAnalyticsState.initial(),
            dataManagement: UserDataManagementState.initial(),
            isRefreshing: false,
          ),
        );

        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert
        expect(
          find.bySemanticsLabel('Vocabulary card: Test Word'),
          findsOneWidget,
        );
      });

      testWidgets('should have proper semantic labels for phrase cards', (
        WidgetTester tester,
      ) async {
        // Arrange
        final phrases = [
          const Phrase(english: 'Test Phrase', persian: 'عبارت تست'),
        ];

        when(() => mockBloc.state).thenReturn(
          DailyLessonsState(
            vocabularies: VocabulariesState.initial(),
            phrases: PhrasesState.completed(phrases),
            analytics: UserAnalyticsState.initial(),
            dataManagement: UserDataManagementState.initial(),
            isRefreshing: false,
          ),
        );

        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert
        expect(
          find.bySemanticsLabel('Phrase card: Test Phrase'),
          findsOneWidget,
        );
      });
    });
  });
}
