// learning_request.dart
// Domain entity for learning requests with complete metadata and generated content.
// This entity represents a complete AI request with all context and generated vocabulary/phrases.

import 'package:learning_english/features/daily_lessons/data/models/level_type.dart';

import 'vocabulary.dart';
import 'phrase.dart';
import '../../data/models/ai_provider_type.dart';



/// Domain entity for learning requests with complete metadata
/// Contains all request context, AI provider info, and generated content
class LearningRequest {
  final String requestId; // Unique request identifier
  final String userId; // User who made the request
  final UserLevel userLevel; // User's English level
  final List<String> focusAreas; // Selected learning focus areas
  final AiProviderType aiProvider; // Which AI provider used
  final String aiModel; // Specific model (gpt-4, gemini-pro, etc.)
  final int totalTokensUsed; // Total tokens consumed
  final double estimatedCost; // Estimated cost in USD
  final DateTime requestTimestamp; // When request was made
  final DateTime createdAt; // When content was created
  final String systemPrompt; // The actual prompt sent to AI
  final String userPrompt; // User-specific prompt
  final String? errorMessage; // Error details if failed
  final List<Vocabulary> vocabularies; // Generated vocabularies
  final List<Phrase> phrases; // Generated phrases
  final Map<String, dynamic>? metadata; // Additional request metadata

  const LearningRequest({
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

  /// Creates a copy of LearningRequest with updated fields
  LearningRequest copyWith({
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
    List<Vocabulary>? vocabularies,
    List<Phrase>? phrases,
    Map<String, dynamic>? metadata,
  }) {
    return LearningRequest(
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LearningRequest &&
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
    return 'LearningRequest(requestId: $requestId, userId: $userId, userLevel: $userLevel, focusAreas: $focusAreas, aiProvider: $aiProvider, aiModel: $aiModel, totalTokensUsed: $totalTokensUsed, estimatedCost: $estimatedCost, requestTimestamp: $requestTimestamp, createdAt: $createdAt, systemPrompt: $systemPrompt, userPrompt: $userPrompt, errorMessage: $errorMessage, vocabularies: $vocabularies, phrases: $phrases, metadata: $metadata)';
  }
}

// Example usage:
// final request = LearningRequest(
//   requestId: 'req_20240115_1030_abc123',
//   userId: 'user_123',
//   userLevel: Level.intermediate,
//   focusAreas: ['business', 'travel'],
//   aiProvider: AiProviderType.openai,
//   aiModel: 'gpt-4',
//   totalTokensUsed: 450,
//   estimatedCost: 0.0135,
//   requestTimestamp: DateTime.now(),
//   createdAt: DateTime.now(),
//   systemPrompt: 'You are an English teacher...',
//   userPrompt: 'Generate 4 business vocabulary...',
//   status: RequestStatus.success,
//   vocabularies: [vocabulary1, vocabulary2],
//   phrases: [phrase1, phrase2],
// );
