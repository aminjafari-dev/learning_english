// vocabulary_model.dart
// Data model for vocabulary items with Hive persistence support.
// This model represents vocabulary data from AI providers and includes metadata for tracking.

import 'package:hive/hive.dart';
import '../../domain/entities/vocabulary.dart';
import '../datasources/ai_provider_type.dart';

part 'vocabulary_model.g.dart';

/// Hive type adapter for VocabularyModel
/// This allows VocabularyModel to be stored and retrieved from Hive boxes
@HiveType(typeId: 0)
class VocabularyModel {
  @HiveField(0)
  final String english;

  @HiveField(1)
  final String persian;

  @HiveField(2)
  final String userId;

  @HiveField(3)
  final AiProviderType aiProvider;

  @HiveField(4)
  final int tokensUsed;

  @HiveField(5)
  final String requestId;

  @HiveField(6)
  final DateTime createdAt;

  @HiveField(7)
  final bool isUsed;

  /// Constructor for VocabularyModel
  /// All fields are required for complete data tracking
  const VocabularyModel({
    required this.english,
    required this.persian,
    required this.userId,
    required this.aiProvider,
    required this.tokensUsed,
    required this.requestId,
    required this.createdAt,
    required this.isUsed,
  });

  /// Creates a VocabularyModel from a domain entity
  /// Used when converting from domain layer to data layer
  factory VocabularyModel.fromEntity(
    Vocabulary vocabulary,
    String userId,
    AiProviderType aiProvider,
    int tokensUsed,
    String requestId,
  ) {
    return VocabularyModel(
      english: vocabulary.english,
      persian: vocabulary.persian,
      userId: userId,
      aiProvider: aiProvider,
      tokensUsed: tokensUsed,
      requestId: requestId,
      createdAt: DateTime.now(),
      isUsed: false, // Initially not used
    );
  }

  /// Converts VocabularyModel to domain entity
  /// Used when converting from data layer to domain layer
  Vocabulary toEntity() {
    return Vocabulary(english: english, persian: persian);
  }

  /// Creates a copy of VocabularyModel with updated fields
  /// Used for updating usage status or other properties
  VocabularyModel copyWith({
    String? english,
    String? persian,
    String? userId,
    AiProviderType? aiProvider,
    int? tokensUsed,
    String? requestId,
    DateTime? createdAt,
    bool? isUsed,
  }) {
    return VocabularyModel(
      english: english ?? this.english,
      persian: persian ?? this.persian,
      userId: userId ?? this.userId,
      aiProvider: aiProvider ?? this.aiProvider,
      tokensUsed: tokensUsed ?? this.tokensUsed,
      requestId: requestId ?? this.requestId,
      createdAt: createdAt ?? this.createdAt,
      isUsed: isUsed ?? this.isUsed,
    );
  }

  /// Converts VocabularyModel to JSON for serialization
  /// Used for debugging and data export
  Map<String, dynamic> toJson() {
    return {
      'english': english,
      'persian': persian,
      'userId': userId,
      'aiProvider': aiProvider.toString(),
      'tokensUsed': tokensUsed,
      'requestId': requestId,
      'createdAt': createdAt.toIso8601String(),
      'isUsed': isUsed,
    };
  }

  /// Creates VocabularyModel from JSON
  /// Used for data import and debugging
  factory VocabularyModel.fromJson(Map<String, dynamic> json) {
    return VocabularyModel(
      english: json['english'] as String,
      persian: json['persian'] as String,
      userId: json['userId'] as String,
      aiProvider: AiProviderType.values.firstWhere(
        (e) => e.toString() == json['aiProvider'],
      ),
      tokensUsed: json['tokensUsed'] as int,
      requestId: json['requestId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isUsed: json['isUsed'] as bool,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VocabularyModel &&
        other.english == english &&
        other.persian == persian &&
        other.userId == userId &&
        other.aiProvider == aiProvider &&
        other.tokensUsed == tokensUsed &&
        other.requestId == requestId &&
        other.createdAt == createdAt &&
        other.isUsed == isUsed;
  }

  @override
  int get hashCode {
    return english.hashCode ^
        persian.hashCode ^
        userId.hashCode ^
        aiProvider.hashCode ^
        tokensUsed.hashCode ^
        requestId.hashCode ^
        createdAt.hashCode ^
        isUsed.hashCode;
  }

  @override
  String toString() {
    return 'VocabularyModel(english: $english, persian: $persian, userId: $userId, aiProvider: $aiProvider, tokensUsed: $tokensUsed, requestId: $requestId, createdAt: $createdAt, isUsed: $isUsed)';
  }
}

// Example usage:
// final vocabularyModel = VocabularyModel.fromEntity(
//   vocabulary,
//   'user123',
//   AiProviderType.openai,
//   150,
//   'req_1234567890',
// );
// final entity = vocabularyModel.toEntity();
// final updatedModel = vocabularyModel.copyWith(isUsed: true);
