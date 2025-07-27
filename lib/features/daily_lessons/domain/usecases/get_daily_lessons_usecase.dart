// get_daily_lessons_usecase.dart
// Use case for fetching both daily vocabularies and phrases in a single request.
// This use case is more cost-effective than separate requests for vocabularies and phrases.
// Updated to use personalized content based on user preferences.
//
// Usage:
// final useCase = GetDailyLessonsUseCase(repository);
// final preferences = UserPreferences(level: Level.intermediate, focusAreas: ['business']);
// final result = await useCase.call(preferences);
// result.fold(
//   (failure) => print('Error: ${failure.message}'),
//   (data) => print('Vocabularies: ${data.vocabularies.length}, Phrases: ${data.phrases.length}, Tokens: ${data.metadata.totalTokenCount}'),
// );

import 'package:dartz/dartz.dart';
import 'package:learning_english/core/error/failure.dart';
import 'package:learning_english/core/usecase/usecase.dart';
import '../entities/vocabulary.dart';
import '../entities/phrase.dart';
import '../entities/ai_usage_metadata.dart';
import '../entities/user_preferences.dart';
import '../repositories/daily_lessons_repository.dart';

/// Use case for fetching both daily vocabularies and phrases in a single request
/// This approach reduces API costs by ~25-40% compared to separate requests
/// Now includes AI usage metadata for cost tracking and analytics
/// Now uses personalized content based on user preferences
class GetDailyLessonsUseCase
    implements
        UseCase<
          ({
            List<Vocabulary> vocabularies,
            List<Phrase> phrases,
            AiUsageMetadata metadata,
          }),
          UserPreferences
        > {
  final DailyLessonsRepository repository;

  GetDailyLessonsUseCase(this.repository);

  @override
  Future<
    Either<
      Failure,
      ({
        List<Vocabulary> vocabularies,
        List<Phrase> phrases,
        AiUsageMetadata metadata,
      })
    >
  >
  call(UserPreferences preferences) async {
    return await repository.getPersonalizedDailyLessons(preferences);
  }
}
