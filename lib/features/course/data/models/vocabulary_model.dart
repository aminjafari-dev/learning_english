// vocabulary_model.dart
// Simplified data model for vocabulary items with minimal fields.
// This model represents vocabulary data with only essential information.

import 'package:hive/hive.dart';
import '../../domain/entities/vocabulary.dart';

part 'vocabulary_model.g.dart';

/// Simplified Hive type adapter for VocabularyModel
/// Contains only essential vocabulary data without metadata duplication
@HiveType(typeId: 0)
class VocabularyModel {
  @HiveField(0)
  final String english;

  @HiveField(1)
  final String persian;

  @HiveField(2)
  final bool isUsed;

  /// Constructor for VocabularyModel
  /// Contains only essential vocabulary data
  const VocabularyModel({
    required this.english,
    required this.persian,
    required this.isUsed,
  });

  /// Creates a VocabularyModel from a domain entity
  /// Used when converting from domain layer to data layer
  factory VocabularyModel.fromEntity(Vocabulary vocabulary) {
    return VocabularyModel(
      english: vocabulary.english,
      persian: vocabulary.persian,
      isUsed: false, // Initially not used
    );
  }

  /// Converts VocabularyModel to domain entity
  /// Used when converting from data layer to domain layer
  Vocabulary toEntity() {
    return Vocabulary(english: english, persian: persian);
  }

  /// Creates a copy of VocabularyModel with updated fields
  /// Used for updating usage status
  VocabularyModel copyWith({String? english, String? persian, bool? isUsed}) {
    return VocabularyModel(
      english: english ?? this.english,
      persian: persian ?? this.persian,
      isUsed: isUsed ?? this.isUsed,
    );
  }

  /// Converts VocabularyModel to JSON for serialization
  /// Used for debugging and data export
  Map<String, dynamic> toJson() {
    return {'english': english, 'persian': persian, 'isUsed': isUsed};
  }

  /// Creates VocabularyModel from JSON
  /// Used for data import and debugging
  factory VocabularyModel.fromJson(Map<String, dynamic> json) {
    return VocabularyModel(
      english: json['english'] as String,
      persian: json['persian'] as String,
      isUsed: json['isUsed'] as bool? ?? false,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VocabularyModel &&
        other.english == english &&
        other.persian == persian &&
        other.isUsed == isUsed;
  }

  @override
  int get hashCode {
    return english.hashCode ^ persian.hashCode ^ isUsed.hashCode;
  }

  @override
  String toString() {
    return 'VocabularyModel(english: $english, persian: $persian, isUsed: $isUsed)';
  }
}

// Example usage:
// final vocabularyModel = VocabularyModel.fromEntity(vocabulary);
// final entity = vocabularyModel.toEntity();
// final updatedModel = vocabularyModel.copyWith(isUsed: true);
