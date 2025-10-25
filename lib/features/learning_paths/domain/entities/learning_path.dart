// learning_path.dart
// Domain entity representing a user's learning path
// Contains the main learning journey with sub-category and course progression

import 'package:equatable/equatable.dart';
import 'sub_category.dart';
import 'course.dart';
import '../../../level_selection/domain/entities/user_profile.dart';

/// Main learning path entity that represents a user's structured learning journey
class LearningPath extends Equatable {
  final String id;
  final String title;
  final String description;
  final Level level;
  final List<String> focusAreas;
  final SubCategory subCategory;
  final List<Course> courses;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const LearningPath({
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

  /// Creates a new learning path with 20 locked courses
  factory LearningPath.create({
    required String id,
    required Level level,
    required List<String> focusAreas,
    required SubCategory subCategory,
  }) {
    final courses = List.generate(20, (index) {
      return Course(
        id: '${id}_course_${index + 1}',
        courseNumber: index + 1,
        title: 'Course ${index + 1}',
        description: '${subCategory.title} - Course ${index + 1}',
        isUnlocked: index == 0, // Only first course is unlocked
        isCompleted: false,
        completionDate: null,
      );
    });

    return LearningPath(
      id: id,
      title: subCategory.title,
      description: subCategory.description,
      level: level,
      focusAreas: focusAreas,
      subCategory: subCategory,
      courses: courses,
      createdAt: DateTime.now(),
    );
  }

  /// Gets the current progress (number of completed courses)
  int get completedCourses =>
      courses.where((course) => course.isCompleted).length;

  /// Gets the total number of courses
  int get totalCourses => courses.length;

  /// Gets the progress percentage
  double get progressPercentage => (completedCourses / totalCourses) * 100;

  /// Gets the next unlocked course number
  int? get nextUnlockedCourse {
    final unlockedCourses = courses.where(
      (course) => course.isUnlocked && !course.isCompleted,
    );
    if (unlockedCourses.isEmpty) return null;
    return unlockedCourses.first.courseNumber;
  }

  /// Gets the next course to unlock
  int? get nextCourseToUnlock {
    final completedCourses = courses.where((course) => course.isCompleted);
    if (completedCourses.length >= totalCourses) return null;
    return completedCourses.length + 1;
  }

  /// Checks if the learning path is completed
  bool get isCompleted => completedCourses == totalCourses;

  /// Creates a copy with updated fields
  LearningPath copyWith({
    String? id,
    String? title,
    String? description,
    Level? level,
    List<String>? focusAreas,
    SubCategory? subCategory,
    List<Course>? courses,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LearningPath(
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

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    level,
    focusAreas,
    subCategory,
    courses,
    createdAt,
    updatedAt,
  ];
}
