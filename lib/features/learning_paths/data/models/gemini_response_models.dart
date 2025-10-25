// gemini_response_models.dart
// Models for handling Gemini API responses with metadata
// Includes usage metadata and response parsing for sub-category generation

import 'package:json_annotation/json_annotation.dart';

part 'gemini_response_models.g.dart';

/// Model for Gemini API usage metadata
/// Contains token usage information and model version details
@JsonSerializable()
class UsageMetadata {
  final int promptTokenCount;
  final int candidatesTokenCount;
  final int totalTokenCount;
  final List<PromptTokensDetail> promptTokensDetails;
  final int thoughtsTokenCount;

  const UsageMetadata({
    required this.promptTokenCount,
    required this.candidatesTokenCount,
    required this.totalTokenCount,
    required this.promptTokensDetails,
    required this.thoughtsTokenCount,
  });

  factory UsageMetadata.fromJson(Map<String, dynamic> json) =>
      _$UsageMetadataFromJson(json);

  Map<String, dynamic> toJson() => _$UsageMetadataToJson(this);
}

/// Model for prompt token details
@JsonSerializable()
class PromptTokensDetail {
  final String modality;
  final int tokenCount;

  const PromptTokensDetail({required this.modality, required this.tokenCount});

  factory PromptTokensDetail.fromJson(Map<String, dynamic> json) =>
      _$PromptTokensDetailFromJson(json);

  Map<String, dynamic> toJson() => _$PromptTokensDetailToJson(this);
}

/// Model for Gemini API candidate content
@JsonSerializable()
class CandidateContent {
  final List<ContentPart> parts;
  final String role;

  const CandidateContent({required this.parts, required this.role});

  factory CandidateContent.fromJson(Map<String, dynamic> json) =>
      _$CandidateContentFromJson(json);

  Map<String, dynamic> toJson() => _$CandidateContentToJson(this);
}

/// Model for content parts in Gemini response
@JsonSerializable()
class ContentPart {
  final String text;

  const ContentPart({required this.text});

  factory ContentPart.fromJson(Map<String, dynamic> json) =>
      _$ContentPartFromJson(json);

  Map<String, dynamic> toJson() => _$ContentPartToJson(this);
}

/// Model for Gemini API candidate
@JsonSerializable()
class GeminiCandidate {
  final CandidateContent content;
  final String finishReason;
  final int index;

  const GeminiCandidate({
    required this.content,
    required this.finishReason,
    required this.index,
  });

  factory GeminiCandidate.fromJson(Map<String, dynamic> json) =>
      _$GeminiCandidateFromJson(json);

  Map<String, dynamic> toJson() => _$GeminiCandidateToJson(this);
}

/// Complete model for Gemini API response
/// Includes all response data and usage metadata
@JsonSerializable()
class GeminiResponse {
  final List<GeminiCandidate> candidates;
  final UsageMetadata usageMetadata;
  final String modelVersion;
  final String responseId;

  const GeminiResponse({
    required this.candidates,
    required this.usageMetadata,
    required this.modelVersion,
    required this.responseId,
  });

  factory GeminiResponse.fromJson(Map<String, dynamic> json) =>
      _$GeminiResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GeminiResponseToJson(this);

  /// Extracts the text content from the first candidate
  String? get textContent {
    if (candidates.isNotEmpty && candidates.first.content.parts.isNotEmpty) {
      return candidates.first.content.parts.first.text;
    }
    return null;
  }

  /// Gets the total token count for cost calculation
  int get totalTokens => usageMetadata.totalTokenCount;

  /// Gets the model version used
  String get model => modelVersion;
}
