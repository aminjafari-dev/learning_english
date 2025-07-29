import 'vocabulary_history_model.dart';
import 'phrase_history_model.dart';

/// HistoryRequestModel represents a complete learning request in the data layer.
/// This model groups vocabulary and phrase items by their request ID and creation date,
/// providing a comprehensive view of what was generated in a single learning session.
///
/// Usage Example:
///   final model = HistoryRequestModel(
///     requestId: 'req_123',
///     createdAt: DateTime.now(),
///     vocabularies: [vocabModel1, vocabModel2],
///     phrases: [phraseModel1, phraseModel2],
///   );
///
/// This model follows the data layer pattern and includes all necessary
/// fields for local storage and data transfer.
class HistoryRequestModel {
  /// The unique identifier for this learning request
  final String requestId;

  /// When this request was created
  final DateTime createdAt;

  /// List of vocabulary items generated for this request
  final List<VocabularyHistoryModel> vocabularies;

  /// List of phrase items generated for this request
  final List<PhraseHistoryModel> phrases;

  /// Constructor for HistoryRequestModel
  /// All fields are required to maintain complete request information
  const HistoryRequestModel({
    required this.requestId,
    required this.createdAt,
    required this.vocabularies,
    required this.phrases,
  });

  /// Creates a HistoryRequestModel from a domain entity
  /// Used when converting from domain layer to data layer
  factory HistoryRequestModel.fromEntity(
    dynamic entity, // Using dynamic to avoid circular dependency
  ) {
    return HistoryRequestModel(
      requestId: entity.requestId,
      createdAt: entity.createdAt,
      vocabularies:
          (entity.vocabularies as List)
              .map((v) => VocabularyHistoryModel.fromEntity(v))
              .toList(),
      phrases:
          (entity.phrases as List)
              .map((p) => PhraseHistoryModel.fromEntity(p))
              .toList(),
    );
  }

  /// Converts HistoryRequestModel to domain entity
  /// Used when converting from data layer to domain layer
  Map<String, dynamic> toEntity() {
    return {
      'requestId': requestId,
      'createdAt': createdAt,
      'vocabularies': vocabularies.map((v) => v.toEntity()).toList(),
      'phrases': phrases.map((p) => p.toEntity()).toList(),
    };
  }

  /// Creates a copy of HistoryRequestModel with updated fields
  /// Useful for updating specific properties while keeping others unchanged
  HistoryRequestModel copyWith({
    String? requestId,
    DateTime? createdAt,
    List<VocabularyHistoryModel>? vocabularies,
    List<PhraseHistoryModel>? phrases,
  }) {
    return HistoryRequestModel(
      requestId: requestId ?? this.requestId,
      createdAt: createdAt ?? this.createdAt,
      vocabularies: vocabularies ?? this.vocabularies,
      phrases: phrases ?? this.phrases,
    );
  }

  /// Gets the total number of items in this request
  /// Useful for displaying summary information
  int get totalItems => vocabularies.length + phrases.length;

  /// Gets the number of vocabulary items in this request
  int get vocabularyCount => vocabularies.length;

  /// Gets the number of phrase items in this request
  int get phraseCount => phrases.length;

  /// Checks if this request has any vocabulary items
  bool get hasVocabularies => vocabularies.isNotEmpty;

  /// Checks if this request has any phrase items
  bool get hasPhrases => phrases.isNotEmpty;

  /// Converts the model to a JSON map
  /// Used for serialization and data transfer
  Map<String, dynamic> toJson() {
    return {
      'requestId': requestId,
      'createdAt': createdAt.toIso8601String(),
      'vocabularies': vocabularies.map((v) => v.toJson()).toList(),
      'phrases': phrases.map((p) => p.toJson()).toList(),
    };
  }

  /// Creates a HistoryRequestModel from a JSON map
  /// Used for deserialization and data transfer
  factory HistoryRequestModel.fromJson(Map<String, dynamic> json) {
    return HistoryRequestModel(
      requestId: json['requestId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      vocabularies:
          (json['vocabularies'] as List)
              .map(
                (v) =>
                    VocabularyHistoryModel.fromJson(v as Map<String, dynamic>),
              )
              .toList(),
      phrases:
          (json['phrases'] as List)
              .map(
                (p) => PhraseHistoryModel.fromJson(p as Map<String, dynamic>),
              )
              .toList(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HistoryRequestModel &&
        other.requestId == requestId &&
        other.createdAt == createdAt &&
        other.vocabularies == vocabularies &&
        other.phrases == phrases;
  }

  @override
  int get hashCode {
    return requestId.hashCode ^
        createdAt.hashCode ^
        vocabularies.hashCode ^
        phrases.hashCode;
  }

  @override
  String toString() {
    return 'HistoryRequestModel(requestId: $requestId, createdAt: $createdAt, vocabularies: ${vocabularies.length}, phrases: ${phrases.length})';
  }
}
