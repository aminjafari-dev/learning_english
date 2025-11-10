import 'package:flutter_test/flutter_test.dart';
import 'package:learning_english/features/course/data/models/ai_provider_type.dart';
import 'package:learning_english/features/course/data/models/learning_request_model.dart';
import 'package:learning_english/features/course/data/models/vocabulary_model.dart';
import 'package:learning_english/features/course/data/models/phrase_model.dart';
import 'package:learning_english/features/course/data/models/level_type.dart';
import 'package:learning_english/features/course/domain/entities/learning_request.dart';
import 'package:learning_english/features/course/domain/entities/vocabulary.dart';
import 'package:learning_english/features/course/domain/entities/phrase.dart';

void main() {
  group('LearningRequestModel.fromEntity', () {
    test('preserves all core fields and converts nested content', () {
      // Arrange: Build a domain entity that includes nested vocab/phrase data.
      const vocabularies = [Vocabulary(english: 'ticket', persian: 'بلیت')];
      const phrases = [
        Phrase(english: 'Where is the gate?', persian: 'دروازه کجاست؟'),
      ];

      final request = LearningRequest(
        requestId: 'req_1',
        userId: 'user_42',
        userLevel: UserLevel.intermediate,
        focusAreas: const ['travel'],
        aiProvider: AiProviderType.gemini,
        aiModel: 'gemini-2.5-flash',
        totalTokensUsed: 1200,
        estimatedCost: 0.45,
        requestTimestamp: DateTime(2024, 5, 1, 10),
        createdAt: DateTime(2024, 5, 1, 10, 30),
        systemPrompt: 'system prompt',
        userPrompt: 'user prompt',
        errorMessage: null,
        vocabularies: vocabularies,
        phrases: phrases,
        metadata: const {'source': 'unit-test'},
      );

      // Act: Convert to data model.
      final model = LearningRequestModel.fromEntity(request);

      // Assert: Scalar fields are copied straight across.
      expect(model.requestId, request.requestId);
      expect(model.userId, request.userId);
      expect(model.userLevel, request.userLevel);
      expect(model.focusAreas, request.focusAreas);
      expect(model.aiProvider, request.aiProvider);
      expect(model.aiModel, request.aiModel);
      expect(model.totalTokensUsed, request.totalTokensUsed);
      expect(model.estimatedCost, request.estimatedCost);
      expect(model.requestTimestamp, request.requestTimestamp);
      expect(model.createdAt, request.createdAt);
      expect(model.systemPrompt, request.systemPrompt);
      expect(model.userPrompt, request.userPrompt);
      expect(model.errorMessage, request.errorMessage);
      expect(model.metadata, request.metadata);

      // And nested lists are converted to the data models with default flags.
      expect(model.vocabularies, hasLength(1));
      expect(model.vocabularies.first, isA<VocabularyModel>());
      expect(model.vocabularies.first.english, vocabularies.first.english);
      expect(model.vocabularies.first.persian, vocabularies.first.persian);
      expect(model.vocabularies.first.isUsed, isFalse);

      expect(model.phrases, hasLength(1));
      expect(model.phrases.first, isA<PhraseModel>());
      expect(model.phrases.first.english, phrases.first.english);
      expect(model.phrases.first.persian, phrases.first.persian);
      expect(model.phrases.first.isUsed, isFalse);
    });
  });

  group('LearningRequestModel.toEntity', () {
    test('reconstructs the original domain entity values', () {
      // Arrange: Build the model the same way storage would.
      final model = LearningRequestModel(
        requestId: 'req_2',
        userId: 'user_10',
        userLevel: UserLevel.beginner,
        focusAreas: const ['conversation', 'vocabulary'],
        aiProvider: AiProviderType.openai,
        aiModel: 'gpt-4o-mini',
        totalTokensUsed: 640,
        estimatedCost: 0.15,
        requestTimestamp: DateTime(2024, 6, 10, 9),
        createdAt: DateTime(2024, 6, 10, 9, 5),
        systemPrompt: 'be a tutor',
        userPrompt: 'create lesson',
        errorMessage: 'timeout',
        vocabularies: const [
          VocabularyModel(english: 'lesson', persian: 'درس', isUsed: true),
        ],
        phrases: [
          PhraseModel(
            english: 'Good morning',
            persian: 'صبح بخیر',
            isUsed: false,
          ),
        ],
        metadata: const {'retry': 1},
      );

      // Act: Convert back to the domain entity.
      final entity = model.toEntity();

      // Assert: Every field matches what the app would expect at the domain layer.
      expect(entity.requestId, model.requestId);
      expect(entity.userId, model.userId);
      expect(entity.userLevel, model.userLevel);
      expect(entity.focusAreas, model.focusAreas);
      expect(entity.aiProvider, model.aiProvider);
      expect(entity.aiModel, model.aiModel);
      expect(entity.totalTokensUsed, model.totalTokensUsed);
      expect(entity.estimatedCost, model.estimatedCost);
      expect(entity.requestTimestamp, model.requestTimestamp);
      expect(entity.createdAt, model.createdAt);
      expect(entity.systemPrompt, model.systemPrompt);
      expect(entity.userPrompt, model.userPrompt);
      expect(entity.errorMessage, model.errorMessage);
      expect(entity.metadata, model.metadata);

      // Nested content comes back as domain entities (not the Hive models).
      expect(entity.vocabularies, hasLength(1));
      expect(entity.vocabularies.first, isA<Vocabulary>());
      expect(
        entity.vocabularies.first.english,
        model.vocabularies.first.english,
      );
      expect(
        entity.vocabularies.first.persian,
        model.vocabularies.first.persian,
      );

      expect(entity.phrases, hasLength(1));
      expect(entity.phrases.first, isA<Phrase>());
      expect(entity.phrases.first.english, model.phrases.first.english);
      expect(entity.phrases.first.persian, model.phrases.first.persian);
    });
  });
}
