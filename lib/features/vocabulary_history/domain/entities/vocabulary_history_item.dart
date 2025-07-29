/// VocabularyHistoryItem represents a single vocabulary item in the user's learning history.
/// This entity contains all the information about a vocabulary item that was generated
/// for the user, including its translations, metadata, and usage status.
///
/// Usage Example:
///   final vocabulary = VocabularyHistoryItem(
///     english: 'hello',
///     persian: 'سلام',
///     requestId: 'req_123',
///     createdAt: DateTime.now(),
///     isUsed: true,
///   );
///
/// This entity is used throughout the domain layer to represent vocabulary history data.
class VocabularyHistoryItem {
  /// The English text of the vocabulary
  final String english;

  /// The Persian translation of the vocabulary
  final String persian;

  /// The unique identifier for the request that generated this vocabulary
  final String requestId;

  /// When this vocabulary was created
  final DateTime createdAt;

  /// Whether this vocabulary has been used by the user
  final bool isUsed;

  /// Constructor for VocabularyHistoryItem
  /// All fields are required to maintain complete history information
  const VocabularyHistoryItem({
    required this.english,
    required this.persian,
    required this.requestId,
    required this.createdAt,
    required this.isUsed,
  });

  /// Creates a copy of VocabularyHistoryItem with updated fields
  /// Useful for updating specific properties while keeping others unchanged
  VocabularyHistoryItem copyWith({
    String? english,
    String? persian,
    String? requestId,
    DateTime? createdAt,
    bool? isUsed,
  }) {
    return VocabularyHistoryItem(
      english: english ?? this.english,
      persian: persian ?? this.persian,
      requestId: requestId ?? this.requestId,
      createdAt: createdAt ?? this.createdAt,
      isUsed: isUsed ?? this.isUsed,
    );
  }

  /// Converts the entity to a JSON map
  /// Used for serialization and data transfer
  Map<String, dynamic> toJson() {
    return {
      'english': english,
      'persian': persian,
      'requestId': requestId,
      'createdAt': createdAt.toIso8601String(),
      'isUsed': isUsed,
    };
  }

  /// Creates a VocabularyHistoryItem from a JSON map
  /// Used for deserialization and data transfer
  factory VocabularyHistoryItem.fromJson(Map<String, dynamic> json) {
    return VocabularyHistoryItem(
      english: json['english'] as String,
      persian: json['persian'] as String,
      requestId: json['requestId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isUsed: json['isUsed'] as bool,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VocabularyHistoryItem &&
        other.english == english &&
        other.persian == persian &&
        other.requestId == requestId &&
        other.createdAt == createdAt &&
        other.isUsed == isUsed;
  }

  @override
  int get hashCode {
    return english.hashCode ^
        persian.hashCode ^
        requestId.hashCode ^
        createdAt.hashCode ^
        isUsed.hashCode;
  }

  @override
  String toString() {
    return 'VocabularyHistoryItem(english: $english, persian: $persian, requestId: $requestId, createdAt: $createdAt, isUsed: $isUsed)';
  }
}
