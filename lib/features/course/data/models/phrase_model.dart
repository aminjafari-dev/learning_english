// phrase_model.dart
// Simplified data model for phrase items with minimal fields.
// This model represents phrase data with only essential information.

import 'package:hive/hive.dart';
import '../../domain/entities/phrase.dart';

part 'phrase_model.g.dart';

/// Simplified phrase model with minimal fields
/// Hive type adapter for PhraseModel - contains only essential phrase data
@HiveType(typeId: 1)
class PhraseModel {
  @HiveField(0)
  final String english;

  @HiveField(1)
  final String persian;

  @HiveField(2)
  final bool isUsed;

  PhraseModel({
    required this.english,
    required this.persian,
    required this.isUsed,
  });

  /// Creates a PhraseModel from JSON
  /// Used for database storage and retrieval
  factory PhraseModel.fromJson(Map<String, dynamic> json) => PhraseModel(
    english: json['english'] as String,
    persian: json['persian'] as String,
    isUsed: json['isUsed'] as bool? ?? false,
  );

  /// Converts the model to JSON
  /// Used for database storage
  Map<String, dynamic> toJson() => {
    'english': english,
    'persian': persian,
    'isUsed': isUsed,
  };

  /// Creates a new instance with updated usage status
  /// Used when marking phrase as used by the user
  PhraseModel copyWith({bool? isUsed}) => PhraseModel(
    english: english,
    persian: persian,
    isUsed: isUsed ?? this.isUsed,
  );

  /// Maps the model to the domain entity
  /// Strips away metadata for domain layer consumption
  Phrase toEntity() => Phrase(english: english, persian: persian);

  /// Creates a model from domain entity
  /// Used when saving new AI-generated phrase
  factory PhraseModel.fromEntity(Phrase phrase) => PhraseModel(
    english: phrase.english,
    persian: phrase.persian,
    isUsed: false, // Initially not used
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PhraseModel &&
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
    return 'PhraseModel(english: $english, persian: $persian, isUsed: $isUsed)';
  }
}

// Example usage:
// final model = PhraseModel.fromEntity(phrase);
// final entity = model.toEntity();
// final updatedModel = model.copyWith(isUsed: true);
