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
    _vocabulariesBox = await Hive.openBox<VocabularyModel>(
      _vocabulariesBoxName,
    );
    _phrasesBox = await Hive.openBox<PhraseModel>(_phrasesBoxName);
  }

  /// Saves vocabulary data for the current user
  /// Stores metadata including AI provider, tokens used, and usage status
  Future<void> saveUserVocabulary(VocabularyModel vocabulary) async {
    // Use English text as the key for easy retrieval and updates
    await _vocabulariesBox.put(vocabulary.english, vocabulary);
  }

  /// Saves phrase data for the current user
  /// Stores metadata including AI provider, tokens used, and usage status
  Future<void> saveUserPhrase(PhraseModel phrase) async {
    // Use English text as the key for easy retrieval and updates
    await _phrasesBox.put(phrase.english, phrase);
  }

  /// Retrieves all vocabulary data for the current user
  /// Returns list of VocabularyModel with metadata
  Future<List<VocabularyModel>> getUserVocabularies() async {
    return _vocabulariesBox.values.toList();
  }

  /// Retrieves all phrase data for the current user
  /// Returns list of PhraseModel with metadata
  Future<List<PhraseModel>> getUserPhrases() async {
    return _phrasesBox.values.toList();
  }

  /// Retrieves unused vocabulary for the current user
  /// Used to avoid suggesting previously used content
  Future<List<VocabularyModel>> getUnusedVocabularies() async {
    return _vocabulariesBox.values.where((vocab) => !vocab.isUsed).toList();
  }

  /// Retrieves unused phrases for the current user
  /// Used to avoid suggesting previously used content
  Future<List<PhraseModel>> getUnusedPhrases() async {
    return _phrasesBox.values.where((phrase) => !phrase.isUsed).toList();
  }

  /// Marks vocabulary as used for the current user
  /// Updates the usage status in local storage
  Future<void> markVocabularyAsUsed(String english) async {
    final vocabulary = _vocabulariesBox.get(english);
    if (vocabulary != null) {
      final updatedVocabulary = vocabulary.copyWith(isUsed: true);
      await _vocabulariesBox.put(english, updatedVocabulary);
    }
  }

  /// Marks phrase as used for the current user
  /// Updates the usage status in local storage
  Future<void> markPhraseAsUsed(String english) async {
    final phrase = _phrasesBox.get(english);
    if (phrase != null) {
      final updatedPhrase = phrase.copyWith(isUsed: true);
      await _phrasesBox.put(english, updatedPhrase);
    }
  }

  /// Retrieves vocabulary data by AI provider for analytics
  /// Used for analyzing performance and cost by provider
  Future<List<VocabularyModel>> getVocabulariesByProvider(
    AiProviderType provider,
  ) async {
    return _vocabulariesBox.values
        .where((vocab) => vocab.aiProvider == provider)
        .toList();
  }

  /// Retrieves phrase data by AI provider for analytics
  /// Used for analyzing performance and cost by provider
  Future<List<PhraseModel>> getPhrasesByProvider(
    AiProviderType provider,
  ) async {
    return _phrasesBox.values
        .where((phrase) => phrase.aiProvider == provider)
        .toList();
  }

  /// Clears all data for the current user
  /// Used when user wants to reset their learning progress
  Future<void> clearUserData() async {
    await _vocabulariesBox.clear();
    await _phrasesBox.clear();
  }

  /// Gets analytics data for the current user
  /// Returns usage statistics and cost analysis
  Future<Map<String, dynamic>> getUserAnalytics() async {
    final vocabularies = _vocabulariesBox.values.toList();
    final phrases = _phrasesBox.values.toList();

    final totalTokens =
        vocabularies.fold<int>(0, (sum, vocab) => sum + vocab.tokensUsed) +
        phrases.fold<int>(0, (sum, phrase) => sum + phrase.tokensUsed);

    final providerStats = <String, Map<String, dynamic>>{};

    for (final provider in AiProviderType.values) {
      final providerVocabs =
          vocabularies.where((vocab) => vocab.aiProvider == provider).toList();
      final providerPhrases =
          phrases.where((phrase) => phrase.aiProvider == provider).toList();

      final providerTokens =
          providerVocabs.fold<int>(0, (sum, vocab) => sum + vocab.tokensUsed) +
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
  }

  /// Closes the Hive boxes to free up resources
  /// Should be called when the data source is no longer needed
  Future<void> dispose() async {
    await _vocabulariesBox.close();
    await _phrasesBox.close();
  }
}

// Example usage:
// final localDataSource = DailyLessonsLocalDataSource();
// await localDataSource.initialize();
// await localDataSource.saveUserVocabulary(vocabularyModel);
// final userVocabs = await localDataSource.getUserVocabularies();
// final analytics = await localDataSource.getUserAnalytics();
// await localDataSource.dispose();
