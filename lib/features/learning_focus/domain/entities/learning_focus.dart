// learning_focus.dart
// Entity representing a learning focus option for English learning.
//
// Usage Example:
//   final focus = LearningFocus(
//     id: 'business',
//     title: 'Business English',
//     icon: Icons.business_center,
//   );
//
// This entity defines the core structure for learning focus options.

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Enum representing different learning focus categories
enum LearningFocusType {
  business,
  travel,
  social,
  home,
  academic,
  movie,
  music,
  tv,
  shopping,
  restaurant,
  health,
  everyday,
}

/// Entity representing a learning focus option
class LearningFocus extends Equatable {
  final String id;
  final String title;
  final LearningFocusType type;
  final IconData icon;
  final bool isSelected;

  const LearningFocus({
    required this.id,
    required this.title,
    required this.type,
    required this.icon,
    this.isSelected = false,
  });

  /// Creates a copy of this learning focus with updated properties
  LearningFocus copyWith({
    String? id,
    String? title,
    LearningFocusType? type,
    IconData? icon,
    bool? isSelected,
  }) {
    return LearningFocus(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      icon: icon ?? this.icon,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  @override
  List<Object?> get props => [id, title, type, icon, isSelected];
}
