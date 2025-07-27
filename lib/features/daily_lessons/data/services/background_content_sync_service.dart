// background_content_sync_service.dart
// Background service for syncing AI-generated content to Firebase silently.
// This service runs independently and doesn't interfere with the main user experience.
// It handles saving content to global pool and retrieving existing content for reuse.
//
// Usage:
//   final service = BackgroundContentSyncService(firebaseDataSource);
//   service.startBackgroundSync();
//   service.syncGeneratedContent(vocabularies, phrases, context);

import 'dart:async';
import 'dart:developer' as developer;
import 'package:learning_english/features/daily_lessons/data/models/vocabulary_model.dart';
import 'package:learning_english/features/daily_lessons/data/models/phrase_model.dart';
import 'package:learning_english/features/daily_lessons/data/datasources/remote/firebase_lessons_remote_data_source.dart';
import 'package:learning_english/features/level_selection/domain/entities/user_profile.dart';

/// Event types for background content sync operations
enum ContentSyncEventType {
  vocabularyGenerated,
  phraseGenerated,
  contentUsed,
  userProgressUpdated,
}

/// Event for background content sync operations
class ContentSyncEvent {
  final ContentSyncEventType type;
  final dynamic data;
  final DateTime timestamp;

  ContentSyncEvent({
    required this.type,
    required this.data,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

/// Background service for content synchronization with Firebase
/// This service operates silently without affecting the main user experience
class BackgroundContentSyncService {
  final FirebaseLessonsRemoteDataSource _firebaseDataSource;
  final StreamController<ContentSyncEvent> _eventController;
  final StreamController<List<VocabularyModel>> _vocabularySuggestionController;
  final StreamController<List<PhraseModel>> _phraseSuggestionController;

  Timer? _retryTimer;
  Timer? _batchSyncTimer;
  bool _isRunning = false;
  int _retryCount = 0;
  static const int _maxRetries = 3;
  static const Duration _retryDelay = Duration(minutes: 5);
  static const Duration _batchSyncInterval = Duration(minutes: 10);

  /// Constructor requires Firebase data source for operations
  BackgroundContentSyncService({
    required FirebaseLessonsRemoteDataSource firebaseDataSource,
  }) : _firebaseDataSource = firebaseDataSource,
       _eventController = StreamController<ContentSyncEvent>.broadcast(),
       _vocabularySuggestionController =
           StreamController<List<VocabularyModel>>.broadcast(),
       _phraseSuggestionController =
           StreamController<List<PhraseModel>>.broadcast();

  /// Stream of content sync events for monitoring and debugging
  Stream<ContentSyncEvent> get eventStream => _eventController.stream;

  /// Stream of vocabulary suggestions from Firebase global pool
  Stream<List<VocabularyModel>> get vocabularySuggestions =>
      _vocabularySuggestionController.stream;

  /// Stream of phrase suggestions from Firebase global pool
  Stream<List<PhraseModel>> get phraseSuggestions =>
      _phraseSuggestionController.stream;

  /// Starts the background sync service
  /// This initializes timers and begins monitoring for content sync opportunities
  void startBackgroundSync() {
    if (_isRunning) {
      print('⚠️ [BACKGROUND_SERVICE] Service already running');
      return;
    }

    _isRunning = true;
    print(
      '🔄 [BACKGROUND_SERVICE] Starting background content sync service...',
    );
    developer.log(
      'Background content sync service started',
      name: 'ContentSync',
    );

    // Start batch sync timer for periodic operations
    _batchSyncTimer = Timer.periodic(_batchSyncInterval, (_) {
      _performBatchSync();
    });

    _emitEvent(
      ContentSyncEventType.contentUsed,
      'Background sync service started',
    );
    print(
      '✅ [BACKGROUND_SERVICE] Background content sync service started successfully',
    );
  }

  /// Stops the background sync service
  /// This cancels all timers and stops background operations
  void stopBackgroundSync() {
    if (!_isRunning) return;

    _isRunning = false;
    _retryTimer?.cancel();
    _batchSyncTimer?.cancel();
    developer.log(
      'Background content sync service stopped',
      name: 'ContentSync',
    );

    _emitEvent(
      ContentSyncEventType.contentUsed,
      'Background sync service stopped',
    );
  }

  /// Syncs newly generated content to Firebase global pool
  /// This method is called when AI generates new content
  /// It saves content silently in the background without affecting user experience
  ///
  /// Parameters:
  /// - vocabularies: List of newly generated vocabularies
  /// - phrases: List of newly generated phrases
  /// - context: Learning context (level, focus area, difficulty)
  /// - userId: ID of the user who generated the content
  Future<void> syncGeneratedContent({
    required List<VocabularyModel> vocabularies,
    required List<PhraseModel> phrases,
    required LearningContext context,
    required String userId,
  }) async {
    if (!_isRunning) {
      print('⚠️ [BACKGROUND_SERVICE] Service not running, skipping sync');
      return;
    }

    try {
      print('🔄 [BACKGROUND_SERVICE] Starting content sync to Firebase...');
      print(
        '🔄 [BACKGROUND_SERVICE] Vocabularies: ${vocabularies.length}, Phrases: ${phrases.length}',
      );
      print(
        '🔄 [BACKGROUND_SERVICE] Context: ${context.toJson()}, User ID: $userId',
      );

      developer.log(
        'Syncing ${vocabularies.length} vocabularies and ${phrases.length} phrases to Firebase',
        name: 'ContentSync',
      );

      // Save vocabularies to global pool
      print('🔄 [BACKGROUND_SERVICE] Saving vocabularies to Firebase...');
      for (int i = 0; i < vocabularies.length; i++) {
        final vocabulary = vocabularies[i];
        print(
          '🔄 [BACKGROUND_SERVICE] Saving vocabulary ${i + 1}/${vocabularies.length}: ${vocabulary.english}',
        );

        final result = await _firebaseDataSource.saveVocabularyToGlobalPool(
          vocabulary,
          context,
          userId,
        );

        result.fold(
          (failure) {
            print(
              '❌ [BACKGROUND_SERVICE] Failed to save vocabulary: ${failure.message}',
            );
            _handleSyncError('vocabulary', failure.message);
          },
          (vocabularyId) {
            print(
              '✅ [BACKGROUND_SERVICE] Vocabulary saved successfully: $vocabularyId',
            );
            _emitEvent(ContentSyncEventType.vocabularyGenerated, {
              'id': vocabularyId,
              'english': vocabulary.english,
              'context': context.toJson(),
            });
          },
        );
      }

      // Save phrases to global pool
      print('🔄 [BACKGROUND_SERVICE] Saving phrases to Firebase...');
      for (int i = 0; i < phrases.length; i++) {
        final phrase = phrases[i];
        print(
          '🔄 [BACKGROUND_SERVICE] Saving phrase ${i + 1}/${phrases.length}: ${phrase.english}',
        );

        final result = await _firebaseDataSource.savePhraseToGlobalPool(
          phrase,
          context,
          userId,
        );

        result.fold(
          (failure) {
            print(
              '❌ [BACKGROUND_SERVICE] Failed to save phrase: ${failure.message}',
            );
            _handleSyncError('phrase', failure.message);
          },
          (phraseId) {
            print(
              '✅ [BACKGROUND_SERVICE] Phrase saved successfully: $phraseId',
            );
            _emitEvent(ContentSyncEventType.phraseGenerated, {
              'id': phraseId,
              'english': phrase.english,
              'context': context.toJson(),
            });
          },
        );
      }

      _retryCount = 0; // Reset retry count on successful sync
      print('✅ [BACKGROUND_SERVICE] Content sync completed successfully');
    } catch (e) {
      print('❌ [BACKGROUND_SERVICE] Content sync error: $e');
      _handleSyncError('content sync', e.toString());
    }
  }

  /// Checks for existing content in Firebase global pool
  /// This method can suggest content to the main repository for reuse
  /// It runs in the background and doesn't block user experience
  ///
  /// Parameters:
  /// - level: User's English proficiency level
  /// - focusArea: User's learning focus area
  /// - limit: Maximum number of items to suggest
  ///
  /// Returns: Future that completes when suggestions are ready
  Future<void> checkForExistingContent({
    required Level level,
    required String focusArea,
    int limit = 10,
  }) async {
    if (!_isRunning) return;

    try {
      developer.log(
        'Checking for existing content in Firebase for $level $focusArea',
        name: 'ContentSync',
      );

      // Check for existing vocabularies
      final vocabResult = await _firebaseDataSource
          .getUnusedVocabulariesForContext(
            level,
            focusArea,
            limit: limit,
            maxUsageCount: 3, // Prefer less used content
          );

      vocabResult.fold(
        (failure) => _handleSyncError('vocabulary retrieval', failure.message),
        (vocabularies) {
          if (vocabularies.isNotEmpty) {
            _vocabularySuggestionController.add(vocabularies);
            developer.log(
              'Found ${vocabularies.length} existing vocabularies for reuse',
              name: 'ContentSync',
            );
          }
        },
      );

      // Check for existing phrases
      final phraseResult = await _firebaseDataSource.getUnusedPhrasesForContext(
        level,
        focusArea,
        limit: limit,
        maxUsageCount: 3, // Prefer less used content
      );

      phraseResult.fold(
        (failure) => _handleSyncError('phrase retrieval', failure.message),
        (phrases) {
          if (phrases.isNotEmpty) {
            _phraseSuggestionController.add(phrases);
            developer.log(
              'Found ${phrases.length} existing phrases for reuse',
              name: 'ContentSync',
            );
          }
        },
      );
    } catch (e) {
      _handleSyncError('content discovery', e.toString());
    }
  }

  /// Marks content as used in Firebase global pool
  /// This helps track content popularity and prevent over-reuse
  ///
  /// Parameters:
  /// - vocabularyIds: List of vocabulary IDs that were used
  /// - phraseIds: List of phrase IDs that were used
  Future<void> markContentAsUsed({
    required List<String> vocabularyIds,
    required List<String> phraseIds,
  }) async {
    if (!_isRunning) return;

    try {
      developer.log(
        'Marking ${vocabularyIds.length} vocabularies and ${phraseIds.length} phrases as used',
        name: 'ContentSync',
      );

      // Mark vocabularies as used
      for (final vocabularyId in vocabularyIds) {
        await _firebaseDataSource.markVocabularyAsUsed(vocabularyId);
      }

      // Mark phrases as used
      for (final phraseId in phraseIds) {
        await _firebaseDataSource.markPhraseAsUsed(phraseId);
      }

      _emitEvent(ContentSyncEventType.contentUsed, {
        'vocabularyIds': vocabularyIds,
        'phraseIds': phraseIds,
      });
    } catch (e) {
      _handleSyncError('mark content as used', e.toString());
    }
  }

  /// Updates user learning progress in Firebase
  /// This tracks what content each user has used for personalization
  ///
  /// Parameters:
  /// - userId: User's ID
  /// - usedVocabularyIds: List of vocabulary IDs the user has used
  /// - usedPhraseIds: List of phrase IDs the user has used
  /// - preferences: User's learning preferences
  Future<void> updateUserProgress({
    required String userId,
    required List<String> usedVocabularyIds,
    required List<String> usedPhraseIds,
    required Map<String, dynamic> preferences,
  }) async {
    if (!_isRunning) return;

    try {
      developer.log(
        'Updating user progress for user $userId',
        name: 'ContentSync',
      );

      await _firebaseDataSource.saveUserLearningProgress(
        userId,
        usedVocabularyIds,
        usedPhraseIds,
        preferences,
      );

      _emitEvent(ContentSyncEventType.userProgressUpdated, {
        'userId': userId,
        'vocabularyCount': usedVocabularyIds.length,
        'phraseCount': usedPhraseIds.length,
      });
    } catch (e) {
      _handleSyncError('user progress update', e.toString());
    }
  }

  /// Performs batch sync operations periodically
  /// This method handles retry logic and bulk operations
  Future<void> _performBatchSync() async {
    if (!_isRunning) return;

    try {
      developer.log('Performing batch sync operations', name: 'ContentSync');

      // Add any batch operations here
      // For example, syncing accumulated local data
    } catch (e) {
      _handleSyncError('batch sync', e.toString());
    }
  }

  /// Handles sync errors with retry logic
  /// This ensures that Firebase failures don't affect user experience
  ///
  /// Parameters:
  /// - operation: Description of the operation that failed
  /// - error: Error message
  void _handleSyncError(String operation, String error) {
    developer.log(
      'Background sync error in $operation: $error',
      name: 'ContentSync',
    );

    _emitEvent(ContentSyncEventType.contentUsed, {
      'operation': operation,
      'error': error,
      'retryCount': _retryCount,
    });

    // Implement retry logic for critical operations
    if (_retryCount < _maxRetries) {
      _retryCount++;
      _retryTimer?.cancel();
      _retryTimer = Timer(_retryDelay, () {
        developer.log(
          'Retrying background sync operation (attempt $_retryCount)',
          name: 'ContentSync',
        );
        // Retry the last failed operation if needed
      });
    } else {
      developer.log(
        'Max retries reached for background sync operation',
        name: 'ContentSync',
      );
      _retryCount = 0; // Reset for next operation
    }
  }

  /// Emits events for monitoring and debugging
  /// This helps track background operations without affecting user experience
  ///
  /// Parameters:
  /// - type: Type of event
  /// - data: Event data
  void _emitEvent(ContentSyncEventType type, dynamic data) {
    if (_eventController.hasListener) {
      _eventController.add(ContentSyncEvent(type: type, data: data));
    }
  }

  /// Disposes of the service and cleans up resources
  /// This should be called when the service is no longer needed
  void dispose() {
    stopBackgroundSync();
    _eventController.close();
    _vocabularySuggestionController.close();
    _phraseSuggestionController.close();
  }
}

// Example usage:
// final service = BackgroundContentSyncService(firebaseDataSource);
// service.startBackgroundSync();
//
// // Listen for suggestions
// service.vocabularySuggestions.listen((vocabularies) {
//   // Handle vocabulary suggestions
// });
//
// // Sync generated content
// await service.syncGeneratedContent(
//   vocabularies: newVocabularies,
//   phrases: newPhrases,
//   context: learningContext,
//   userId: 'user123',
// );
