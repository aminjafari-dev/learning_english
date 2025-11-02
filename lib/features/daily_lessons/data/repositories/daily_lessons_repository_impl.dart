// daily_lessons_repository_impl.dart
// Implementation of DailyLessonsRepository
// Coordinates between local storage, AI services, and learning path management

import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:learning_english/core/repositories/user_repository.dart'
    as core_user;
import '../../../../core/error/failure.dart';
import '../../domain/entities/vocabulary.dart';
import '../../domain/entities/phrase.dart';
import '../../domain/entities/user_preferences.dart';
import '../../domain/repositories/daily_lessons_repository.dart';
import '../../domain/repositories/user_preferences_repository.dart';
import '../../../learning_paths/domain/entities/learning_path.dart';
import '../../../learning_paths/domain/repositories/learning_paths_repository.dart';
import '../datasources/local/daily_lessons_local_data_source.dart';
import '../datasources/remote/gemini_lessons_service.dart';
import '../models/vocabulary_model.dart';
import '../models/phrase_model.dart';
import '../models/learning_request_model.dart';
import '../models/ai_provider_type.dart';
import '../models/level_type.dart';

/// Implementation of DailyLessonsRepository
/// Handles daily lessons operations using local storage and AI services
class DailyLessonsRepositoryImpl implements DailyLessonsRepository {
  final DailyLessonsLocalDataSource _localDataSource;
  final GeminiLessonsService _geminiLessonsService;
  final UserPreferencesRepository _userPreferencesRepository;
  final LearningPathsRepository _learningPathsRepository;
  final core_user.UserRepository _coreUserRepository;

  /// Constructor
  /// @param localDataSource Local data source for daily lessons
  /// @param geminiLessonsService Gemini lessons service for AI generation
  /// @param userPreferencesRepository User preferences repository
  /// @param learningPathsRepository Learning paths repository
  /// @param coreUserRepository Core user repository
  DailyLessonsRepositoryImpl({
    required DailyLessonsLocalDataSource localDataSource,
    required GeminiLessonsService geminiLessonsService,
    required UserPreferencesRepository userPreferencesRepository,
    required LearningPathsRepository learningPathsRepository,
    required core_user.UserRepository coreUserRepository,
  }) : _localDataSource = localDataSource,
       _geminiLessonsService = geminiLessonsService,
       _userPreferencesRepository = userPreferencesRepository,
       _learningPathsRepository = learningPathsRepository,
       _coreUserRepository = coreUserRepository;

  @override
  Future<
    Either<Failure, ({List<Vocabulary> vocabularies, List<Phrase> phrases})>
  >
  getPersonalizedDailyLessons(UserPreferences preferences) async {
    try {
      print('📚 [LESSONS] Getting personalized daily lessons');
      print(
        '📋 [LESSONS] User preferences: level=${preferences.level}, areas=${preferences.focusAreas}',
      );

      // Get user ID for tracking
      final userId = await _coreUserRepository.getUserId() ?? 'current_user';

      // Convert UserLevel to the model's UserLevel
      final userLevel = _convertToModelUserLevel(preferences.level);

      // Generate lessons using Gemini service
      final aiResponse = await _geminiLessonsService.generateLessonsResponse(
        userLevel: userLevel,
        focusAreas: preferences.focusAreas,
      );

      print('✅ [LESSONS] Received AI response');

      // Parse the AI response to extract vocabularies and phrases
      final parsedData = _parseAIResponse(aiResponse);
      final vocabularies = parsedData.vocabularies;
      final phrases = parsedData.phrases;

      print(
        '✅ [LESSONS] Generated ${vocabularies.length} vocabularies and ${phrases.length} phrases',
      );

      // Save the generated content to local storage
      await _saveGeneratedContent(
        userId,
        preferences,
        vocabularies,
        phrases,
        aiResponse,
      );

      return right((vocabularies: vocabularies, phrases: phrases));
    } catch (e) {
      print('❌ [LESSONS] Failed to get personalized daily lessons: $e');
      return left(
        ServerFailure(
          'Failed to get personalized daily lessons: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<
    Either<Failure, ({List<Vocabulary> vocabularies, List<Phrase> phrases})>
  >
  getCourseLessons(
    String pathId,
    int courseNumber,
    LearningPath learningPath,
  ) async {
    try {
      // First check if course content already exists
      final hasContent = await _localDataSource.hasCourseContent(
        pathId,
        courseNumber,
      );

      if (hasContent) {
        // Return existing content
        print(
          '✅ [COURSE_CONTENT] Found existing content for course $courseNumber in path $pathId',
        );
        final existingContent = await _localDataSource.getCourseContent(
          pathId,
          courseNumber,
        );
        if (existingContent != null) {
          final vocabularies =
              existingContent.vocabularies.map((v) => v.toEntity()).toList();
          final phrases =
              existingContent.phrases.map((p) => p.toEntity()).toList();

          print(
            '✅ [COURSE_CONTENT] Returning ${vocabularies.length} vocabularies and ${phrases.length} phrases from cache',
          );

          return right((vocabularies: vocabularies, phrases: phrases));
        }
      } else {
        print(
          'ℹ️ [COURSE_CONTENT] No existing content found for course $courseNumber in path $pathId, generating new content',
        );
      }

      // Generate new content for the course
      final userPreferences =
          await _userPreferencesRepository.getUserPreferences();

      return userPreferences.fold((failure) => left(failure), (
        preferences,
      ) async {
        // Create enhanced preferences with course context
        final enhancedPreferences = _createEnhancedPreferencesWithCourseContext(
          preferences,
          learningPath,
          courseNumber,
        );

        // Convert UserLevel to the model's UserLevel
        final userLevel = _convertToModelUserLevel(enhancedPreferences.level);

        // Get the course from the learning path
        final course = learningPath.courses.firstWhere(
          (c) => c.courseNumber == courseNumber,
          orElse: () => learningPath.courses.first,
        );

        // Generate course-specific lessons using Gemini service with subcategory
        final aiResponse = await _geminiLessonsService
            .generateCourseLessonResponse(
              userLevel: userLevel,
              focusAreas: enhancedPreferences.focusAreas,
              courseTitle: course.title,
              courseNumber: courseNumber,
              subCategory: learningPath.subCategory.title,
            );

        print(
          '🔄 [COURSE_CONTENT] Generating new content for course $courseNumber in path $pathId',
        );

        // Parse the AI response to extract vocabularies and phrases
        final parsedData = _parseAIResponse(aiResponse);
        final vocabularies = parsedData.vocabularies;
        final phrases = parsedData.phrases;

        print(
          '✅ [COURSE_CONTENT] Generated ${vocabularies.length} vocabularies and ${phrases.length} phrases',
        );

        // Save the course content for future use
        final vocabularyModels =
            vocabularies.map((v) => VocabularyModel.fromEntity(v)).toList();
        final phraseModels =
            phrases.map((p) => PhraseModel.fromEntity(p)).toList();

        await _localDataSource.saveCourseContent(
          pathId,
          courseNumber,
          vocabularyModels,
          phraseModels,
        );

        print('💾 [COURSE_CONTENT] Saved course content for future use');

        return right((vocabularies: vocabularies, phrases: phrases));
      });
    } catch (e) {
      print('❌ [COURSE_CONTENT] Failed to get course lessons: $e');
      return left(
        ServerFailure('Failed to get course lessons: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> hasCourseContent(
    String pathId,
    int courseNumber,
  ) async {
    try {
      final hasContent = await _localDataSource.hasCourseContent(
        pathId,
        courseNumber,
      );
      return right(hasContent);
    } catch (e) {
      return left(
        ServerFailure('Failed to check course content: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> saveCourseContent(
    String pathId,
    int courseNumber,
    List<Vocabulary> vocabularies,
    List<Phrase> phrases,
  ) async {
    try {
      final vocabularyModels =
          vocabularies.map((v) => VocabularyModel.fromEntity(v)).toList();
      final phraseModels =
          phrases.map((p) => PhraseModel.fromEntity(p)).toList();

      await _localDataSource.saveCourseContent(
        pathId,
        courseNumber,
        vocabularyModels,
        phraseModels,
      );

      return right(null);
    } catch (e) {
      return left(
        ServerFailure('Failed to save course content: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> completeCourse(
    String pathId,
    int courseNumber,
  ) async {
    try {
      // Use learning paths repository to complete the course
      final result = await _learningPathsRepository.completeCourse(
        pathId,
        courseNumber,
      );

      return result.fold((failure) => left(failure), (_) => right(null));
    } catch (e) {
      return left(ServerFailure('Failed to complete course: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, UserPreferences>> getUserPreferences() async {
    try {
      return await _userPreferencesRepository.getUserPreferences();
    } catch (e) {
      return left(
        ServerFailure('Failed to get user preferences: ${e.toString()}'),
      );
    }
  }

  /// Saves generated content to local storage
  /// Creates a learning request for proper tracking
  /// @param userId User ID
  /// @param preferences User preferences
  /// @param vocabularies List of vocabularies to save
  /// @param phrases List of phrases to save
  /// @param aiResponse AI response string
  Future<void> _saveGeneratedContent(
    String userId,
    UserPreferences preferences,
    List<Vocabulary> vocabularies,
    List<Phrase> phrases,
    String aiResponse,
  ) async {
    try {
      print('💾 [LESSONS] Saving generated content to local storage');
      print(
        '💾 [LESSONS] Vocabularies: ${vocabularies.length}, Phrases: ${phrases.length}',
      );

      // Convert domain entities to models for storage
      final vocabularyModels =
          vocabularies
              .map(
                (vocab) => VocabularyModel(
                  english: vocab.english,
                  persian: vocab.persian,
                  isUsed: false,
                ),
              )
              .toList();

      final phraseModels =
          phrases
              .map(
                (phrase) => PhraseModel(
                  english: phrase.english,
                  persian: phrase.persian,
                  isUsed: false,
                ),
              )
              .toList();

      // Create learning request
      final learningRequest = LearningRequestModel(
        requestId: 'lesson_${DateTime.now().millisecondsSinceEpoch}',
        userId: userId,
        userLevel: _convertToModelUserLevel(preferences.level),
        focusAreas: preferences.focusAreas,
        aiProvider: AiProviderType.gemini,
        aiModel: 'gemini-2.5-flash',
        totalTokensUsed: 0,
        estimatedCost: 0.0,
        requestTimestamp: DateTime.now(),
        createdAt: DateTime.now(),
        systemPrompt: 'Daily lesson generation',
        userPrompt: aiResponse.substring(
          0,
          aiResponse.length > 200 ? 200 : aiResponse.length,
        ),
        vocabularies: vocabularyModels,
        phrases: phraseModels,
        metadata: {
          'source': 'daily_lessons',
          'preferences': {
            'level': preferences.level.name,
            'focusAreas': preferences.focusAreas,
          },
        },
      );

      // Save to local storage
      await _localDataSource.saveLearningRequest(learningRequest);
      print('✅ [LESSONS] Successfully saved content locally');
    } catch (e) {
      print('❌ [LESSONS] Failed to save content: $e');
      // Don't throw here to avoid breaking the main flow
    }
  }

  /// Converts domain UserLevel to model UserLevel for storage
  /// @param preferencesLevel Domain level
  /// @return Model level
  UserLevel _convertToModelUserLevel(dynamic preferencesLevel) {
    switch (preferencesLevel.toString()) {
      case 'UserLevel.beginner':
        return UserLevel.beginner;
      case 'UserLevel.elementary':
        return UserLevel.elementary;
      case 'UserLevel.intermediate':
        return UserLevel.intermediate;
      case 'UserLevel.advanced':
        return UserLevel.advanced;
      default:
        return UserLevel.intermediate; // Default fallback
    }
  }

  /// Parses AI response to extract vocabularies and phrases
  /// Handles JSON parsing and validation
  /// @param aiResponse The AI response string
  /// @return Parsed vocabularies and phrases
  ({List<Vocabulary> vocabularies, List<Phrase> phrases}) _parseAIResponse(
    String aiResponse,
  ) {
    try {
      // Extract JSON from the response (AI might add extra text)
      final jsonStart = aiResponse.indexOf('{');
      final jsonEnd = aiResponse.lastIndexOf('}') + 1;

      if (jsonStart == -1 || jsonEnd == 0) {
        print('❌ [COURSE_CONTENT] No JSON found in AI response');
        return (vocabularies: <Vocabulary>[], phrases: <Phrase>[]);
      }

      final jsonString = aiResponse.substring(jsonStart, jsonEnd);
      final Map<String, dynamic> data = jsonDecode(jsonString);

      // Parse vocabularies
      final List<dynamic> vocabList = data['vocabularies'] ?? [];
      final vocabularies =
          vocabList
              .map(
                (e) => Vocabulary(
                  english: e['english'] ?? '',
                  persian: e['persian'] ?? '',
                ),
              )
              .where((v) => v.english.isNotEmpty && v.persian.isNotEmpty)
              .toList();

      // Parse phrases
      final List<dynamic> phraseList = data['phrases'] ?? [];
      final phrases =
          phraseList
              .map(
                (e) => Phrase(
                  english: e['english'] ?? '',
                  persian: e['persian'] ?? '',
                ),
              )
              .where((p) => p.english.isNotEmpty && p.persian.isNotEmpty)
              .toList();

      print(
        '✅ [COURSE_CONTENT] Parsed ${vocabularies.length} vocabularies and ${phrases.length} phrases from AI response',
      );

      return (vocabularies: vocabularies, phrases: phrases);
    } catch (e) {
      print('❌ [COURSE_CONTENT] Failed to parse AI response: $e');
      // Return empty lists if parsing fails
      return (vocabularies: <Vocabulary>[], phrases: <Phrase>[]);
    }
  }

  /// Creates enhanced preferences with course context
  /// @param basePreferences Base user preferences
  /// @param learningPath The learning path
  /// @param courseNumber The course number
  /// @return Enhanced preferences with course context
  UserPreferences _createEnhancedPreferencesWithCourseContext(
    UserPreferences basePreferences,
    LearningPath learningPath,
    int courseNumber,
  ) {
    // Create enhanced focus areas that include course-specific context
    final enhancedFocusAreas = [
      ...basePreferences.focusAreas,
      learningPath.subCategory.title.toLowerCase(),
      'course_$courseNumber',
    ];

    return basePreferences.copyWith(focusAreas: enhancedFocusAreas);
  }
}
