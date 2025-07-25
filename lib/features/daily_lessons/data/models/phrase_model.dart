// phrase_model.dart
// Data model for phrase items used for API/local storage.

import '../../domain/entities/phrase.dart';

class PhraseModel {
  final String english;
  final String persian;

  PhraseModel({required this.english, required this.persian});

  /// Creates a PhraseModel from JSON
  factory PhraseModel.fromJson(Map<String, dynamic> json) => PhraseModel(
    english: json['english'] as String,
    persian: json['persian'] as String,
  );

  /// Converts the model to JSON
  Map<String, dynamic> toJson() => {'english': english, 'persian': persian};

  /// Maps the model to the domain entity
  Phrase toEntity() => Phrase(english: english, persian: persian);
}

// Example usage:
// final model = PhraseModel.fromJson({'english': 'I owe it to myself', 'persian': 'به اون امیدوارم'});
// final entity = model.toEntity();
