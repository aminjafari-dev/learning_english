// courses_repository_impl.dart
// Implementation of CoursesRepository
// Coordinates between local storage, AI services, and learning path management

import 'dart:convert';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/vocabulary.dart';
import '../../domain/entities/phrase.dart';
import '../../domain/repositories/courses_repository.dart';
import '../../../learning_paths/domain/entities/learning_path.dart';
import '../../../learning_paths/domain/repositories/learning_paths_repository.dart';
import '../datasources/local/courses_local_data_source.dart';
import '../datasources/remote/gemini_lessons_service.dart';
import '../models/vocabulary_model.dart';
import '../models/phrase_model.dart';

/// Implementation of CoursesRepository
/// Handles courses operations using local storage and AI services
class CoursesRepositoryImpl implements CoursesRepository {
  final CoursesLocalDataSource _localDataSource;
  final GeminiLessonsService _geminiLessonsService;
  final LearningPathsRepository _learningPathsRepository;

  /// Constructor
  /// @param localDataSource Local data source for courses
  /// @param geminiLessonsService Gemini lessons service for AI generation
  /// @param learningPathsRepository Learning paths repository
  CoursesRepositoryImpl({
    required CoursesLocalDataSource localDataSource,
    required GeminiLessonsService geminiLessonsService,
    required LearningPathsRepository learningPathsRepository,
  }) : _localDataSource = localDataSource,
       _geminiLessonsService = geminiLessonsService,
       _learningPathsRepository = learningPathsRepository;

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

      // Generate new content for the course using learning path information
      // Get the course from the learning path
      final course = learningPath.courses.firstWhere(
        (c) => c.courseNumber == courseNumber,
        orElse: () => learningPath.courses.first,
      );

      // Fetch previous course content from the same learning path to avoid duplicates
      // Extract English vocabularies and phrases from previous courses (excluding current course)
      final previousVocabularies = <String>[];
      final previousPhrases = <String>[];

      try {
        // Get all course content for this learning path
        final pathContent = await _localDataSource.getPathContent(pathId);

        // Extract vocabularies and phrases from previous courses (exclude current course)
        for (final entry in pathContent.entries) {
          // Skip the current course - only get vocabularies/phrases from previous courses
          if (entry.key < courseNumber) {
            // Extract English vocabularies (only English, not Persian)
            for (final vocab in entry.value.vocabularies) {
              if (vocab.english.isNotEmpty) {
                previousVocabularies.add(vocab.english);
              }
            }

            // Extract English phrases (only English, not Persian)
            for (final phrase in entry.value.phrases) {
              if (phrase.english.isNotEmpty) {
                previousPhrases.add(phrase.english);
              }
            }
          }
        }

        print(
          '✅ [COURSE_CONTENT] Found ${previousVocabularies.length} previous vocabularies and ${previousPhrases.length} previous phrases to avoid duplicates',
        );
      } catch (e) {
        // If fetching previous content fails, continue without it (log but don't fail)
        print(
          '⚠️ [COURSE_CONTENT] Could not fetch previous course content: $e. Continuing without exclusion list.',
        );
      }

      // Generate course-specific lessons using Gemini service with previous vocabularies/phrases
      final aiResponse = await _geminiLessonsService
          .generateCourseLessonResponse(
            learningPath: learningPath,
            courseTitle: course.title,
            courseNumber: courseNumber,
            previousVocabularies: previousVocabularies,
            previousPhrases: previousPhrases,
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
}
