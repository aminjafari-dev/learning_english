import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learning_english/features/learning_focus_selection/presentation/widgets/learning_focus_option_card.dart';

void main() {
  testWidgets('LearningFocusOptionCard renders and responds to tap', (
    tester,
  ) async {
    bool tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LearningFocusOptionCard(
            icon: Icons.work,
            title: 'Business English',
            subtitle: 'English',
            selected: true,
            onTap: () => tapped = true,
          ),
        ),
      ),
    );
    expect(find.text('Business English'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);
    expect(find.byIcon(Icons.work), findsOneWidget);
    // Tap the card
    await tester.tap(find.byType(LearningFocusOptionCard));
    expect(tapped, isTrue);
  });
}
