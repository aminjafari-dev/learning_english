// phrase_model.dart
// Enhanced data model for phrase items with user tracking and AI metadata.
// This model supports saving phrase data per user and per AI provider.

import 'package:hive/hive.dart';
import '../../domain/entities/phrase.dart';
import '../datasources/ai_provider_type.dart';

part 'phrase_model.g.dart';

/// Enhanced phrase model with user tracking and AI metadata
/// Hive type adapter for PhraseModel - allows storage in Hive boxes
@HiveType(typeId: 1)
class PhraseModel {
  @HiveField(0)
  final String english;

  @HiveField(1)
  final String persian;

  @HiveField(2)
  final String userId;

  @HiveField(3)
  final AiProviderType aiProvider;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  final int tokensUsed;

  @HiveField(6)
  final String requestId;

  @HiveField(7)
  final bool isUsed;

  PhraseModel({
    required this.english,
    required this.persian,
    required this.userId,
    required this.aiProvider,
    required this.createdAt,
    required this.tokensUsed,
    required this.requestId,
    this.isUsed = false,
  });

  /// Creates a PhraseModel from JSON
  /// Used for database storage and retrieval
  factory PhraseModel.fromJson(Map<String, dynamic> json) => PhraseModel(
    english: json['english'] as String,
    persian: json['persian'] as String,
    userId: json['userId'] as String,
    aiProvider: AiProviderType.values.firstWhere(
      (e) => e.toString() == json['aiProvider'],
    ),
    createdAt: DateTime.parse(json['createdAt'] as String),
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
    'createdAt': createdAt.toIso8601String(),
    'tokensUsed': tokensUsed,
    'requestId': requestId,
    'isUsed': isUsed,
  };

  /// Creates a new instance with updated usage status
  /// Used when marking phrase as used by the user
  PhraseModel copyWith({bool? isUsed}) => PhraseModel(
    english: english,
    persian: persian,
    userId: userId,
    aiProvider: aiProvider,
    createdAt: createdAt,
    tokensUsed: tokensUsed,
    requestId: requestId,
    isUsed: isUsed ?? this.isUsed,
  );

  /// Maps the model to the domain entity
  /// Strips away metadata for domain layer consumption
  Phrase toEntity() => Phrase(english: english, persian: persian);

  /// Creates a model from domain entity with metadata
  /// Used when saving new AI-generated phrase
  factory PhraseModel.fromEntity(
    Phrase phrase,
    String userId,
    AiProviderType aiProvider,
    int tokensUsed,
    String requestId,
  ) => PhraseModel(
    english: phrase.english,
    persian: phrase.persian,
    userId: userId,
    aiProvider: aiProvider,
    createdAt: DateTime.now(),
    tokensUsed: tokensUsed,
    requestId: requestId,
  );
}

// Example usage:
// final model = PhraseModel.fromJson({
//   'english': 'I owe it to myself',
//   'persian': 'به اون امیدوارم',
//   'userId': 'user123',
//   'aiProvider': 'AiProviderType.openai',
//   'createdAt': '2024-01-15T10:30:00Z',
//   'tokensUsed': 35,
//   'requestId': 'req_abc123',
//   'isUsed': false
// });
// final entity = model.toEntity();
