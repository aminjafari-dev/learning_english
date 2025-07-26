// vocabulary_model.dart
// Enhanced data model for vocabulary items with user tracking and AI metadata.
// This model supports saving vocabulary data per user and per AI provider.

import '../../domain/entities/vocabulary.dart';
import '../datasources/ai_provider_type.dart';

/// Enhanced vocabulary model with user tracking and AI metadata
class VocabularyModel {
  final String english;
  final String persian;
  final String userId;
  final AiProviderType aiProvider;
  final DateTime generatedAt;
  final int tokensUsed;
  final String requestId;
  final bool isUsed;

  VocabularyModel({
    required this.english,
    required this.persian,
    required this.userId,
    required this.aiProvider,
    required this.generatedAt,
    required this.tokensUsed,
    required this.requestId,
    this.isUsed = false,
  });

  /// Creates a VocabularyModel from JSON
  /// Used for database storage and retrieval
  factory VocabularyModel.fromJson(Map<String, dynamic> json) =>
      VocabularyModel(
        english: json['english'] as String,
        persian: json['persian'] as String,
        userId: json['userId'] as String,
        aiProvider: AiProviderType.values.firstWhere(
          (e) => e.toString() == json['aiProvider'],
        ),
        generatedAt: DateTime.parse(json['generatedAt'] as String),
        tokensUsed: json['tokensUsed'] as int,
        requestId: json['requestId'] as String,
        isUsed: json['isUsed'] as bool? ?? false,
      );

  /// Converts the model to JSON
  /// Used for database storage
  Map<String, dynamic> toJson() => {
    'english': english,
    'persian': persian,
    'userId': userId,
    'aiProvider': aiProvider.toString(),
    'generatedAt': generatedAt.toIso8601String(),
    'tokensUsed': tokensUsed,
    'requestId': requestId,
    'isUsed': isUsed,
  };

  /// Creates a new instance with updated usage status
  /// Used when marking vocabulary as used by the user
  VocabularyModel copyWith({bool? isUsed}) => VocabularyModel(
    english: english,
    persian: persian,
    userId: userId,
    aiProvider: aiProvider,
    generatedAt: generatedAt,
    tokensUsed: tokensUsed,
    requestId: requestId,
    isUsed: isUsed ?? this.isUsed,
  );

  /// Maps the model to the domain entity
  /// Strips away metadata for domain layer consumption
  Vocabulary toEntity() => Vocabulary(english: english, persian: persian);

  /// Creates a model from domain entity with metadata
  /// Used when saving new AI-generated vocabulary
  factory VocabularyModel.fromEntity(
    Vocabulary vocabulary,
    String userId,
    AiProviderType aiProvider,
    int tokensUsed,
    String requestId,
  ) => VocabularyModel(
    english: vocabulary.english,
    persian: vocabulary.persian,
    userId: userId,
    aiProvider: aiProvider,
    generatedAt: DateTime.now(),
    tokensUsed: tokensUsed,
    requestId: requestId,
  );
}

// Example usage:
// final model = VocabularyModel.fromJson({
//   'english': 'Perseverance',
//   'persian': 'پشتکار',
//   'userId': 'user123',
//   'aiProvider': 'AiProviderType.openai',
//   'generatedAt': '2024-01-15T10:30:00Z',
//   'tokensUsed': 45,
//   'requestId': 'req_abc123',
//   'isUsed': false
// });
// final entity = model.toEntity();
