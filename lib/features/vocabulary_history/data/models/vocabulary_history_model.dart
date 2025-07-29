/// VocabularyHistoryModel represents a vocabulary history item in the data layer.
/// This model is used for data persistence and mapping between domain entities
/// and local storage (Hive).
///
/// Usage Example:
///   final model = VocabularyHistoryModel(
///     english: 'hello',
///     persian: 'سلام',
///     requestId: 'req_123',
///     createdAt: DateTime.now(),
///     isUsed: true,
///   );
///
/// This model follows the data layer pattern and includes all necessary
/// fields for local storage and data transfer.
class VocabularyHistoryModel {
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

  /// Constructor for VocabularyHistoryModel
  /// All fields are required to maintain complete history information
  const VocabularyHistoryModel({
    required this.english,
    required this.persian,
    required this.requestId,
    required this.createdAt,
    required this.isUsed,
  });

  /// Creates a VocabularyHistoryModel from a domain entity
  /// Used when converting from domain layer to data layer
  factory VocabularyHistoryModel.fromEntity(
    dynamic entity, // Using dynamic to avoid circular dependency
  ) {
    return VocabularyHistoryModel(
      english: entity.english,
      persian: entity.persian,
      requestId: entity.requestId,
      createdAt: entity.createdAt,
      isUsed: entity.isUsed,
    );
  }

  /// Converts VocabularyHistoryModel to domain entity
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

  /// Creates a copy of VocabularyHistoryModel with updated fields
  /// Useful for updating specific properties while keeping others unchanged
  VocabularyHistoryModel copyWith({
    String? english,
    String? persian,
    String? requestId,
    DateTime? createdAt,
    bool? isUsed,
  }) {
    return VocabularyHistoryModel(
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

  /// Creates a VocabularyHistoryModel from a JSON map
  /// Used for deserialization and data transfer
  factory VocabularyHistoryModel.fromJson(Map<String, dynamic> json) {
    return VocabularyHistoryModel(
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
    return other is VocabularyHistoryModel &&
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
    return 'VocabularyHistoryModel(english: $english, persian: $persian, requestId: $requestId, createdAt: $createdAt, isUsed: $isUsed)';
  }
}
