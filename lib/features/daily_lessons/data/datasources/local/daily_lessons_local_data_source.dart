// daily_lessons_local_data_source.dart
// Local data source for storing and retrieving vocabulary and phrase data using Hive.
// This handles persistence of AI-generated content with metadata for the current user.

import 'package:hive_flutter/hive_flutter.dart';
import '../../models/vocabulary_model.dart';
import '../../models/phrase_model.dart';
import '../ai_provider_type.dart';

/// Local data source for daily lessons storage using Hive
/// Handles persistence of AI-generated content with metadata for the current user
class DailyLessonsLocalDataSource {
  static const String _vocabulariesBoxName = 'user_vocabularies';
  static const String _phrasesBoxName = 'user_phrases';

  late Box<VocabularyModel> _vocabulariesBox;
  late Box<PhraseModel> _phrasesBox;

  /// Initialize Hive boxes for vocabulary and phrase storage
  /// This method should be called before using any other methods
  Future<void> initialize() async {
    try {
      _vocabulariesBox = await Hive.openBox<VocabularyModel>(
        _vocabulariesBoxName,
      );
      _phrasesBox = await Hive.openBox<PhraseModel>(_phrasesBoxName);
    } catch (e) {
      throw Exception('Failed to initialize Hive boxes: ${e.toString()}');
    }
  }

  /// Saves vocabulary data for the current user
  /// Stores metadata including AI provider, tokens used, and usage status
  Future<void> saveUserVocabulary(VocabularyModel vocabulary) async {
    try {
      // Use English text as the key for easy retrieval and updates
      await _vocabulariesBox.put(vocabulary.english, vocabulary);
    } catch (e) {
      throw Exception('Failed to save vocabulary: ${e.toString()}');
    }
  }

  /// Saves phrase data for the current user
  /// Stores metadata including AI provider, tokens used, and usage status
  Future<void> saveUserPhrase(PhraseModel phrase) async {
    try {
      // Use English text as the key for easy retrieval and updates
      await _phrasesBox.put(phrase.english, phrase);
    } catch (e) {
      throw Exception('Failed to save phrase: ${e.toString()}');
    }
  }

  /// Retrieves all vocabulary data for the current user
  /// Returns list of VocabularyModel with metadata
  Future<List<VocabularyModel>> getUserVocabularies() async {
    try {
      return _vocabulariesBox.values.toList();
    } catch (e) {
      throw Exception('Failed to get user vocabularies: ${e.toString()}');
    }
  }

  /// Retrieves all phrase data for the current user
  /// Returns list of PhraseModel with metadata
  Future<List<PhraseModel>> getUserPhrases() async {
    try {
      return _phrasesBox.values.toList();
    } catch (e) {
      throw Exception('Failed to get user phrases: ${e.toString()}');
    }
  }

  /// Retrieves unused vocabulary for the current user
  /// Used to avoid suggesting previously used content
  Future<List<VocabularyModel>> getUnusedVocabularies() async {
    try {
      return _vocabulariesBox.values.where((vocab) => !vocab.isUsed).toList();
    } catch (e) {
      throw Exception('Failed to get unused vocabularies: ${e.toString()}');
    }
  }

  /// Retrieves unused phrases for the current user
  /// Used to avoid suggesting previously used content
  Future<List<PhraseModel>> getUnusedPhrases() async {
    try {
      return _phrasesBox.values.where((phrase) => !phrase.isUsed).toList();
    } catch (e) {
      throw Exception('Failed to get unused phrases: ${e.toString()}');
    }
  }

  /// Marks vocabulary as used for the current user
  /// Updates the usage status in local storage
  Future<void> markVocabularyAsUsed(String english) async {
    try {
      final vocabulary = _vocabulariesBox.get(english);
      if (vocabulary != null) {
        final updatedVocabulary = vocabulary.copyWith(isUsed: true);
        await _vocabulariesBox.put(english, updatedVocabulary);
      }
    } catch (e) {
      throw Exception('Failed to mark vocabulary as used: ${e.toString()}');
    }
  }

  /// Marks phrase as used for the current user
  /// Updates the usage status in local storage
  Future<void> markPhraseAsUsed(String english) async {
    try {
      final phrase = _phrasesBox.get(english);
      if (phrase != null) {
        final updatedPhrase = phrase.copyWith(isUsed: true);
        await _phrasesBox.put(english, updatedPhrase);
      }
    } catch (e) {
      throw Exception('Failed to mark phrase as used: ${e.toString()}');
    }
  }

  /// Retrieves vocabulary data by AI provider for analytics
  /// Used for analyzing performance and cost by provider
  Future<List<VocabularyModel>> getVocabulariesByProvider(
    AiProviderType provider,
  ) async {
    try {
      return _vocabulariesBox.values
          .where((vocab) => vocab.aiProvider == provider)
          .toList();
    } catch (e) {
      throw Exception(
        'Failed to get vocabularies by provider: ${e.toString()}',
      );
    }
  }

  /// Retrieves phrase data by AI provider for analytics
  /// Used for analyzing performance and cost by provider
  Future<List<PhraseModel>> getPhrasesByProvider(
    AiProviderType provider,
  ) async {
    try {
      return _phrasesBox.values
          .where((phrase) => phrase.aiProvider == provider)
          .toList();
    } catch (e) {
      throw Exception('Failed to get phrases by provider: ${e.toString()}');
    }
  }

  /// Clears all data for the current user
  /// Used when user wants to reset their learning progress
  Future<void> clearUserData() async {
    try {
      await _vocabulariesBox.clear();
      await _phrasesBox.clear();
    } catch (e) {
      throw Exception('Failed to clear user data: ${e.toString()}');
    }
  }

  /// Gets analytics data for the current user
  /// Returns usage statistics and cost analysis
  Future<Map<String, dynamic>> getUserAnalytics() async {
    try {
      final vocabularies = _vocabulariesBox.values.toList();
      final phrases = _phrasesBox.values.toList();

      final totalTokens =
          vocabularies.fold<int>(0, (sum, vocab) => sum + vocab.tokensUsed) +
          phrases.fold<int>(0, (sum, phrase) => sum + phrase.tokensUsed);

      final providerStats = <String, Map<String, dynamic>>{};

      for (final provider in AiProviderType.values) {
        final providerVocabs =
            vocabularies
                .where((vocab) => vocab.aiProvider == provider)
                .toList();
        final providerPhrases =
            phrases.where((phrase) => phrase.aiProvider == provider).toList();

        final providerTokens =
            providerVocabs.fold<int>(
              0,
              (sum, vocab) => sum + vocab.tokensUsed,
            ) +
            providerPhrases.fold<int>(
              0,
              (sum, phrase) => sum + phrase.tokensUsed,
            );

        providerStats[provider.toString()] = {
          'vocabularies': providerVocabs.length,
          'phrases': providerPhrases.length,
          'tokensUsed': providerTokens,
          'usedVocabularies': providerVocabs.where((v) => v.isUsed).length,
          'usedPhrases': providerPhrases.where((p) => p.isUsed).length,
        };
      }

      return {
        'totalVocabularies': vocabularies.length,
        'totalPhrases': phrases.length,
        'totalTokens': totalTokens,
        'usedVocabularies': vocabularies.where((v) => v.isUsed).length,
        'usedPhrases': phrases.where((p) => p.isUsed).length,
        'providerStats': providerStats,
      };
    } catch (e) {
      throw Exception('Failed to get user analytics: ${e.toString()}');
    }
  }

  /// Closes the Hive boxes to free up resources
  /// Should be called when the data source is no longer needed
  Future<void> dispose() async {
    try {
      await _vocabulariesBox.close();
      await _phrasesBox.close();
    } catch (e) {
      throw Exception('Failed to dispose local data source: ${e.toString()}');
    }
  }
}

// Example usage:
// final localDataSource = DailyLessonsLocalDataSource();
// await localDataSource.initialize();
// await localDataSource.saveUserVocabulary(vocabularyModel);
// final userVocabs = await localDataSource.getUserVocabularies();
// final analytics = await localDataSource.getUserAnalytics();
// await localDataSource.dispose();
