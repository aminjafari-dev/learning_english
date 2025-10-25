// sub_category_model.dart
// Data model for SubCategory with JSON serialization
// Converts between domain entities and API response format

import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/sub_category.dart';
import '../../../level_selection/domain/entities/user_profile.dart';

part 'sub_category_model.g.dart';

/// Custom converter for Level enum to/from JSON
class LevelConverter implements JsonConverter<Level, String> {
  const LevelConverter();

  @override
  Level fromJson(String json) {
    return Level.values.firstWhere((level) => level.name == json);
  }

  @override
  String toJson(Level object) {
    return object.name;
  }
}

@HiveType(typeId: 4) // Unique typeId for SubCategoryModel
@JsonSerializable()
class SubCategoryModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final String difficulty;
  @HiveField(4)
  final int estimatedLessons;
  @HiveField(5)
  final List<String> keyTopics;

  const SubCategoryModel({
    required this.id,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.estimatedLessons,
    required this.keyTopics,
  });

  /// Creates SubCategoryModel from domain entity
  factory SubCategoryModel.fromEntity(SubCategory entity) {
    return SubCategoryModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      difficulty: entity.difficulty.name,
      estimatedLessons: entity.estimatedLessons,
      keyTopics: entity.keyTopics,
    );
  }

  /// Converts to domain entity
  SubCategory toEntity() {
    return SubCategory(
      id: id,
      title: title,
      description: description,
      difficulty: _parseDifficulty(difficulty),
      estimatedLessons: estimatedLessons,
      keyTopics: keyTopics,
    );
  }

  /// Parses difficulty string to Level enum
  /// Handles both enum names and display names
  Level _parseDifficulty(String difficultyString) {
    // First try to match by enum name (lowercase)
    final lowerDifficulty = difficultyString.toLowerCase();
    for (final level in Level.values) {
      if (level.name == lowerDifficulty) {
        return level;
      }
    }

    // If not found, try to match by display name
    switch (difficultyString.toLowerCase()) {
      case 'beginner':
        return Level.beginner;
      case 'elementary':
        return Level.elementary;
      case 'intermediate':
        return Level.intermediate;
      case 'advanced':
        return Level.advanced;
      default:
        // Default to intermediate if parsing fails
        return Level.intermediate;
    }
  }

  /// Creates from JSON
  factory SubCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$SubCategoryModelFromJson(json);

  /// Converts to JSON
  Map<String, dynamic> toJson() => _$SubCategoryModelToJson(this);

  /// Creates a copy with updated fields
  SubCategoryModel copyWith({
    String? id,
    String? title,
    String? description,
    String? difficulty,
    int? estimatedLessons,
    List<String>? keyTopics,
  }) {
    return SubCategoryModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      difficulty: difficulty ?? this.difficulty,
      estimatedLessons: estimatedLessons ?? this.estimatedLessons,
      keyTopics: keyTopics ?? this.keyTopics,
    );
  }
}

/// Response model for AI-generated sub-categories
@JsonSerializable()
class SubCategoriesResponse {
  final List<SubCategoryModel> subCategories;

  const SubCategoriesResponse({required this.subCategories});

  /// Creates from JSON
  factory SubCategoriesResponse.fromJson(Map<String, dynamic> json) =>
      _$SubCategoriesResponseFromJson(json);

  /// Converts to JSON
  Map<String, dynamic> toJson() => _$SubCategoriesResponseToJson(this);
}
