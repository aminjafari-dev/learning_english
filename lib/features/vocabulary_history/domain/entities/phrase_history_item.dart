/// PhraseHistoryItem represents a single phrase item in the user's learning history.
/// This entity contains all the information about a phrase that was generated
/// for the user, including its translations, metadata, and usage status.
///
/// Usage Example:
///   final phrase = PhraseHistoryItem(
///     english: 'How are you?',
///     persian: 'حال شما چطور است؟',
///     requestId: 'req_123',
///     createdAt: DateTime.now(),
///     isUsed: true,
///   );
///
/// This entity is used throughout the domain layer to represent phrase history data.
class PhraseHistoryItem {
  /// The English text of the phrase
  final String english;

  /// The Persian translation of the phrase
  final String persian;

  /// The unique identifier for the request that generated this phrase
  final String requestId;

  /// When this phrase was created
  final DateTime createdAt;

  /// Whether this phrase has been used by the user
  final bool isUsed;

  /// Constructor for PhraseHistoryItem
  /// All fields are required to maintain complete history information
  const PhraseHistoryItem({
    required this.english,
    required this.persian,
    required this.requestId,
    required this.createdAt,
    required this.isUsed,
  });

  /// Creates a copy of PhraseHistoryItem with updated fields
  /// Useful for updating specific properties while keeping others unchanged
  PhraseHistoryItem copyWith({
    String? english,
    String? persian,
    String? requestId,
    DateTime? createdAt,
    bool? isUsed,
  }) {
    return PhraseHistoryItem(
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

  /// Creates a PhraseHistoryItem from a JSON map
  /// Used for deserialization and data transfer
  factory PhraseHistoryItem.fromJson(Map<String, dynamic> json) {
    return PhraseHistoryItem(
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
    return other is PhraseHistoryItem &&
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
    return 'PhraseHistoryItem(english: $english, persian: $persian, requestId: $requestId, createdAt: $createdAt, isUsed: $isUsed)';
  }
}
