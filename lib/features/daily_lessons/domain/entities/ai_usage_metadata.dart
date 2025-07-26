// ai_usage_metadata.dart
// Entity representing AI usage metadata from API responses.
// Contains information about token usage, model version, and response details.

/// Entity representing AI usage metadata from API responses
class AiUsageMetadata {
  final int promptTokenCount;
  final int candidatesTokenCount;
  final int totalTokenCount;
  final int thoughtsTokenCount;
  final String modelVersion;
  final String responseId;
  final String finishReason;

  /// Creates an immutable AiUsageMetadata entity.
  const AiUsageMetadata({
    required this.promptTokenCount,
    required this.candidatesTokenCount,
    required this.totalTokenCount,
    required this.thoughtsTokenCount,
    required this.modelVersion,
    required this.responseId,
    required this.finishReason,
  });

  /// Creates AiUsageMetadata from a JSON map
  /// Used when parsing API responses from different providers
  factory AiUsageMetadata.fromJson(Map<String, dynamic> json) {
    // Handle Gemini response format
    if (json.containsKey('usageMetadata')) {
      final usageMetadata =
          json['usageMetadata'] as Map<String, dynamic>? ?? {};
      final candidates = json['candidates'] as List<dynamic>? ?? [];
      final firstCandidate =
          candidates.isNotEmpty
              ? candidates.first as Map<String, dynamic>?
              : null;

      return AiUsageMetadata(
        promptTokenCount: usageMetadata['promptTokenCount'] as int? ?? 0,
        candidatesTokenCount:
            usageMetadata['candidatesTokenCount'] as int? ?? 0,
        totalTokenCount: usageMetadata['totalTokenCount'] as int? ?? 0,
        thoughtsTokenCount: usageMetadata['thoughtsTokenCount'] as int? ?? 0,
        modelVersion: usageMetadata['modelVersion'] as String? ?? '',
        responseId: usageMetadata['responseId'] as String? ?? '',
        finishReason: firstCandidate?['finishReason'] as String? ?? '',
      );
    }

    // Handle OpenAI response format
    if (json.containsKey('usage')) {
      final usage = json['usage'] as Map<String, dynamic>? ?? {};
      final choices = json['choices'] as List<dynamic>? ?? [];
      final firstChoice =
          choices.isNotEmpty ? choices.first as Map<String, dynamic>? : null;

      return AiUsageMetadata(
        promptTokenCount: usage['prompt_tokens'] as int? ?? 0,
        candidatesTokenCount: usage['completion_tokens'] as int? ?? 0,
        totalTokenCount: usage['total_tokens'] as int? ?? 0,
        thoughtsTokenCount: 0, // OpenAI doesn't provide thoughts token count
        modelVersion: json['model'] as String? ?? '',
        responseId: json['id'] as String? ?? '',
        finishReason: firstChoice?['finish_reason'] as String? ?? '',
      );
    }

    // Default case for unknown format
    return const AiUsageMetadata(
      promptTokenCount: 0,
      candidatesTokenCount: 0,
      totalTokenCount: 0,
      thoughtsTokenCount: 0,
      modelVersion: 'unknown',
      responseId: 'unknown',
      finishReason: 'unknown',
    );
  }

  /// Converts the entity to a JSON map
  /// Useful for debugging and logging
  Map<String, dynamic> toJson() {
    return {
      'promptTokenCount': promptTokenCount,
      'candidatesTokenCount': candidatesTokenCount,
      'totalTokenCount': totalTokenCount,
      'thoughtsTokenCount': thoughtsTokenCount,
      'modelVersion': modelVersion,
      'responseId': responseId,
      'finishReason': finishReason,
    };
  }

  @override
  String toString() {
    return 'AiUsageMetadata(promptTokens: $promptTokenCount, candidateTokens: $candidatesTokenCount, totalTokens: $totalTokenCount, model: $modelVersion)';
  }
}

// Example usage:
// final metadata = AiUsageMetadata.fromJson(apiResponse);
// print('Total tokens used: ${metadata.totalTokenCount}');
