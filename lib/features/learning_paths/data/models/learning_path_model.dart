// learning_path_model.dart
// Data model for LearningPath with JSON serialization and Hive TypeAdapter
// Converts between domain entities and storage format

import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/learning_path.dart';
import '../../../level_selection/domain/entities/user_profile.dart';
import 'sub_category_model.dart';
import 'course_model.dart';

part 'learning_path_model.g.dart';

/// Hive type adapter ID for LearningPath
@HiveType(typeId: 10)
@JsonSerializable()
class LearningPathModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String level;

  @HiveField(4)
  final List<String> focusAreas;

  @HiveField(5)
  final SubCategoryModel subCategory;

  @HiveField(6)
  final List<CourseModel> courses;

  @HiveField(7)
  final String createdAt;

  @HiveField(8)
  final String? updatedAt;

  LearningPathModel({
    required this.id,
    required this.title,
    required this.description,
    required this.level,
    required this.focusAreas,
    required this.subCategory,
    required this.courses,
    required this.createdAt,
    this.updatedAt,
  });

  /// Creates LearningPathModel from domain entity
  factory LearningPathModel.fromEntity(LearningPath entity) {
    return LearningPathModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      level: entity.level.name,
      focusAreas: entity.focusAreas,
      subCategory: SubCategoryModel.fromEntity(entity.subCategory),
      courses:
          entity.courses
              .map((course) => CourseModel.fromEntity(course))
              .toList(),
      createdAt: entity.createdAt.toIso8601String(),
      updatedAt: entity.updatedAt?.toIso8601String(),
    );
  }

  /// Converts to domain entity
  LearningPath toEntity() {
    return LearningPath(
      id: id,
      title: title,
      description: description,
      level: Level.values.firstWhere((l) => l.name == level),
      focusAreas: focusAreas,
      subCategory: subCategory.toEntity(),
      courses: courses.map((course) => course.toEntity()).toList(),
      createdAt: DateTime.parse(createdAt),
      updatedAt: updatedAt != null ? DateTime.parse(updatedAt!) : null,
    );
  }

  /// Creates from JSON
  factory LearningPathModel.fromJson(Map<String, dynamic> json) =>
      _$LearningPathModelFromJson(json);

  /// Converts to JSON
  Map<String, dynamic> toJson() => _$LearningPathModelToJson(this);

  /// Creates a copy with updated fields
  LearningPathModel copyWith({
    String? id,
    String? title,
    String? description,
    String? level,
    List<String>? focusAreas,
    SubCategoryModel? subCategory,
    List<CourseModel>? courses,
    String? createdAt,
    String? updatedAt,
  }) {
    return LearningPathModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      level: level ?? this.level,
      focusAreas: focusAreas ?? this.focusAreas,
      subCategory: subCategory ?? this.subCategory,
      courses: courses ?? this.courses,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
