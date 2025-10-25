// course_model.dart
// Data model for Course with JSON serialization and Hive TypeAdapter
// Converts between domain entities and storage format

import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/course.dart';

part 'course_model.g.dart';

/// Hive type adapter ID for Course
@HiveType(typeId: 11)
@JsonSerializable()
class CourseModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final int courseNumber;

  @HiveField(2)
  final String title;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final bool isUnlocked;

  @HiveField(5)
  final bool isCompleted;

  @HiveField(6)
  final String? completionDate;

  CourseModel({
    required this.id,
    required this.courseNumber,
    required this.title,
    required this.description,
    required this.isUnlocked,
    required this.isCompleted,
    this.completionDate,
  });

  /// Creates CourseModel from domain entity
  factory CourseModel.fromEntity(Course entity) {
    return CourseModel(
      id: entity.id,
      courseNumber: entity.courseNumber,
      title: entity.title,
      description: entity.description,
      isUnlocked: entity.isUnlocked,
      isCompleted: entity.isCompleted,
      completionDate: entity.completionDate?.toIso8601String(),
    );
  }

  /// Converts to domain entity
  Course toEntity() {
    return Course(
      id: id,
      courseNumber: courseNumber,
      title: title,
      description: description,
      isUnlocked: isUnlocked,
      isCompleted: isCompleted,
      completionDate:
          completionDate != null ? DateTime.parse(completionDate!) : null,
    );
  }

  /// Creates from JSON
  factory CourseModel.fromJson(Map<String, dynamic> json) =>
      _$CourseModelFromJson(json);

  /// Converts to JSON
  Map<String, dynamic> toJson() => _$CourseModelToJson(this);

  /// Creates a copy with updated fields
  CourseModel copyWith({
    String? id,
    int? courseNumber,
    String? title,
    String? description,
    bool? isUnlocked,
    bool? isCompleted,
    String? completionDate,
  }) {
    return CourseModel(
      id: id ?? this.id,
      courseNumber: courseNumber ?? this.courseNumber,
      title: title ?? this.title,
      description: description ?? this.description,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      isCompleted: isCompleted ?? this.isCompleted,
      completionDate: completionDate ?? this.completionDate,
    );
  }
}
