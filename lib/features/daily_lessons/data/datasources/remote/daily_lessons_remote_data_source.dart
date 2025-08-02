// daily_lessons_remote_data_source.dart
// Main delegator for AI-based lessons data sources.
// Delegates to the correct provider-specific implementation based on AiProviderType.
// Usage:
// final dataSource = MultiModelLessonsRemoteDataSource(
//   providerType: AiProviderType.openai,
//   openAi: OpenAiLessonsRemoteDataSource(apiKey: 'YOUR_API_KEY'),
//   gemini: GeminiLessonsRemoteDataSource(),
//   deepSeek: DeepSeekLessonsRemoteDataSource(),
// );
// final preferences = UserPreferences(level: Level.intermediate, focusAreas: ['business']);
// final personalizedResult = await dataSource.fetchPersonalizedDailyLessons(preferences);

import 'package:dartz/dartz.dart';
import '../../../domain/entities/vocabulary.dart';
import '../../../domain/entities/phrase.dart';
import '../../../domain/entities/ai_usage_metadata.dart';
import '../../../domain/entities/user_preferences.dart';
import 'package:learning_english/core/error/failure.dart';
import 'ai_lessons_remote_data_source.dart';
import 'openai_lessons_remote_data_source.dart';
import 'gemini_lessons_remote_data_source.dart';
import 'deepseek_lessons_remote_data_source.dart';
import '../../models/ai_provider_type.dart';

/// Delegator for AI-based lessons data sources
/// All methods are personalized based on user preferences
class MultiModelLessonsRemoteDataSource implements AiLessonsRemoteDataSource {
  final AiProviderType providerType;
  final OpenAiLessonsRemoteDataSource openAi;
  final GeminiLessonsRemoteDataSource gemini;
  final DeepSeekLessonsRemoteDataSource deepSeek;

  MultiModelLessonsRemoteDataSource({
    required this.providerType,
    required this.openAi,
    required this.gemini,
    required this.deepSeek,
  });

  AiLessonsRemoteDataSource get _delegate {
    switch (providerType) {
      case AiProviderType.openai:
        return openAi;
      case AiProviderType.gemini:
        return gemini;
      case AiProviderType.deepseek:
        return deepSeek;
    }
  }


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
  fetchPersonalizedDailyLessons(UserPreferences preferences) {
    return _delegate.fetchPersonalizedDailyLessons(preferences);
  }
}
