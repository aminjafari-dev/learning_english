// learning_focus_test.dart
// Basic test for the learning focus feature.
//
// Usage Example:
//   flutter test test/features/learning_focus/learning_focus_test.dart
//
// This test verifies the basic functionality of the learning focus feature.

import 'package:flutter_test/flutter_test.dart';
import 'package:learning_english/features/learning_focus/domain/entities/learning_focus.dart';
import 'package:learning_english/features/learning_focus/domain/entities/user_learning_focus.dart';
import 'package:flutter/material.dart';

void main() {
  group('Learning Focus Feature Tests', () {
    test('LearningFocus entity should be created correctly', () {
      // Arrange
      const focus = LearningFocus(
        id: 'business',
        title: 'Business\nEnglish',
        type: LearningFocusType.business,
        icon: Icons.business_center,
        isSelected: false,
      );

      // Assert
      expect(focus.id, 'business');
      expect(focus.title, 'Business\nEnglish');
      expect(focus.type, LearningFocusType.business);
      expect(focus.icon, Icons.business_center);
      expect(focus.isSelected, false);
    });

    test('LearningFocus copyWith should work correctly', () {
      // Arrange
      const originalFocus = LearningFocus(
        id: 'business',
        title: 'Business\nEnglish',
        type: LearningFocusType.business,
        icon: Icons.business_center,
        isSelected: false,
      );

      // Act
      final updatedFocus = originalFocus.copyWith(isSelected: true);

      // Assert
      expect(updatedFocus.id, 'business');
      expect(updatedFocus.title, 'Business\nEnglish');
      expect(updatedFocus.type, LearningFocusType.business);
      expect(updatedFocus.icon, Icons.business_center);
      expect(updatedFocus.isSelected, true);
    });

    test('UserLearningFocus entity should be created correctly', () {
      // Arrange
      final userFocus = UserLearningFocus(
        userId: 'user123',
        selectedFocuses: [LearningFocusType.business, LearningFocusType.travel],
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 2),
      );

      // Assert
      expect(userFocus.userId, 'user123');
      expect(userFocus.selectedFocuses.length, 2);
      expect(userFocus.selectedFocuses, contains(LearningFocusType.business));
      expect(userFocus.selectedFocuses, contains(LearningFocusType.travel));
      expect(userFocus.createdAt, DateTime(2024, 1, 1));
      expect(userFocus.updatedAt, DateTime(2024, 1, 2));
    });

    test('LearningFocusType enum should have all expected values', () {
      // Assert
      expect(LearningFocusType.values.length, 12);
      expect(LearningFocusType.values, contains(LearningFocusType.business));
      expect(LearningFocusType.values, contains(LearningFocusType.travel));
      expect(LearningFocusType.values, contains(LearningFocusType.social));
      expect(LearningFocusType.values, contains(LearningFocusType.home));
      expect(LearningFocusType.values, contains(LearningFocusType.academic));
      expect(LearningFocusType.values, contains(LearningFocusType.movie));
      expect(LearningFocusType.values, contains(LearningFocusType.music));
      expect(LearningFocusType.values, contains(LearningFocusType.tv));
      expect(LearningFocusType.values, contains(LearningFocusType.shopping));
      expect(LearningFocusType.values, contains(LearningFocusType.restaurant));
      expect(LearningFocusType.values, contains(LearningFocusType.health));
      expect(LearningFocusType.values, contains(LearningFocusType.everyday));
    });
  });
}
