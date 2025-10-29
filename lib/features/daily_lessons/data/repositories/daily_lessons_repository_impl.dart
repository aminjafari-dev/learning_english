// daily_lessons_repository_impl.dart
// Implementation of DailyLessonsRepository
// Coordinates between local storage, AI services, and learning path management

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
        final existingContent = await _localDataSource.getCourseContent(
          pathId,
          courseNumber,
        );
        if (existingContent != null) {
          return right((
            vocabularies:
                existingContent.vocabularies.map((v) => v.toEntity()).toList(),
            phrases: existingContent.phrases.map((p) => p.toEntity()).toList(),
          ));
        }
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
          // For now, create empty vocabularies and phrases
          // This should be enhanced to parse the AI response and extract content
          final vocabularies = <Vocabulary>[];
          final phrases = <Phrase>[];

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
