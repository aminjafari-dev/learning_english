/// PhraseHistoryItem represents a single phrase item in the user's learning history.
/// This entity contains the essential information about a phrase item that was generated
/// for the user, including its translations and usage status.
/// Simplified to avoid data duplication with parent request metadata.
///
/// Usage Example:
///   final phrase = PhraseHistoryItem(
///     english: 'I owe it to myself',
///     persian: 'من مدیون خودم هستم',
///     isUsed: true,
///   );
///
/// This entity is used throughout the domain layer to represent phrase history data.
class PhraseHistoryItem {
  /// The English text of the phrase
  final String english;

  /// The Persian translation of the phrase
  final String persian;

  /// Whether this phrase has been used by the user
  final bool isUsed;

  /// Constructor for PhraseHistoryItem
  /// All fields are required to maintain complete history information
  const PhraseHistoryItem({
    required this.english,
    required this.persian,
    required this.isUsed,
  });

  /// Creates a copy of PhraseHistoryItem with updated fields
  /// Useful for updating specific properties while keeping others unchanged
  PhraseHistoryItem copyWith({String? english, String? persian, bool? isUsed}) {
    return PhraseHistoryItem(
      english: english ?? this.english,
      persian: persian ?? this.persian,
      isUsed: isUsed ?? this.isUsed,
    );
  }

  /// Converts the entity to a JSON map
  /// Used for serialization and data transfer
  Map<String, dynamic> toJson() {
    return {'english': english, 'persian': persian, 'isUsed': isUsed};
  }

  /// Creates a PhraseHistoryItem from a JSON map
  /// Used for deserialization and data transfer
  factory PhraseHistoryItem.fromJson(Map<String, dynamic> json) {
    return PhraseHistoryItem(
      english: json['english'] as String,
      persian: json['persian'] as String,
      isUsed: json['isUsed'] as bool,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PhraseHistoryItem &&
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
    return 'PhraseHistoryItem(english: $english, persian: $persian, isUsed: $isUsed)';
  }
}
