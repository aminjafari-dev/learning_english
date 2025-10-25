// sub_category_generation_service.dart
// AI service for generating sub-categories using Gemini API
// Extends the existing Gemini service pattern for sub-category generation

import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'package:learning_english/features/level_selection/domain/entities/user_profile.dart';
import '../../../../../core/error/failure.dart';
import '../../models/sub_category_model.dart';
import '../../models/gemini_response_models.dart';
import 'fallback_sub_categories.dart';

/// AI service for generating sub-categories using Gemini API
/// Uses Google's Gemini API to generate relevant sub-categories based on level and focus areas
class SubCategoryGenerationService {
  final String _apiKey;
  final Dio _dio;

  /// Base URL for Gemini API
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models';

  /// Model to use for generation
  static const String _model = 'gemini-2.5-flash';

  /// Constructor
  /// @param apiKey Google Gemini API key
  SubCategoryGenerationService(String apiKey)
    : _apiKey = apiKey,
      _dio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
        ),
      );

  /// Generate sub-categories using Gemini API
  /// Returns AI-generated sub-categories or falls back to pre-defined ones
  ///
  /// Parameters:
  /// - level: User's English proficiency level
  /// - focusAreas: List of focus areas the user wants to learn
  ///
  /// Returns: Either<Failure, List<SubCategoryModel>> - Success with sub-categories or Failure
  Future<Either<Failure, List<SubCategoryModel>>> generateSubCategories({
    required Level level,
    required List<String> focusAreas,
  }) async {
    try {
      // Validate API key
      if (_apiKey.isEmpty) {
        print('⚠️ [SUB_CATEGORIES] API key not configured, using fallback');
        return right(_getFallbackSubCategories(level, focusAreas));
      }

      // Create the prompt
      final prompt = _buildPrompt(level, focusAreas);

      // Prepare the API request
      final requestUrl = '$_baseUrl/$_model:generateContent';

      final requestBody = {
        'contents': [
          {
            'role': 'user',
            'parts': [
              {'text': prompt},
            ],
          },
        ],
        'generationConfig': {
          'temperature': 0.7, // Lower temperature for more consistent results
          'topK': 1,
          'topP': 1,
          'maxOutputTokens': 2048,
        },
        'safetySettings': [
          {
            'category': 'HARM_CATEGORY_HARASSMENT',
            'threshold': 'BLOCK_MEDIUM_AND_ABOVE',
          },
          {
            'category': 'HARM_CATEGORY_HATE_SPEECH',
            'threshold': 'BLOCK_MEDIUM_AND_ABOVE',
          },
          {
            'category': 'HARM_CATEGORY_SEXUALLY_EXPLICIT',
            'threshold': 'BLOCK_MEDIUM_AND_ABOVE',
          },
          {
            'category': 'HARM_CATEGORY_DANGEROUS_CONTENT',
            'threshold': 'BLOCK_MEDIUM_AND_ABOVE',
          },
        ],
      };

      print(
        '🚀 [SUB_CATEGORIES] Calling Gemini API for sub-category generation',
      );

      // Make the API call
      final response = await _dio.post(
        requestUrl,
        data: requestBody,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'x-goog-api-key': _apiKey,
          },
        ),
      );

      // Parse the response
      if (response.statusCode == 200 && response.data != null) {
        try {
          log(response.toString());
          // Parse the complete Gemini response
          final geminiResponse = GeminiResponse.fromJson(response.data);

          // Log usage metadata for cost tracking
          print(
            '📊 [SUB_CATEGORIES] Token usage - Prompt: ${geminiResponse.usageMetadata.promptTokenCount}, '
            'Response: ${geminiResponse.usageMetadata.candidatesTokenCount}, '
            'Total: ${geminiResponse.usageMetadata.totalTokenCount}',
          );

          // Extract text content
          final textContent = geminiResponse.textContent;
          if (textContent != null) {
            print(
              '✅ [SUB_CATEGORIES] Received AI response: ${textContent.substring(0, 100)}...',
            );

            // Parse the JSON response
            final subCategories = _parseResponse(textContent);
            if (subCategories.isNotEmpty) {
              print(
                '✅ [SUB_CATEGORIES] Successfully parsed ${subCategories.length} sub-categories',
              );
              return right(subCategories);
            } else {
              print(
                '⚠️ [SUB_CATEGORIES] Failed to parse AI response, using fallback',
              );
              return right(_getFallbackSubCategories(level, focusAreas));
            }
          } else {
            print('⚠️ [SUB_CATEGORIES] No text content in response');
            return left(
              const GeminiParsingFailure('No text content in Gemini response'),
            );
          }
        } catch (e) {
          print('❌ [SUB_CATEGORIES] Error parsing Gemini response: $e');
          return left(
            GeminiParsingFailure(
              'Failed to parse Gemini response: ${e.toString()}',
            ),
          );
        }
      }

      print('⚠️ [SUB_CATEGORIES] Invalid API response, using fallback');
      return right(_getFallbackSubCategories(level, focusAreas));
    } on DioException catch (e) {
      print('❌ [SUB_CATEGORIES] Dio error: ${e.message}');
      if (e.response != null) {
        print('Response data: ${e.response?.data}');
        print('Response status: ${e.response?.statusCode}');

        // Handle specific Gemini API errors
        final statusCode = e.response?.statusCode;
        if (statusCode == 429) {
          return left(
            const GeminiRateLimitFailure('Gemini API rate limit exceeded'),
          );
        } else if (statusCode == 403) {
          return left(
            const GeminiQuotaExceededFailure('Gemini API quota exceeded'),
          );
        }
      }
      return left(GeminiApiFailure('Dio error: ${e.message}'));
    } catch (e) {
      print('❌ [SUB_CATEGORIES] Error calling Gemini API: $e');
      return left(GeminiApiFailure('Unexpected error: ${e.toString()}'));
    }
  }

  /// Builds the prompt for sub-category generation
  String _buildPrompt(Level level, List<String> focusAreas) {
    final levelDesc = _getLevelDescription(level);
    final focusAreasString = focusAreas.join(', ');

    return '''You are an English learning curriculum expert. Generate 4-6 relevant sub-categories for English learning based on the user's level and focus area.

User Level: $levelDesc
Focus Area: $focusAreasString

Requirements:
- Sub-categories should be specific and actionable
- Difficulty should match the user's level
- Each sub-category should have 20 lessons worth of content
- Sub-categories should be distinct but complementary
- Include brief descriptions for each sub-category
- Make sub-categories practical and useful for real-world situations

Respond ONLY with valid JSON in this exact format:
{
  "subCategories": [
    {
      "id": "unique_id",
      "title": "Sub-category Title",
      "description": "Brief description of what user will learn",
      "difficulty": "$levelDesc",
      "estimatedLessons": 20,
      "keyTopics": ["topic1", "topic2", "topic3"]
    }
  ]
}

IMPORTANT: Use the exact difficulty level "$levelDesc" for all sub-categories.''';
  }

  /// Gets level description for the prompt
  String _getLevelDescription(Level level) {
    switch (level) {
      case Level.beginner:
        return 'Beginner';
      case Level.elementary:
        return 'Elementary';
      case Level.intermediate:
        return 'Intermediate';
      case Level.advanced:
        return 'Advanced';
    }
  }

  /// Parses the AI response and converts to SubCategoryModel objects
  List<SubCategoryModel> _parseResponse(String responseText) {
    try {
      // Clean the response text (remove markdown formatting if present)
      String cleanText = responseText.trim();
      if (cleanText.startsWith('```json')) {
        cleanText = cleanText.substring(7);
      }
      if (cleanText.endsWith('```')) {
        cleanText = cleanText.substring(0, cleanText.length - 3);
      }
      cleanText = cleanText.trim();

      // Parse JSON
      final Map<String, dynamic> jsonResponse = json.decode(cleanText);

      if (jsonResponse['subCategories'] != null) {
        final List<dynamic> subCategoriesJson = jsonResponse['subCategories'];

        return subCategoriesJson.map((json) {
          return SubCategoryModel.fromJson(json as Map<String, dynamic>);
        }).toList();
      }

      return [];
    } catch (e) {
      print('❌ [SUB_CATEGORIES] Error parsing AI response: $e');
      print('Response text: $responseText');
      return [];
    }
  }

  /// Gets fallback sub-categories when AI generation fails
  List<SubCategoryModel> _getFallbackSubCategories(
    Level level,
    List<String> focusAreas,
  ) {
    print('🔄 [SUB_CATEGORIES] Using fallback sub-categories');
    return FallbackSubCategories.getSubCategories(
      level: level,
      focusAreas: focusAreas,
    );
  }
}
