// learning_focus_local_data_source.dart
// Local data source for learning focus options.
//
// Usage Example:
//   final dataSource = LearningFocusLocalDataSource();
//   final options = await dataSource.getLearningFocusOptions();
//
// This data source provides predefined learning focus options.

import 'package:flutter/material.dart';
import '../../domain/entities/learning_focus.dart';
import '../models/learning_focus_model.dart';

abstract class LearningFocusLocalDataSource {
  Future<List<LearningFocusModel>> getLearningFocusOptions();
}

class LearningFocusLocalDataSourceImpl implements LearningFocusLocalDataSource {
  @override
  Future<List<LearningFocusModel>> getLearningFocusOptions() async {
    // Return predefined learning focus options
    return [
      const LearningFocusModel(
        id: 'business',
        title: 'Business\nEnglish',
        type: LearningFocusType.business,
        icon: Icons.business_center,
      ),
      const LearningFocusModel(
        id: 'travel',
        title: 'Travel\nEnglish',
        type: LearningFocusType.travel,
        icon: Icons.flight,
      ),
      const LearningFocusModel(
        id: 'social',
        title: 'Social\nEnglish',
        type: LearningFocusType.social,
        icon: Icons.people,
      ),
      const LearningFocusModel(
        id: 'home',
        title: 'Home\nEnglish',
        type: LearningFocusType.home,
        icon: Icons.home,
      ),
      const LearningFocusModel(
        id: 'academic',
        title: 'Academic\nEnglish',
        type: LearningFocusType.academic,
        icon: Icons.school,
      ),
      const LearningFocusModel(
        id: 'movie',
        title: 'Movie\nEnglish',
        type: LearningFocusType.movie,
        icon: Icons.movie,
      ),
      const LearningFocusModel(
        id: 'music',
        title: 'Music\nEnglish',
        type: LearningFocusType.music,
        icon: Icons.music_note,
      ),
      const LearningFocusModel(
        id: 'tv',
        title: 'TV English',
        type: LearningFocusType.tv,
        icon: Icons.tv,
      ),
      const LearningFocusModel(
        id: 'shopping',
        title: 'Shopping\nEnglish',
        type: LearningFocusType.shopping,
        icon: Icons.shopping_bag,
      ),
      const LearningFocusModel(
        id: 'restaurant',
        title: 'Restaurant\nEnglish',
        type: LearningFocusType.restaurant,
        icon: Icons.restaurant,
      ),
      const LearningFocusModel(
        id: 'health',
        title: 'Health\nEnglish',
        type: LearningFocusType.health,
        icon: Icons.favorite,
      ),
      const LearningFocusModel(
        id: 'everyday',
        title: 'Everyday\nEnglish',
        type: LearningFocusType.everyday,
        icon: Icons.emoji_emotions,
      ),
    ];
  }
}
