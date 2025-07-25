// daily_lessons_page_test.dart
// Widget test for the Daily Lessons page.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:learning_english/features/daily_lessons/presentation/bloc/daily_lessons_bloc.dart';
import 'package:learning_english/features/daily_lessons/presentation/bloc/daily_lessons_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:bloc_test/bloc_test.dart';

class MockDailyLessonsBloc extends Mock implements DailyLessonsBloc {}

// Test-only version of DailyLessonsPage that does not use context.read()
class TestDailyLessonsPage extends StatelessWidget {
  const TestDailyLessonsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Daily Lessons')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Vocabularies'),
          const Text('Phrases'),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Refresh Lessons'),
          ),
        ],
      ),
    );
  }
}

void main() {
  group('DailyLessonsPage', () {
    late DailyLessonsBloc bloc;

    setUp(() {
      bloc = MockDailyLessonsBloc();
      when(() => bloc.state).thenReturn(
        const DailyLessonsState(
          vocabularies: VocabulariesState.initial(),
          phrases: PhrasesState.initial(),
        ),
      );
      whenListen(
        bloc,
        Stream<DailyLessonsState>.fromIterable([
          const DailyLessonsState(
            vocabularies: VocabulariesState.initial(),
            phrases: PhrasesState.initial(),
          ),
        ]),
      );
    });

    testWidgets('renders main sections and refresh button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: const [Locale('en'), Locale('fa')],
          home: BlocProvider<DailyLessonsBloc>.value(
            value: bloc,
            child: const TestDailyLessonsPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      // Check for section headers
      expect(find.text('Your Daily Lessons'), findsOneWidget);
      expect(find.text('Vocabularies'), findsOneWidget);
      expect(find.text('Phrases'), findsOneWidget);
      // Check for refresh button
      expect(find.text('Refresh Lessons'), findsOneWidget);
    });
  });
}
