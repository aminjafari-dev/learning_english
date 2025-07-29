/// VocabularyHistoryLocalDataSource handles local storage operations for vocabulary history.
/// This data source leverages the existing Hive storage from the daily lessons feature
/// to retrieve vocabulary and phrase data for history display.
///
/// Usage Example:
///   final dataSource = VocabularyHistoryLocalDataSource();
///   await dataSource.initialize();
///   final vocabularies = await dataSource.getAllVocabularies();
///   final phrases = await dataSource.getAllPhrases();
///
/// This data source provides a clean interface for accessing stored learning data
/// and grouping it by request for history display.
import 'package:hive_flutter/hive_flutter.dart';
import '../../../domain/entities/vocabulary_history_item.dart';
import '../../../domain/entities/phrase_history_item.dart';
import '../../../domain/entities/history_request.dart';
import '../../models/vocabulary_history_model.dart';
import '../../models/phrase_history_model.dart';
import '../../models/history_request_model.dart';

/// Local data source for vocabulary history using Hive storage
/// Leverages existing daily lessons storage to provide history functionality
class VocabularyHistoryLocalDataSource {
  static const String _vocabulariesBoxName = 'user_vocabularies';
  static const String _phrasesBoxName = 'user_phrases';

  late Box<dynamic> _vocabulariesBox;
  late Box<dynamic> _phrasesBox;

  /// Initialize Hive boxes for vocabulary and phrase storage
  /// This method should be called before using any other methods
  /// Uses the same boxes as the daily lessons feature
  Future<void> initialize() async {
    try {
      _vocabulariesBox = await Hive.openBox<dynamic>(_vocabulariesBoxName);
      _phrasesBox = await Hive.openBox<dynamic>(_phrasesBoxName);
    } catch (e) {
      throw Exception('Failed to initialize Hive boxes: ${e.toString()}');
    }
  }

  /// Retrieves all vocabulary history items from local storage
  /// Converts stored data to domain entities for the history feature
  Future<List<VocabularyHistoryItem>> getAllVocabularies() async {
    try {
      final vocabularies = <VocabularyHistoryItem>[];

      for (final item in _vocabulariesBox.values) {
        if (item is Map<String, dynamic>) {
          // Convert stored data to domain entity
          final vocabulary = VocabularyHistoryItem(
            english: item['english'] as String,
            persian: item['persian'] as String,
            requestId: item['requestId'] as String,
            createdAt: DateTime.parse(item['createdAt'] as String),
            isUsed: item['isUsed'] as bool? ?? false,
          );
          vocabularies.add(vocabulary);
        }
      }

      return vocabularies;
    } catch (e) {
      throw Exception('Failed to get vocabularies: ${e.toString()}');
    }
  }

  /// Retrieves all phrase history items from local storage
  /// Converts stored data to domain entities for the history feature
  Future<List<PhraseHistoryItem>> getAllPhrases() async {
    try {
      final phrases = <PhraseHistoryItem>[];

      for (final item in _phrasesBox.values) {
        if (item is Map<String, dynamic>) {
          // Convert stored data to domain entity
          final phrase = PhraseHistoryItem(
            english: item['english'] as String,
            persian: item['persian'] as String,
            requestId: item['requestId'] as String,
            createdAt: DateTime.parse(item['createdAt'] as String),
            isUsed: item['isUsed'] as bool? ?? false,
          );
          phrases.add(phrase);
        }
      }

      return phrases;
    } catch (e) {
      throw Exception('Failed to get phrases: ${e.toString()}');
    }
  }

  /// Groups vocabulary and phrase data by request ID to create history requests
  /// This method combines data from both vocabularies and phrases to create
  /// a comprehensive view of each learning request
  Future<List<HistoryRequest>> getHistoryRequests() async {
    try {
      final vocabularies = await getAllVocabularies();
      final phrases = await getAllPhrases();

      // Group by request ID
      final Map<String, List<VocabularyHistoryItem>> vocabGroups = {};
      final Map<String, List<PhraseHistoryItem>> phraseGroups = {};

      // Group vocabularies by request ID
      for (final vocab in vocabularies) {
        vocabGroups.putIfAbsent(vocab.requestId, () => []).add(vocab);
      }

      // Group phrases by request ID
      for (final phrase in phrases) {
        phraseGroups.putIfAbsent(phrase.requestId, () => []).add(phrase);
      }

      // Create history requests
      final Set<String> allRequestIds = {
        ...vocabGroups.keys,
        ...phraseGroups.keys,
      };

      final requests = <HistoryRequest>[];

      for (final requestId in allRequestIds) {
        final requestVocabularies = vocabGroups[requestId] ?? [];
        final requestPhrases = phraseGroups[requestId] ?? [];

        // Find the earliest creation date for this request
        DateTime? earliestDate;
        if (requestVocabularies.isNotEmpty) {
          earliestDate = requestVocabularies
              .map((v) => v.createdAt)
              .reduce((a, b) => a.isBefore(b) ? a : b);
        }
        if (requestPhrases.isNotEmpty) {
          final phraseEarliest = requestPhrases
              .map((p) => p.createdAt)
              .reduce((a, b) => a.isBefore(b) ? a : b);
          if (earliestDate == null || phraseEarliest.isBefore(earliestDate)) {
            earliestDate = phraseEarliest;
          }
        }

        if (earliestDate != null) {
          final request = HistoryRequest(
            requestId: requestId,
            createdAt: earliestDate,
            vocabularies: requestVocabularies,
            phrases: requestPhrases,
          );
          requests.add(request);
        }
      }

      // Sort by creation date (newest first)
      requests.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return requests;
    } catch (e) {
      throw Exception('Failed to get history requests: ${e.toString()}');
    }
  }

  /// Retrieves detailed information for a specific request
  /// Returns a complete HistoryRequest with all vocabularies and phrases
  Future<HistoryRequest> getRequestDetails(String requestId) async {
    try {
      final vocabularies = await getAllVocabularies();
      final phrases = await getAllPhrases();

      // Filter by request ID
      final requestVocabularies =
          vocabularies.where((v) => v.requestId == requestId).toList();

      final requestPhrases =
          phrases.where((p) => p.requestId == requestId).toList();

      // Find the earliest creation date for this request
      DateTime? earliestDate;
      if (requestVocabularies.isNotEmpty) {
        earliestDate = requestVocabularies
            .map((v) => v.createdAt)
            .reduce((a, b) => a.isBefore(b) ? a : b);
      }
      if (requestPhrases.isNotEmpty) {
        final phraseEarliest = requestPhrases
            .map((p) => p.createdAt)
            .reduce((a, b) => a.isBefore(b) ? a : b);
        if (earliestDate == null || phraseEarliest.isBefore(earliestDate)) {
          earliestDate = phraseEarliest;
        }
      }

      if (earliestDate == null) {
        throw Exception('Request not found: $requestId');
      }

      return HistoryRequest(
        requestId: requestId,
        createdAt: earliestDate,
        vocabularies: requestVocabularies,
        phrases: requestPhrases,
      );
    } catch (e) {
      throw Exception('Failed to get request details: ${e.toString()}');
    }
  }

  /// Clears all history data from local storage
  /// This method removes all vocabulary and phrase data
  Future<void> clearHistory() async {
    try {
      await _vocabulariesBox.clear();
      await _phrasesBox.clear();
    } catch (e) {
      throw Exception('Failed to clear history: ${e.toString()}');
    }
  }

  /// Closes the Hive boxes
  /// Should be called when the data source is no longer needed
  Future<void> close() async {
    try {
      await _vocabulariesBox.close();
      await _phrasesBox.close();
    } catch (e) {
      throw Exception('Failed to close Hive boxes: ${e.toString()}');
    }
  }
}
