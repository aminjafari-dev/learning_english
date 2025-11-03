// learning_request_model.dart
// Data model for learning requests with Hive persistence support.
// This model represents complete AI requests with all metadata and generated content.

import 'package:hive/hive.dart';
import 'package:learning_english/features/course/data/models/level_type.dart';
import '../../domain/entities/learning_request.dart';
import 'ai_provider_type.dart';
import 'vocabulary_model.dart';
import 'phrase_model.dart';

part 'learning_request_model.g.dart';

/// Hive type adapter for LearningRequestModel
/// Stores complete request data with embedded vocabulary and phrase models
@HiveType(typeId: 3)
class LearningRequestModel {
  @HiveField(0)
  final String requestId;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final UserLevel userLevel;

  @HiveField(3)
  final List<String> focusAreas;

  @HiveField(4)
  final AiProviderType aiProvider;

  @HiveField(5)
  final String aiModel;

  @HiveField(6)
  final int totalTokensUsed;

  @HiveField(7)
  final double estimatedCost;

  @HiveField(8)
  final DateTime requestTimestamp;

  @HiveField(9)
  final DateTime createdAt;

  @HiveField(10)
  final String systemPrompt;

  @HiveField(11)
  final String userPrompt;

  @HiveField(12)
  final String? errorMessage;

  @HiveField(13)
  final List<VocabularyModel> vocabularies;

  @HiveField(14)
  final List<PhraseModel> phrases;

  @HiveField(15)
  final Map<String, dynamic>? metadata;

  const LearningRequestModel({
    required this.requestId,
    required this.userId,
    required this.userLevel,
    required this.focusAreas,
    required this.aiProvider,
    required this.aiModel,
    required this.totalTokensUsed,
    required this.estimatedCost,
    required this.requestTimestamp,
    required this.createdAt,
    required this.systemPrompt,
    required this.userPrompt,
    this.errorMessage,
    required this.vocabularies,
    required this.phrases,
    this.metadata,
  });

  /// Creates a LearningRequestModel from a domain entity
  /// Converts domain entities to data models for storage
  factory LearningRequestModel.fromEntity(LearningRequest request) {
    return LearningRequestModel(
      requestId: request.requestId,
      userId: request.userId,
      userLevel: request.userLevel,
      focusAreas: request.focusAreas,
      aiProvider: request.aiProvider,
      aiModel: request.aiModel,
      totalTokensUsed: request.totalTokensUsed,
      estimatedCost: request.estimatedCost,
      requestTimestamp: request.requestTimestamp,
      createdAt: request.createdAt,
      systemPrompt: request.systemPrompt,
      userPrompt: request.userPrompt,
      errorMessage: request.errorMessage,
      vocabularies:
          request.vocabularies
              .map((vocab) => VocabularyModel.fromEntity(vocab))
              .toList(),
      phrases:
          request.phrases
              .map((phrase) => PhraseModel.fromEntity(phrase))
              .toList(),
      metadata: request.metadata,
    );
  }

  /// Converts LearningRequestModel to domain entity
  /// Converts data models back to domain entities
  LearningRequest toEntity() {
    return LearningRequest(
      requestId: requestId,
      userId: userId,
      userLevel: userLevel,
      focusAreas: focusAreas,
      aiProvider: aiProvider,
      aiModel: aiModel,
      totalTokensUsed: totalTokensUsed,
      estimatedCost: estimatedCost,
      requestTimestamp: requestTimestamp,
      createdAt: createdAt,
      systemPrompt: systemPrompt,
      userPrompt: userPrompt,
      errorMessage: errorMessage,
      vocabularies: vocabularies.map((vocab) => vocab.toEntity()).toList(),
      phrases: phrases.map((phrase) => phrase.toEntity()).toList(),
      metadata: metadata,
    );
  }

  /// Creates a copy of LearningRequestModel with updated fields
  /// Used for updating request data
  LearningRequestModel copyWith({
    String? requestId,
    String? userId,
    UserLevel? userLevel,
    List<String>? focusAreas,
    AiProviderType? aiProvider,
    String? aiModel,
    int? totalTokensUsed,
    double? estimatedCost,
    DateTime? requestTimestamp,
    DateTime? createdAt,
    String? systemPrompt,
    String? userPrompt,
    String? errorMessage,
    List<VocabularyModel>? vocabularies,
    List<PhraseModel>? phrases,
    Map<String, dynamic>? metadata,
  }) {
    return LearningRequestModel(
      requestId: requestId ?? this.requestId,
      userId: userId ?? this.userId,
      userLevel: userLevel ?? this.userLevel,
      focusAreas: focusAreas ?? this.focusAreas,
      aiProvider: aiProvider ?? this.aiProvider,
      aiModel: aiModel ?? this.aiModel,
      totalTokensUsed: totalTokensUsed ?? this.totalTokensUsed,
      estimatedCost: estimatedCost ?? this.estimatedCost,
      requestTimestamp: requestTimestamp ?? this.requestTimestamp,
      createdAt: createdAt ?? this.createdAt,
      systemPrompt: systemPrompt ?? this.systemPrompt,
      userPrompt: userPrompt ?? this.userPrompt,
      errorMessage: errorMessage ?? this.errorMessage,
      vocabularies: vocabularies ?? this.vocabularies,
      phrases: phrases ?? this.phrases,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Converts LearningRequestModel to JSON for serialization
  /// Used for debugging and data export
  Map<String, dynamic> toJson() {
    return {
      'requestId': requestId,
      'userId': userId,
      'userLevel': userLevel.toString(),
      'focusAreas': focusAreas,
      'aiProvider': aiProvider.toString(),
      'aiModel': aiModel,
      'totalTokensUsed': totalTokensUsed,
      'estimatedCost': estimatedCost,
      'requestTimestamp': requestTimestamp.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'systemPrompt': systemPrompt,
      'userPrompt': userPrompt,
      'errorMessage': errorMessage,
      'vocabularies': vocabularies.map((v) => v.toJson()).toList(),
      'phrases': phrases.map((p) => p.toJson()).toList(),
      'metadata': metadata,
    };
  }

  /// Creates LearningRequestModel from JSON
  /// Used for data import and debugging
  factory LearningRequestModel.fromJson(Map<String, dynamic> json) {
    return LearningRequestModel(
      requestId: json['requestId'] as String,
      userId: json['userId'] as String,
      userLevel: UserLevel.values.firstWhere(
        (e) => e.toString() == json['userLevel'],
      ),
      focusAreas: List<String>.from(json['focusAreas'] as List),
      aiProvider: AiProviderType.values.firstWhere(
        (e) => e.toString() == json['aiProvider'],
      ),
      aiModel: json['aiModel'] as String,
      totalTokensUsed: json['totalTokensUsed'] as int,
      estimatedCost: json['estimatedCost'] as double,
      requestTimestamp: DateTime.parse(json['requestTimestamp'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      systemPrompt: json['systemPrompt'] as String,
      userPrompt: json['userPrompt'] as String,
      errorMessage: json['errorMessage'] as String?,
      vocabularies:
          (json['vocabularies'] as List)
              .map((v) => VocabularyModel.fromJson(v as Map<String, dynamic>))
              .toList(),
      phrases:
          (json['phrases'] as List)
              .map((p) => PhraseModel.fromJson(p as Map<String, dynamic>))
              .toList(),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LearningRequestModel &&
        other.requestId == requestId &&
        other.userId == userId &&
        other.userLevel == userLevel &&
        other.focusAreas == focusAreas &&
        other.aiProvider == aiProvider &&
        other.aiModel == aiModel &&
        other.totalTokensUsed == totalTokensUsed &&
        other.estimatedCost == estimatedCost &&
        other.requestTimestamp == requestTimestamp &&
        other.createdAt == createdAt &&
        other.systemPrompt == systemPrompt &&
        other.userPrompt == userPrompt &&
        other.errorMessage == errorMessage &&
        other.vocabularies == vocabularies &&
        other.phrases == phrases &&
        other.metadata == metadata;
  }

  @override
  int get hashCode {
    return requestId.hashCode ^
        userId.hashCode ^
        userLevel.hashCode ^
        focusAreas.hashCode ^
        aiProvider.hashCode ^
        aiModel.hashCode ^
        totalTokensUsed.hashCode ^
        estimatedCost.hashCode ^
        requestTimestamp.hashCode ^
        createdAt.hashCode ^
        systemPrompt.hashCode ^
        userPrompt.hashCode ^
        errorMessage.hashCode ^
        vocabularies.hashCode ^
        phrases.hashCode ^
        metadata.hashCode;
  }

  @override
  String toString() {
    return 'LearningRequestModel(requestId: $requestId, userId: $userId, userLevel: $userLevel, focusAreas: $focusAreas, aiProvider: $aiProvider, aiModel: $aiModel, totalTokensUsed: $totalTokensUsed, estimatedCost: $estimatedCost, requestTimestamp: $requestTimestamp, createdAt: $createdAt, systemPrompt: $systemPrompt, userPrompt: $userPrompt, errorMessage: $errorMessage, vocabularies: $vocabularies, phrases: $phrases, metadata: $metadata)';
  }
}

// Example usage:
// final requestModel = LearningRequestModel.fromEntity(learningRequest);
// final entity = requestModel.toEntity();
// final updatedModel = requestModel.copyWith(status: RequestStatus.success);
