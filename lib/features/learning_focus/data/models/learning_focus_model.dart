// learning_focus_model.dart
// Data model for learning focus that extends the domain entity.
//
// Usage Example:
//   final model = LearningFocusModel.fromJson(json);
//   final entity = model.toEntity();
//
// This model handles JSON serialization/deserialization for learning focus data.

import 'package:flutter/material.dart';
import '../../domain/entities/learning_focus.dart';

class LearningFocusModel extends LearningFocus {
  const LearningFocusModel({
    required super.id,
    required super.title,
    required super.type,
    required super.icon,
    super.isSelected,
  });

  /// Creates a LearningFocusModel from JSON
  factory LearningFocusModel.fromJson(Map<String, dynamic> json) {
    return LearningFocusModel(
      id: json['id'] as String,
      title: json['title'] as String,
      type: LearningFocusType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
      ),
      icon: _getIconFromString(json['icon'] as String),
      isSelected: json['isSelected'] as bool? ?? false,
    );
  }

  /// Converts this model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type.toString().split('.').last,
      'icon': _getStringFromIcon(icon),
      'isSelected': isSelected,
    };
  }

  /// Converts this model to domain entity
  LearningFocus toEntity() {
    return LearningFocus(
      id: id,
      title: title,
      type: type,
      icon: icon,
      isSelected: isSelected,
    );
  }

  /// Creates a model from domain entity
  factory LearningFocusModel.fromEntity(LearningFocus entity) {
    return LearningFocusModel(
      id: entity.id,
      title: entity.title,
      type: entity.type,
      icon: entity.icon,
      isSelected: entity.isSelected,
    );
  }

  /// Helper method to get IconData from string
  static IconData _getIconFromString(String iconString) {
    switch (iconString) {
      case 'business_center':
        return Icons.business_center;
      case 'flight':
        return Icons.flight;
      case 'people':
        return Icons.people;
      case 'home':
        return Icons.home;
      case 'school':
        return Icons.school;
      case 'movie':
        return Icons.movie;
      case 'music_note':
        return Icons.music_note;
      case 'tv':
        return Icons.tv;
      case 'shopping_bag':
        return Icons.shopping_bag;
      case 'restaurant':
        return Icons.restaurant;
      case 'favorite':
        return Icons.favorite;
      case 'emoji_emotions':
        return Icons.emoji_emotions;
      default:
        return Icons.help;
    }
  }

  /// Helper method to get string from IconData
  static String _getStringFromIcon(IconData icon) {
    if (icon == Icons.business_center) return 'business_center';
    if (icon == Icons.flight) return 'flight';
    if (icon == Icons.people) return 'people';
    if (icon == Icons.home) return 'home';
    if (icon == Icons.school) return 'school';
    if (icon == Icons.movie) return 'movie';
    if (icon == Icons.music_note) return 'music_note';
    if (icon == Icons.tv) return 'tv';
    if (icon == Icons.shopping_bag) return 'shopping_bag';
    if (icon == Icons.restaurant) return 'restaurant';
    if (icon == Icons.favorite) return 'favorite';
    if (icon == Icons.emoji_emotions) return 'emoji_emotions';
    return 'help';
  }
}
