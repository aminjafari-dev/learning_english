/// PhraseHistoryModel represents a phrase history item in the data layer.
/// This model is used for data persistence and mapping between domain entities
/// and local storage (Hive).
///
/// Usage Example:
///   final model = PhraseHistoryModel(
///     english: 'How are you?',
///     persian: 'حال شما چطور است؟',
///     requestId: 'req_123',
///     createdAt: DateTime.now(),
///     isUsed: true,
///   );
///
/// This model follows the data layer pattern and includes all necessary
/// fields for local storage and data transfer.
class PhraseHistoryModel {
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

  /// Constructor for PhraseHistoryModel
  /// All fields are required to maintain complete history information
  const PhraseHistoryModel({
    required this.english,
    required this.persian,
    required this.requestId,
    required this.createdAt,
    required this.isUsed,
  });

  /// Creates a PhraseHistoryModel from a domain entity
  /// Used when converting from domain layer to data layer
  factory PhraseHistoryModel.fromEntity(
    dynamic entity, // Using dynamic to avoid circular dependency
  ) {
    return PhraseHistoryModel(
      english: entity.english,
      persian: entity.persian,
      requestId: entity.requestId,
      createdAt: entity.createdAt,
      isUsed: entity.isUsed,
    );
  }

  /// Converts PhraseHistoryModel to domain entity
  /// Used when converting from data layer to domain layer
  Map<String, dynamic> toEntity() {
    return {
      'english': english,
      'persian': persian,
      'requestId': requestId,
      'createdAt': createdAt,
      'isUsed': isUsed,
    };
  }

  /// Creates a copy of PhraseHistoryModel with updated fields
  /// Useful for updating specific properties while keeping others unchanged
  PhraseHistoryModel copyWith({
    String? english,
    String? persian,
    String? requestId,
    DateTime? createdAt,
    bool? isUsed,
  }) {
    return PhraseHistoryModel(
      english: english ?? this.english,
      persian: persian ?? this.persian,
      requestId: requestId ?? this.requestId,
      createdAt: createdAt ?? this.createdAt,
      isUsed: isUsed ?? this.isUsed,
    );
  }

  /// Converts the model to a JSON map
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

  /// Creates a PhraseHistoryModel from a JSON map
  /// Used for deserialization and data transfer
  factory PhraseHistoryModel.fromJson(Map<String, dynamic> json) {
    return PhraseHistoryModel(
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
    return other is PhraseHistoryModel &&
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
    return 'PhraseHistoryModel(english: $english, persian: $persian, requestId: $requestId, createdAt: $createdAt, isUsed: $isUsed)';
  }
}
