// course.dart
// Domain entity representing an individual course within a learning path
// Each learning path contains 20 courses that unlock progressively

import 'package:equatable/equatable.dart';

/// Individual course entity within a learning path
/// Represents one of 20 courses that unlock progressively
class Course extends Equatable {
  final String id;
  final int courseNumber;
  final String title;
  final String description;
  final bool isUnlocked;
  final bool isCompleted;
  final DateTime? completionDate;

  const Course({
    required this.id,
    required this.courseNumber,
    required this.title,
    required this.description,
    required this.isUnlocked,
    required this.isCompleted,
    this.completionDate,
  });

  /// Creates a copy with updated fields
  Course copyWith({
    String? id,
    int? courseNumber,
    String? title,
    String? description,
    bool? isUnlocked,
    bool? isCompleted,
    DateTime? completionDate,
  }) {
    return Course(
      id: id ?? this.id,
      courseNumber: courseNumber ?? this.courseNumber,
      title: title ?? this.title,
      description: description ?? this.description,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      isCompleted: isCompleted ?? this.isCompleted,
      completionDate: completionDate ?? this.completionDate,
    );
  }

  /// Marks the course as completed
  Course markAsCompleted() {
    return copyWith(isCompleted: true, completionDate: DateTime.now());
  }

  /// Unlocks the course
  Course unlock() {
    return copyWith(isUnlocked: true);
  }

  /// Gets the course status for display
  String get status {
    if (isCompleted) return 'Completed';
    if (isUnlocked) return 'Available';
    return 'Locked';
  }

  /// Checks if the course can be accessed
  /// Completed courses can be accessed for review purposes
  bool get canAccess => isUnlocked;

  @override
  List<Object?> get props => [
    id,
    courseNumber,
    title,
    description,
    isUnlocked,
    isCompleted,
    completionDate,
  ];
}
