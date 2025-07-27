// content_sync_manager.dart
// Simplified manager class that directly uses FirebaseLessonsRemoteDataSource
// for saving vocabularies and phrases to Firebase in the background.
//
// Usage:
//   final manager = ContentSyncManager(firebaseDataSource);
//   manager.saveContentToFirebase(vocabularies, phrases, context, userId);

import 'package:learning_english/features/daily_lessons/data/models/vocabulary_model.dart';
import 'package:learning_english/features/daily_lessons/data/models/phrase_model.dart';
import 'package:learning_english/features/daily_lessons/data/datasources/remote/firebase_lessons_remote_data_source.dart';

/// Simplified manager for saving content to Firebase in the background
/// This class provides a clean interface for the main repository to save content
/// without directly depending on Firebase operations
class ContentSyncManager {
  final FirebaseLessonsRemoteDataSource _firebaseDataSource;
  bool _isInitialized = false;

  /// Constructor requires Firebase remote data source instance
  ContentSyncManager({
    required FirebaseLessonsRemoteDataSource firebaseDataSource,
  }) : _firebaseDataSource = firebaseDataSource;

  /// Initializes the content sync manager
  /// This is a simple initialization that just marks the manager as ready
  void initialize() {
    if (_isInitialized) {
      print('⚠️ [SYNC_MANAGER] Already initialized');
      return;
    }

    print('🔄 [SYNC_MANAGER] Initializing content sync manager...');
    _isInitialized = true;
    print('✅ [SYNC_MANAGER] Content sync manager initialized successfully');
  }

  /// Saves newly generated content to Firebase global pool
  /// This method runs Firebase operations in the background without affecting user experience
  ///
  /// Parameters:
  /// - vocabularies: List of newly generated vocabularies
  /// - phrases: List of newly generated phrases
  /// - context: Learning context (level, focus area, difficulty)
  /// - userId: ID of the user who generated the content
  void saveContentToFirebase({
    required List<VocabularyModel> vocabularies,
    required List<PhraseModel> phrases,
    required LearningContext context,
    required String userId,
  }) {
    if (!_isInitialized) {
      print('⚠️ [SYNC_MANAGER] Manager not initialized, skipping save');
      return;
    }

    print(
      '🔄 [SYNC_MANAGER] Starting Firebase save for ${vocabularies.length} vocabularies and ${phrases.length} phrases',
    );
    print('🔄 [SYNC_MANAGER] Context: ${context.toJson()}, User ID: $userId');

    // Run Firebase operations in the background without waiting for completion
    _saveVocabulariesToFirebase(vocabularies, context, userId);
    _savePhrasesToFirebase(phrases, context, userId);
  }

  /// Saves vocabularies to Firebase in the background
  /// This method runs asynchronously without blocking the main thread
  ///
  /// Parameters:
  /// - vocabularies: List of vocabularies to save
  /// - context: Learning context
  /// - userId: User ID
  void _saveVocabulariesToFirebase(
    List<VocabularyModel> vocabularies,
    LearningContext context,
    String userId,
  ) async {
    try {
      print(
        '🔄 [SYNC_MANAGER] Saving ${vocabularies.length} vocabularies to Firebase...',
      );

      for (int i = 0; i < vocabularies.length; i++) {
        final vocabulary = vocabularies[i];
        print(
          '🔄 [SYNC_MANAGER] Saving vocabulary ${i + 1}/${vocabularies.length}: ${vocabulary.english}',
        );

        final result = await _firebaseDataSource.saveVocabularyToGlobalPool(
          vocabulary,
          context,
          userId,
        );

        result.fold(
          (failure) {
            print(
              '❌ [SYNC_MANAGER] Failed to save vocabulary: ${failure.message}',
            );
          },
          (vocabularyId) {
            print(
              '✅ [SYNC_MANAGER] Vocabulary saved successfully: $vocabularyId',
            );
          },
        );
      }

      print('✅ [SYNC_MANAGER] All vocabularies saved to Firebase');
    } catch (e) {
      print('❌ [SYNC_MANAGER] Error saving vocabularies: $e');
    }
  }

  /// Saves phrases to Firebase in the background
  /// This method runs asynchronously without blocking the main thread
  ///
  /// Parameters:
  /// - phrases: List of phrases to save
  /// - context: Learning context
  /// - userId: User ID
  void _savePhrasesToFirebase(
    List<PhraseModel> phrases,
    LearningContext context,
    String userId,
  ) async {
    try {
      print(
        '🔄 [SYNC_MANAGER] Saving ${phrases.length} phrases to Firebase...',
      );

      for (int i = 0; i < phrases.length; i++) {
        final phrase = phrases[i];
        print(
          '🔄 [SYNC_MANAGER] Saving phrase ${i + 1}/${phrases.length}: ${phrase.english}',
        );

        final result = await _firebaseDataSource.savePhraseToGlobalPool(
          phrase,
          context,
          userId,
        );

        result.fold(
          (failure) {
            print('❌ [SYNC_MANAGER] Failed to save phrase: ${failure.message}');
          },
          (phraseId) {
            print('✅ [SYNC_MANAGER] Phrase saved successfully: $phraseId');
          },
        );
      }

      print('✅ [SYNC_MANAGER] All phrases saved to Firebase');
    } catch (e) {
      print('❌ [SYNC_MANAGER] Error saving phrases: $e');
    }
  }

  /// Disposes of the manager and cleans up resources
  /// This should be called when the manager is no longer needed
  void dispose() {
    print('🔄 [SYNC_MANAGER] Disposing content sync manager...');
    _isInitialized = false;
    print('✅ [SYNC_MANAGER] Content sync manager disposed');
  }
}

// Example usage:
// final manager = ContentSyncManager(firebaseDataSource);
// manager.initialize();
//
// // Save content to Firebase in background
// manager.saveContentToFirebase(
//   vocabularies: newVocabularies,
//   phrases: newPhrases,
//   context: learningContext,
//   userId: 'user123',
// );
