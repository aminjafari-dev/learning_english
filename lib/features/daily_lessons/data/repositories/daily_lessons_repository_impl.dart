// daily_lessons_repository_impl.dart
// Implementation of DailyLessonsRepository
// Coordinates between local storage, AI services, and learning path management

import 'dart:convert';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/vocabulary.dart';
import '../../domain/entities/phrase.dart';
import '../../domain/entities/user_preferences.dart';
import '../../domain/repositories/daily_lessons_repository.dart';
import '../../domain/repositories/conversation_repository.dart';
import '../../domain/repositories/user_preferences_repository.dart';
import '../../../learning_paths/domain/entities/learning_path.dart';
import '../../../learning_paths/domain/repositories/learning_paths_repository.dart';
import '../datasources/local/daily_lessons_local_data_source.dart';
import '../models/vocabulary_model.dart';
import '../models/phrase_model.dart';

/// Implementation of DailyLessonsRepository
/// Handles daily lessons operations using local storage and AI services
class DailyLessonsRepositoryImpl implements DailyLessonsRepository {
  final DailyLessonsLocalDataSource _localDataSource;
  final ConversationRepository _conversationRepository;
  final UserPreferencesRepository _userPreferencesRepository;
  final LearningPathsRepository _learningPathsRepository;

  /// Constructor
  /// @param localDataSource Local data source for daily lessons
  /// @param conversationRepository Conversation repository
  /// @param userPreferencesRepository User preferences repository
  /// @param learningPathsRepository Learning paths repository
  DailyLessonsRepositoryImpl({
    required DailyLessonsLocalDataSource localDataSource,
    required ConversationRepository conversationRepository,
    required UserPreferencesRepository userPreferencesRepository,
    required LearningPathsRepository learningPathsRepository,
  }) : _localDataSource = localDataSource,
       _conversationRepository = conversationRepository,
       _userPreferencesRepository = userPreferencesRepository,
       _learningPathsRepository = learningPathsRepository;

  @override
  Future<
    Either<Failure, ({List<Vocabulary> vocabularies, List<Phrase> phrases})>
  >
  getPersonalizedDailyLessons(UserPreferences preferences) async {
    try {
      // Use conversation repository to get personalized lessons
      final result = await _conversationRepository.generateConversationResponse(
        preferences,
      );

      return result.fold((failure) => left(failure), (aiResponse) {
        // For now, return empty lists - this should be enhanced to parse the AI response
        // and extract vocabularies and phrases
        return right((vocabularies: <Vocabulary>[], phrases: <Phrase>[]));
      });
    } catch (e) {
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

        // Get lessons using conversation repository
        final result = await _conversationRepository
            .generateConversationResponse(enhancedPreferences);

        return result.fold((failure) => left(failure), (aiResponse) async {
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
      });
    } catch (e) {
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
