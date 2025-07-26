// daily_lessons_local_data_source_test.dart
// Tests for the local data source that handles user-specific vocabulary and phrase storage.

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:learning_english/features/daily_lessons/data/datasources/local/daily_lessons_local_data_source.dart';
import 'package:learning_english/features/daily_lessons/data/models/vocabulary_model.dart';
import 'package:learning_english/features/daily_lessons/data/models/phrase_model.dart';
import 'package:learning_english/features/daily_lessons/data/datasources/ai_provider_type.dart';

void main() {
  group('DailyLessonsLocalDataSource', () {
    late DailyLessonsLocalDataSource dataSource;
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      dataSource = DailyLessonsLocalDataSource(prefs);
    });

    tearDown(() async {
      await prefs.clear();
    });

    group('Vocabulary Operations', () {
      test('should save vocabulary data successfully', () async {
        // Arrange
        final vocabulary = VocabularyModel(
          english: 'Perseverance',
          persian: 'پشتکار',
          userId: 'current_user',
          aiProvider: AiProviderType.openai,
          generatedAt: DateTime.now(),
          tokensUsed: 45,
          requestId: 'req_123',
          isUsed: false,
        );

        // Act
        await dataSource.saveUserVocabulary(vocabulary);

        // Assert
        final savedVocabularies = await dataSource.getUserVocabularies();
        expect(savedVocabularies.length, 1);
        expect(savedVocabularies.first.english, 'Perseverance');
        expect(savedVocabularies.first.persian, 'پشتکار');
        expect(savedVocabularies.first.aiProvider, AiProviderType.openai);
        expect(savedVocabularies.first.tokensUsed, 45);
        expect(savedVocabularies.first.isUsed, false);
      });

      test('should retrieve unused vocabularies only', () async {
        // Arrange
        final usedVocabulary = VocabularyModel(
          english: 'Used Word',
          persian: 'کلمه استفاده شده',
          userId: 'current_user',
          aiProvider: AiProviderType.openai,
          generatedAt: DateTime.now(),
          tokensUsed: 30,
          requestId: 'req_1',
          isUsed: true,
        );

        final unusedVocabulary = VocabularyModel(
          english: 'Unused Word',
          persian: 'کلمه استفاده نشده',
          userId: 'current_user',
          aiProvider: AiProviderType.gemini,
          generatedAt: DateTime.now(),
          tokensUsed: 35,
          requestId: 'req_2',
          isUsed: false,
        );

        await dataSource.saveUserVocabulary(usedVocabulary);
        await dataSource.saveUserVocabulary(unusedVocabulary);

        // Act
        final unusedVocabularies = await dataSource.getUnusedVocabularies();

        // Assert
        expect(unusedVocabularies.length, 1);
        expect(unusedVocabularies.first.english, 'Unused Word');
        expect(unusedVocabularies.first.isUsed, false);
      });

      test('should mark vocabulary as used', () async {
        // Arrange
        final vocabulary = VocabularyModel(
          english: 'Test Word',
          persian: 'کلمه تست',
          userId: 'current_user',
          aiProvider: AiProviderType.openai,
          generatedAt: DateTime.now(),
          tokensUsed: 25,
          requestId: 'req_123',
          isUsed: false,
        );

        await dataSource.saveUserVocabulary(vocabulary);

        // Act
        await dataSource.markVocabularyAsUsed('Test Word');

        // Assert
        final allVocabularies = await dataSource.getUserVocabularies();
        final markedVocabulary = allVocabularies.firstWhere(
          (v) => v.english == 'Test Word',
        );
        expect(markedVocabulary.isUsed, true);
      });

      test(
        'should not mark vocabulary as used if english text does not match',
        () async {
          // Arrange
          final vocabulary = VocabularyModel(
            english: 'Test Word',
            persian: 'کلمه تست',
            userId: 'current_user',
            aiProvider: AiProviderType.openai,
            generatedAt: DateTime.now(),
            tokensUsed: 25,
            requestId: 'req_123',
            isUsed: false,
          );

          await dataSource.saveUserVocabulary(vocabulary);

          // Act
          await dataSource.markVocabularyAsUsed('Different Word');

          // Assert
          final allVocabularies = await dataSource.getUserVocabularies();
          final vocabulary1 = allVocabularies.firstWhere(
            (v) => v.english == 'Test Word',
          );
          expect(vocabulary1.isUsed, false);
        },
      );

      test('should get vocabularies by provider', () async {
        // Arrange
        final openaiVocabulary = VocabularyModel(
          english: 'OpenAI Word',
          persian: 'کلمه OpenAI',
          userId: 'current_user',
          aiProvider: AiProviderType.openai,
          generatedAt: DateTime.now(),
          tokensUsed: 30,
          requestId: 'req_1',
          isUsed: false,
        );

        final geminiVocabulary = VocabularyModel(
          english: 'Gemini Word',
          persian: 'کلمه Gemini',
          userId: 'current_user',
          aiProvider: AiProviderType.gemini,
          generatedAt: DateTime.now(),
          tokensUsed: 35,
          requestId: 'req_2',
          isUsed: false,
        );

        await dataSource.saveUserVocabulary(openaiVocabulary);
        await dataSource.saveUserVocabulary(geminiVocabulary);

        // Act
        final openaiVocabularies = await dataSource.getVocabulariesByProvider(
          AiProviderType.openai,
        );
        final geminiVocabularies = await dataSource.getVocabulariesByProvider(
          AiProviderType.gemini,
        );

        // Assert
        expect(openaiVocabularies.length, 1);
        expect(openaiVocabularies.first.english, 'OpenAI Word');
        expect(openaiVocabularies.first.aiProvider, AiProviderType.openai);

        expect(geminiVocabularies.length, 1);
        expect(geminiVocabularies.first.english, 'Gemini Word');
        expect(geminiVocabularies.first.aiProvider, AiProviderType.gemini);
      });
    });

    group('Phrase Operations', () {
      test('should save phrase data successfully', () async {
        // Arrange
        final phrase = PhraseModel(
          english: 'I owe it to myself',
          persian: 'به اون امیدوارم',
          userId: 'current_user',
          aiProvider: AiProviderType.openai,
          generatedAt: DateTime.now(),
          tokensUsed: 35,
          requestId: 'req_123',
          isUsed: false,
        );

        // Act
        await dataSource.saveUserPhrase(phrase);

        // Assert
        final savedPhrases = await dataSource.getUserPhrases();
        expect(savedPhrases.length, 1);
        expect(savedPhrases.first.english, 'I owe it to myself');
        expect(savedPhrases.first.persian, 'به اون امیدوارم');
        expect(savedPhrases.first.aiProvider, AiProviderType.openai);
        expect(savedPhrases.first.tokensUsed, 35);
        expect(savedPhrases.first.isUsed, false);
      });

      test('should retrieve unused phrases only', () async {
        // Arrange
        final usedPhrase = PhraseModel(
          english: 'Used Phrase',
          persian: 'عبارت استفاده شده',
          userId: 'current_user',
          aiProvider: AiProviderType.openai,
          generatedAt: DateTime.now(),
          tokensUsed: 30,
          requestId: 'req_1',
          isUsed: true,
        );

        final unusedPhrase = PhraseModel(
          english: 'Unused Phrase',
          persian: 'عبارت استفاده نشده',
          userId: 'current_user',
          aiProvider: AiProviderType.gemini,
          generatedAt: DateTime.now(),
          tokensUsed: 35,
          requestId: 'req_2',
          isUsed: false,
        );

        await dataSource.saveUserPhrase(usedPhrase);
        await dataSource.saveUserPhrase(unusedPhrase);

        // Act
        final unusedPhrases = await dataSource.getUnusedPhrases();

        // Assert
        expect(unusedPhrases.length, 1);
        expect(unusedPhrases.first.english, 'Unused Phrase');
        expect(unusedPhrases.first.isUsed, false);
      });

      test('should mark phrase as used', () async {
        // Arrange
        final phrase = PhraseModel(
          english: 'Test Phrase',
          persian: 'عبارت تست',
          userId: 'current_user',
          aiProvider: AiProviderType.openai,
          generatedAt: DateTime.now(),
          tokensUsed: 25,
          requestId: 'req_123',
          isUsed: false,
        );

        await dataSource.saveUserPhrase(phrase);

        // Act
        await dataSource.markPhraseAsUsed('Test Phrase');

        // Assert
        final allPhrases = await dataSource.getUserPhrases();
        final markedPhrase = allPhrases.firstWhere(
          (p) => p.english == 'Test Phrase',
        );
        expect(markedPhrase.isUsed, true);
      });

      test('should get phrases by provider', () async {
        // Arrange
        final openaiPhrase = PhraseModel(
          english: 'OpenAI Phrase',
          persian: 'عبارت OpenAI',
          userId: 'current_user',
          aiProvider: AiProviderType.openai,
          generatedAt: DateTime.now(),
          tokensUsed: 30,
          requestId: 'req_1',
          isUsed: false,
        );

        final geminiPhrase = PhraseModel(
          english: 'Gemini Phrase',
          persian: 'عبارت Gemini',
          userId: 'current_user',
          aiProvider: AiProviderType.gemini,
          generatedAt: DateTime.now(),
          tokensUsed: 35,
          requestId: 'req_2',
          isUsed: false,
        );

        await dataSource.saveUserPhrase(openaiPhrase);
        await dataSource.saveUserPhrase(geminiPhrase);

        // Act
        final openaiPhrases = await dataSource.getPhrasesByProvider(
          AiProviderType.openai,
        );
        final geminiPhrases = await dataSource.getPhrasesByProvider(
          AiProviderType.gemini,
        );

        // Assert
        expect(openaiPhrases.length, 1);
        expect(openaiPhrases.first.english, 'OpenAI Phrase');
        expect(openaiPhrases.first.aiProvider, AiProviderType.openai);

        expect(geminiPhrases.length, 1);
        expect(geminiPhrases.first.english, 'Gemini Phrase');
        expect(geminiPhrases.first.aiProvider, AiProviderType.gemini);
      });
    });

    group('Data Management Operations', () {
      test('should clear all user data', () async {
        // Arrange
        final vocabulary = VocabularyModel(
          english: 'Test Word',
          persian: 'کلمه تست',
          userId: 'current_user',
          aiProvider: AiProviderType.openai,
          generatedAt: DateTime.now(),
          tokensUsed: 25,
          requestId: 'req_123',
          isUsed: false,
        );

        final phrase = PhraseModel(
          english: 'Test Phrase',
          persian: 'عبارت تست',
          userId: 'current_user',
          aiProvider: AiProviderType.openai,
          generatedAt: DateTime.now(),
          tokensUsed: 30,
          requestId: 'req_124',
          isUsed: false,
        );

        await dataSource.saveUserVocabulary(vocabulary);
        await dataSource.saveUserPhrase(phrase);

        // Verify data exists
        expect((await dataSource.getUserVocabularies()).length, 1);
        expect((await dataSource.getUserPhrases()).length, 1);

        // Act
        await dataSource.clearUserData();

        // Assert
        expect((await dataSource.getUserVocabularies()).length, 0);
        expect((await dataSource.getUserPhrases()).length, 0);
      });

      test('should return empty lists when no data exists', () async {
        // Act
        final vocabularies = await dataSource.getUserVocabularies();
        final phrases = await dataSource.getUserPhrases();
        final unusedVocabularies = await dataSource.getUnusedVocabularies();
        final unusedPhrases = await dataSource.getUnusedPhrases();

        // Assert
        expect(vocabularies, isEmpty);
        expect(phrases, isEmpty);
        expect(unusedVocabularies, isEmpty);
        expect(unusedPhrases, isEmpty);
      });
    });

    group('Analytics Operations', () {
      test('should generate correct analytics data', () async {
        // Arrange
        final vocabulary1 = VocabularyModel(
          english: 'Word 1',
          persian: 'کلمه ۱',
          userId: 'current_user',
          aiProvider: AiProviderType.openai,
          generatedAt: DateTime.now(),
          tokensUsed: 30,
          requestId: 'req_1',
          isUsed: true,
        );

        final vocabulary2 = VocabularyModel(
          english: 'Word 2',
          persian: 'کلمه ۲',
          userId: 'current_user',
          aiProvider: AiProviderType.openai,
          generatedAt: DateTime.now(),
          tokensUsed: 35,
          requestId: 'req_2',
          isUsed: false,
        );

        final phrase1 = PhraseModel(
          english: 'Phrase 1',
          persian: 'عبارت ۱',
          userId: 'current_user',
          aiProvider: AiProviderType.gemini,
          generatedAt: DateTime.now(),
          tokensUsed: 40,
          requestId: 'req_3',
          isUsed: true,
        );

        final phrase2 = PhraseModel(
          english: 'Phrase 2',
          persian: 'عبارت ۲',
          userId: 'current_user',
          aiProvider: AiProviderType.gemini,
          generatedAt: DateTime.now(),
          tokensUsed: 45,
          requestId: 'req_4',
          isUsed: false,
        );

        await dataSource.saveUserVocabulary(vocabulary1);
        await dataSource.saveUserVocabulary(vocabulary2);
        await dataSource.saveUserPhrase(phrase1);
        await dataSource.saveUserPhrase(phrase2);

        // Act
        final analytics = await dataSource.getUserAnalytics();

        // Assert
        expect(analytics['totalVocabularies'], 2);
        expect(analytics['totalPhrases'], 2);
        expect(analytics['totalTokens'], 150); // 30 + 35 + 40 + 45
        expect(analytics['usedVocabularies'], 1);
        expect(analytics['usedPhrases'], 1);

        // Check provider stats
        final providerStats =
            analytics['providerStats'] as Map<String, dynamic>;

        final openaiStats =
            providerStats['AiProviderType.openai'] as Map<String, dynamic>;
        expect(openaiStats['vocabularies'], 2);
        expect(openaiStats['phrases'], 0);
        expect(openaiStats['tokensUsed'], 65); // 30 + 35
        expect(openaiStats['usedVocabularies'], 1);
        expect(openaiStats['usedPhrases'], 0);

        final geminiStats =
            providerStats['AiProviderType.gemini'] as Map<String, dynamic>;
        expect(geminiStats['vocabularies'], 0);
        expect(geminiStats['phrases'], 2);
        expect(geminiStats['tokensUsed'], 85); // 40 + 45
        expect(geminiStats['usedVocabularies'], 0);
        expect(geminiStats['usedPhrases'], 1);
      });

      test('should handle analytics with no data', () async {
        // Act
        final analytics = await dataSource.getUserAnalytics();

        // Assert
        expect(analytics['totalVocabularies'], 0);
        expect(analytics['totalPhrases'], 0);
        expect(analytics['totalTokens'], 0);
        expect(analytics['usedVocabularies'], 0);
        expect(analytics['usedPhrases'], 0);

        final providerStats =
            analytics['providerStats'] as Map<String, dynamic>;
        expect(providerStats['AiProviderType.openai']['vocabularies'], 0);
        expect(providerStats['AiProviderType.gemini']['vocabularies'], 0);
        expect(providerStats['AiProviderType.deepseek']['vocabularies'], 0);
      });
    });

    group('Data Persistence', () {
      test('should persist data across multiple saves', () async {
        // Arrange
        final vocabulary1 = VocabularyModel(
          english: 'Word 1',
          persian: 'کلمه ۱',
          userId: 'current_user',
          aiProvider: AiProviderType.openai,
          generatedAt: DateTime.now(),
          tokensUsed: 30,
          requestId: 'req_1',
          isUsed: false,
        );

        final vocabulary2 = VocabularyModel(
          english: 'Word 2',
          persian: 'کلمه ۲',
          userId: 'current_user',
          aiProvider: AiProviderType.gemini,
          generatedAt: DateTime.now(),
          tokensUsed: 35,
          requestId: 'req_2',
          isUsed: false,
        );

        // Act
        await dataSource.saveUserVocabulary(vocabulary1);
        await dataSource.saveUserVocabulary(vocabulary2);

        // Assert
        final vocabularies = await dataSource.getUserVocabularies();
        expect(vocabularies.length, 2);
        expect(
          vocabularies.map((v) => v.english).toList(),
          containsAll(['Word 1', 'Word 2']),
        );
      });

      test('should handle JSON serialization correctly', () async {
        // Arrange
        final vocabulary = VocabularyModel(
          english: 'Test Word',
          persian: 'کلمه تست',
          userId: 'current_user',
          aiProvider: AiProviderType.openai,
          generatedAt: DateTime(2024, 1, 15, 10, 30),
          tokensUsed: 25,
          requestId: 'req_123',
          isUsed: false,
        );

        // Act
        await dataSource.saveUserVocabulary(vocabulary);
        final savedVocabularies = await dataSource.getUserVocabularies();

        // Assert
        expect(savedVocabularies.length, 1);
        final saved = savedVocabularies.first;
        expect(saved.english, vocabulary.english);
        expect(saved.persian, vocabulary.persian);
        expect(saved.aiProvider, vocabulary.aiProvider);
        expect(saved.tokensUsed, vocabulary.tokensUsed);
        expect(saved.requestId, vocabulary.requestId);
        expect(saved.isUsed, vocabulary.isUsed);
        expect(saved.generatedAt.year, 2024);
        expect(saved.generatedAt.month, 1);
        expect(saved.generatedAt.day, 15);
      });
    });
  });
}
