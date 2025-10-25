// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gemini_response_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UsageMetadata _$UsageMetadataFromJson(Map<String, dynamic> json) =>
    UsageMetadata(
      promptTokenCount: (json['promptTokenCount'] as num).toInt(),
      candidatesTokenCount: (json['candidatesTokenCount'] as num).toInt(),
      totalTokenCount: (json['totalTokenCount'] as num).toInt(),
      promptTokensDetails: (json['promptTokensDetails'] as List<dynamic>)
          .map((e) => PromptTokensDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
      thoughtsTokenCount: (json['thoughtsTokenCount'] as num).toInt(),
    );

Map<String, dynamic> _$UsageMetadataToJson(UsageMetadata instance) =>
    <String, dynamic>{
      'promptTokenCount': instance.promptTokenCount,
      'candidatesTokenCount': instance.candidatesTokenCount,
      'totalTokenCount': instance.totalTokenCount,
      'promptTokensDetails': instance.promptTokensDetails,
      'thoughtsTokenCount': instance.thoughtsTokenCount,
    };

PromptTokensDetail _$PromptTokensDetailFromJson(Map<String, dynamic> json) =>
    PromptTokensDetail(
      modality: json['modality'] as String,
      tokenCount: (json['tokenCount'] as num).toInt(),
    );

Map<String, dynamic> _$PromptTokensDetailToJson(PromptTokensDetail instance) =>
    <String, dynamic>{
      'modality': instance.modality,
      'tokenCount': instance.tokenCount,
    };

CandidateContent _$CandidateContentFromJson(Map<String, dynamic> json) =>
    CandidateContent(
      parts: (json['parts'] as List<dynamic>)
          .map((e) => ContentPart.fromJson(e as Map<String, dynamic>))
          .toList(),
      role: json['role'] as String,
    );

Map<String, dynamic> _$CandidateContentToJson(CandidateContent instance) =>
    <String, dynamic>{
      'parts': instance.parts,
      'role': instance.role,
    };

ContentPart _$ContentPartFromJson(Map<String, dynamic> json) => ContentPart(
      text: json['text'] as String,
    );

Map<String, dynamic> _$ContentPartToJson(ContentPart instance) =>
    <String, dynamic>{
      'text': instance.text,
    };

GeminiCandidate _$GeminiCandidateFromJson(Map<String, dynamic> json) =>
    GeminiCandidate(
      content:
          CandidateContent.fromJson(json['content'] as Map<String, dynamic>),
      finishReason: json['finishReason'] as String,
      index: (json['index'] as num).toInt(),
    );

Map<String, dynamic> _$GeminiCandidateToJson(GeminiCandidate instance) =>
    <String, dynamic>{
      'content': instance.content,
      'finishReason': instance.finishReason,
      'index': instance.index,
    };

GeminiResponse _$GeminiResponseFromJson(Map<String, dynamic> json) =>
    GeminiResponse(
      candidates: (json['candidates'] as List<dynamic>)
          .map((e) => GeminiCandidate.fromJson(e as Map<String, dynamic>))
          .toList(),
      usageMetadata:
          UsageMetadata.fromJson(json['usageMetadata'] as Map<String, dynamic>),
      modelVersion: json['modelVersion'] as String,
      responseId: json['responseId'] as String,
    );

Map<String, dynamic> _$GeminiResponseToJson(GeminiResponse instance) =>
    <String, dynamic>{
      'candidates': instance.candidates,
      'usageMetadata': instance.usageMetadata,
      'modelVersion': instance.modelVersion,
      'responseId': instance.responseId,
    };
