// daily_lessons_local_data_source.dart
// Local data source for storing and retrieving vocabulary and phrase data.
// This handles persistence of AI-generated content with metadata for the current user.

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/vocabulary_model.dart';
import '../../models/phrase_model.dart';
import '../ai_provider_type.dart';

/// Local data source for daily lessons storage
/// Handles persistence of AI-generated content with metadata for the current user
class DailyLessonsLocalDataSource {
  static const String _vocabulariesKey = 'user_vocabularies';
  static const String _phrasesKey = 'user_phrases';

  final SharedPreferences _prefs;

  DailyLessonsLocalDataSource(this._prefs);

  /// Saves vocabulary data for the current user
  /// Stores metadata including AI provider, tokens used, and usage status
  Future<void> saveUserVocabulary(VocabularyModel vocabulary) async {
    final existingData = _prefs.getStringList(_vocabulariesKey) ?? [];

    // Add new vocabulary to existing list
    existingData.add(jsonEncode(vocabulary.toJson()));

    await _prefs.setStringList(_vocabulariesKey, existingData);
  }

  /// Saves phrase data for the current user
  /// Stores metadata including AI provider, tokens used, and usage status
  Future<void> saveUserPhrase(PhraseModel phrase) async {
    final existingData = _prefs.getStringList(_phrasesKey) ?? [];

    // Add new phrase to existing list
    existingData.add(jsonEncode(phrase.toJson()));

    await _prefs.setStringList(_phrasesKey, existingData);
  }

  /// Retrieves all vocabulary data for the current user
  /// Returns list of VocabularyModel with metadata
  Future<List<VocabularyModel>> getUserVocabularies() async {
    final data = _prefs.getStringList(_vocabulariesKey) ?? [];

    return data
        .map((jsonString) => VocabularyModel.fromJson(jsonDecode(jsonString)))
        .toList();
  }

  /// Retrieves all phrase data for the current user
  /// Returns list of PhraseModel with metadata
  Future<List<PhraseModel>> getUserPhrases() async {
    final data = _prefs.getStringList(_phrasesKey) ?? [];

    return data
        .map((jsonString) => PhraseModel.fromJson(jsonDecode(jsonString)))
        .toList();
  }

  /// Retrieves unused vocabulary for the current user
  /// Used to avoid suggesting previously used content
  Future<List<VocabularyModel>> getUnusedVocabularies() async {
    final allVocabularies = await getUserVocabularies();
    return allVocabularies.where((vocab) => !vocab.isUsed).toList();
  }

  /// Retrieves unused phrases for the current user
  /// Used to avoid suggesting previously used content
  Future<List<PhraseModel>> getUnusedPhrases() async {
    final allPhrases = await getUserPhrases();
    return allPhrases.where((phrase) => !phrase.isUsed).toList();
  }

  /// Marks vocabulary as used for the current user
  /// Updates the usage status in local storage
  Future<void> markVocabularyAsUsed(String english) async {
    final data = _prefs.getStringList(_vocabulariesKey) ?? [];

    final updatedData =
        data.map((jsonString) {
          final vocab = VocabularyModel.fromJson(jsonDecode(jsonString));
          if (vocab.english == english) {
            return jsonEncode(vocab.copyWith(isUsed: true).toJson());
          }
          return jsonString;
        }).toList();

    await _prefs.setStringList(_vocabulariesKey, updatedData);
  }

  /// Marks phrase as used for the current user
  /// Updates the usage status in local storage
  Future<void> markPhraseAsUsed(String english) async {
    final data = _prefs.getStringList(_phrasesKey) ?? [];

    final updatedData =
        data.map((jsonString) {
          final phrase = PhraseModel.fromJson(jsonDecode(jsonString));
          if (phrase.english == english) {
            return jsonEncode(phrase.copyWith(isUsed: true).toJson());
          }
          return jsonString;
        }).toList();

    await _prefs.setStringList(_phrasesKey, updatedData);
  }

  /// Retrieves vocabulary data by AI provider for analytics
  /// Used for analyzing performance and cost by provider
  Future<List<VocabularyModel>> getVocabulariesByProvider(
    AiProviderType provider,
  ) async {
    final allVocabularies = await getUserVocabularies();
    return allVocabularies
        .where((vocab) => vocab.aiProvider == provider)
        .toList();
  }

  /// Retrieves phrase data by AI provider for analytics
  /// Used for analyzing performance and cost by provider
  Future<List<PhraseModel>> getPhrasesByProvider(
    AiProviderType provider,
  ) async {
    final allPhrases = await getUserPhrases();
    return allPhrases.where((phrase) => phrase.aiProvider == provider).toList();
  }

  /// Clears all data for the current user
  /// Used when user wants to reset their learning progress
  Future<void> clearUserData() async {
    await _prefs.remove(_vocabulariesKey);
    await _prefs.remove(_phrasesKey);
  }

  /// Gets analytics data for the current user
  /// Returns usage statistics and cost analysis
  Future<Map<String, dynamic>> getUserAnalytics() async {
    final vocabularies = await getUserVocabularies();
    final phrases = await getUserPhrases();

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
}

// Example usage:
// final localDataSource = DailyLessonsLocalDataSource(prefs);
// await localDataSource.saveUserVocabulary(vocabularyModel);
// final userVocabs = await localDataSource.getUserVocabularies();
// final analytics = await localDataSource.getUserAnalytics();
