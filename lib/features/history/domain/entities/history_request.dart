import 'package:learning_english/features/daily_lessons/data/models/level_type.dart';

import 'vocabulary_history_item.dart';
import 'phrase_history_item.dart';
import '../../../daily_lessons/data/models/ai_provider_type.dart';

/// HistoryRequest represents a complete learning request made by the user.
/// This entity groups vocabulary and phrase items by their request ID and creation date,
/// providing a comprehensive view of what was generated in a single learning session.
/// Now includes comprehensive metadata about the request including user context, AI provider details, and costs.
///
/// Usage Example:
///   final request = HistoryRequest(
///     requestId: 'req_123',
///     userId: 'user_456',
///     userLevel: Level.intermediate,
///     focusAreas: ['business', 'travel'],
///     aiProvider: AiProviderType.openai,
///     aiModel: 'gpt-3.5-turbo',
///     totalTokensUsed: 150,
///     estimatedCost: 0.0003,
///     requestTimestamp: DateTime.now(),
///     createdAt: DateTime.now(),
///     systemPrompt: 'Generate vocabulary for...',
///     userPrompt: 'I want to learn business English',
///     status: RequestStatus.success,
///     vocabularies: [vocab1, vocab2],
///     phrases: [phrase1, phrase2],
///   );
///
/// This entity is used to organize history data by request for better user experience.
class HistoryRequest {
  /// The unique identifier for this learning request
  final String requestId;

  /// The user ID who made this request
  final String userId;

  /// The user's English proficiency level
  final UserLevel userLevel;

  /// The learning focus areas selected by the user
  final List<String> focusAreas;

  /// The AI provider used for this request
  final AiProviderType aiProvider;

  /// The specific AI model used
  final String aiModel;

  /// Total tokens used in this request
  final int totalTokensUsed;

  /// Estimated cost of this request in USD
  final double estimatedCost;

  /// When the request was made to the AI
  final DateTime requestTimestamp;

  /// When this request was created and saved
  final DateTime createdAt;

  /// The system prompt used for this request
  final String systemPrompt;

  /// The user prompt used for this request
  final String userPrompt;


  /// Error message if the request failed
  final String? errorMessage;

  /// List of vocabulary items generated for this request
  final List<VocabularyHistoryItem> vocabularies;

  /// List of phrase items generated for this request
  final List<PhraseHistoryItem> phrases;

  /// Additional metadata for this request
  final Map<String, dynamic>? metadata;

  /// Constructor for HistoryRequest
  /// All fields are required to maintain complete request information
  const HistoryRequest({
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

  /// Creates a copy of HistoryRequest with updated fields
  /// Useful for updating specific properties while keeping others unchanged
  HistoryRequest copyWith({
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
    List<VocabularyHistoryItem>? vocabularies,
    List<PhraseHistoryItem>? phrases,
    Map<String, dynamic>? metadata,
  }) {
    return HistoryRequest(
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

  /// Gets the total number of items in this request
  /// Useful for displaying summary information
  int get totalItems => vocabularies.length + phrases.length;

  /// Gets the number of vocabulary items in this request
  int get vocabularyCount => vocabularies.length;

  /// Gets the number of phrase items in this request
  int get phraseCount => phrases.length;

  /// Checks if this request has any vocabulary items
  bool get hasVocabularies => vocabularies.isNotEmpty;

  /// Checks if this request has any phrase items
  bool get hasPhrases => phrases.isNotEmpty;

  /// Converts the entity to a JSON map
  /// Used for serialization and data transfer
  Map<String, dynamic> toJson() {
    return {
      'requestId': requestId,
      'userId': userId,
      'userLevel': userLevel.name,
      'focusAreas': focusAreas,
      'aiProvider': aiProvider.name,
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

  /// Creates a HistoryRequest from a JSON map
  /// Used for deserialization and data transfer
  factory HistoryRequest.fromJson(Map<String, dynamic> json) {
    return HistoryRequest(
      requestId: json['requestId'] as String,
      userId: json['userId'] as String,
      userLevel: UserLevel.values.firstWhere(
        (e) => e.name == json['userLevel'],
        orElse: () => UserLevel.beginner,
      ),
      focusAreas: List<String>.from(json['focusAreas'] as List),
      aiProvider: AiProviderType.values.firstWhere(
        (e) => e.name == json['aiProvider'],
        orElse: () => AiProviderType.openai,
      ),
      aiModel: json['aiModel'] as String,
      totalTokensUsed: json['totalTokensUsed'] as int,
      estimatedCost: (json['estimatedCost'] as num).toDouble(),
      requestTimestamp: DateTime.parse(json['requestTimestamp'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      systemPrompt: json['systemPrompt'] as String,
      userPrompt: json['userPrompt'] as String,
      errorMessage: json['errorMessage'] as String?,
      vocabularies:
          (json['vocabularies'] as List)
              .map(
                (v) =>
                    VocabularyHistoryItem.fromJson(v as Map<String, dynamic>),
              )
              .toList(),
      phrases:
          (json['phrases'] as List)
              .map((p) => PhraseHistoryItem.fromJson(p as Map<String, dynamic>))
              .toList(),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HistoryRequest &&
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
    return 'HistoryRequest(requestId: $requestId, userId: $userId, userLevel: $userLevel, focusAreas: $focusAreas, aiProvider: $aiProvider, totalTokensUsed: $totalTokensUsed, estimatedCost: $estimatedCost, vocabularies: ${vocabularies.length}, phrases: ${phrases.length})';
  }
}
