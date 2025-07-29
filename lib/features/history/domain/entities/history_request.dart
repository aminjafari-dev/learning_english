import 'vocabulary_history_item.dart';
import 'phrase_history_item.dart';

/// HistoryRequest represents a complete learning request made by the user.
/// This entity groups vocabulary and phrase items by their request ID and creation date,
/// providing a comprehensive view of what was generated in a single learning session.
///
/// Usage Example:
///   final request = HistoryRequest(
///     requestId: 'req_123',
///     createdAt: DateTime.now(),
///     vocabularies: [vocab1, vocab2],
///     phrases: [phrase1, phrase2],
///   );
///
/// This entity is used to organize history data by request for better user experience.
class HistoryRequest {
  /// The unique identifier for this learning request
  final String requestId;

  /// When this request was created
  final DateTime createdAt;

  /// List of vocabulary items generated for this request
  final List<VocabularyHistoryItem> vocabularies;

  /// List of phrase items generated for this request
  final List<PhraseHistoryItem> phrases;

  /// Constructor for HistoryRequest
  /// All fields are required to maintain complete request information
  const HistoryRequest({
    required this.requestId,
    required this.createdAt,
    required this.vocabularies,
    required this.phrases,
  });

  /// Creates a copy of HistoryRequest with updated fields
  /// Useful for updating specific properties while keeping others unchanged
  HistoryRequest copyWith({
    String? requestId,
    DateTime? createdAt,
    List<VocabularyHistoryItem>? vocabularies,
    List<PhraseHistoryItem>? phrases,
  }) {
    return HistoryRequest(
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

  /// Converts the entity to a JSON map
  /// Used for serialization and data transfer
  Map<String, dynamic> toJson() {
    return {
      'requestId': requestId,
      'createdAt': createdAt.toIso8601String(),
      'vocabularies': vocabularies.map((v) => v.toJson()).toList(),
      'phrases': phrases.map((p) => p.toJson()).toList(),
    };
  }

  /// Creates a HistoryRequest from a JSON map
  /// Used for deserialization and data transfer
  factory HistoryRequest.fromJson(Map<String, dynamic> json) {
    return HistoryRequest(
      requestId: json['requestId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      vocabularies:
          (json['vocabularies'] as List)
              .map(
                (v) =>
                    VocabularyHistoryItem.fromJson(v as Map<String, dynamic>),
              )
              .toList(),
      phrases:
          (json['phrases'] as List)
              .map((p) => PhraseHistoryItem.fromJson(p as Map<String, dynamic>))
              .toList(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HistoryRequest &&
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
    return 'HistoryRequest(requestId: $requestId, createdAt: $createdAt, vocabularies: ${vocabularies.length}, phrases: ${phrases.length})';
  }
}
