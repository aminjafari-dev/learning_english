// firebase_lessons_remote_data_source.dart
// Firebase remote data source for saving and retrieving vocabularies and phrases
// with context-aware structure (user level and learning focus area).
// This class handles saving AI-generated content to Firebase for reuse across users.
//
// Usage:
//   final dataSource = FirebaseLessonsRemoteDataSource(firestore);
//   await dataSource.saveVocabularyToGlobalPool(vocabularyModel, context);
//   final vocabularies = await dataSource.getUnusedVocabulariesForContext(level, focusArea);

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:learning_english/core/error/failure.dart';
import 'package:learning_english/features/daily_lessons/data/models/vocabulary_model.dart';
import 'package:learning_english/features/daily_lessons/data/models/phrase_model.dart';
import 'package:learning_english/features/daily_lessons/data/datasources/ai_provider_type.dart';
import 'package:learning_english/features/level_selection/domain/entities/user_profile.dart';

/// Learning context for categorizing content by user level and focus area
/// This helps in organizing and retrieving content based on user preferences
class LearningContext {
  final Level level;
  final String focusArea;
  final String difficulty;

  const LearningContext({
    required this.level,
    required this.focusArea,
    required this.difficulty,
  });

  /// Converts LearningContext to JSON for Firebase storage
  Map<String, dynamic> toJson() => {
    'level': level.name,
    'focusArea': focusArea,
    'difficulty': difficulty,
  };

  /// Creates LearningContext from JSON
  factory LearningContext.fromJson(Map<String, dynamic> json) =>
      LearningContext(
        level: Level.values.firstWhere(
          (e) => e.name == json['level'],
          orElse: () => Level.beginner,
        ),
        focusArea: json['focusArea'] as String,
        difficulty: json['difficulty'] as String,
      );
}

/// Firebase remote data source for lessons content management
/// Handles saving and retrieving vocabularies and phrases with context-aware structure
class FirebaseLessonsRemoteDataSource {
  final FirebaseFirestore firestore;

  /// Constructor requires FirebaseFirestore instance
  /// This allows for dependency injection and easier testing
  FirebaseLessonsRemoteDataSource({required this.firestore});

  /// Saves vocabulary to global content pool for reuse across users
  /// The vocabulary is categorized by learning context (level, focus area, difficulty)
  /// This enables smart content discovery and cost optimization
  ///
  /// Parameters:
  /// - vocabularyModel: The vocabulary model with essential data
  /// - context: Learning context (level, focus area, difficulty)
  /// - createdBy: User ID who generated this content
  /// - metadata: Additional metadata for tracking (aiProvider, tokensUsed, etc.)
  ///
  /// Returns: Either Failure or the saved vocabulary ID
  Future<Either<Failure, String>> saveVocabularyToGlobalPool(
    VocabularyModel vocabularyModel,
    LearningContext context,
    String createdBy, {
    AiProviderType aiProvider = AiProviderType.openai,
    int tokensUsed = 0,
    String requestId = '',
    DateTime? createdAt,
  }) async {
    try {
      print(
        '🔄 [FIREBASE] Saving vocabulary to global pool: ${vocabularyModel.english}',
      );
      print(
        '🔄 [FIREBASE] Context: ${context.toJson()}, Created by: $createdBy',
      );

      final docRef =
          firestore
              .collection('global_content')
              .doc('vocabularies')
              .collection('items')
              .doc();

      final data = {
        'english': vocabularyModel.english,
        'persian': vocabularyModel.persian,
        'aiProvider': aiProvider.name,
        'tokensUsed': tokensUsed,
        'requestId': requestId,
        'createdAt': (createdAt ?? DateTime.now()).toIso8601String(),
        'model': 'gpt-3.5-turbo', // Default model, can be made dynamic
        'cost': _calculateCost(tokensUsed, aiProvider),
        'context': context.toJson(),
        'usageCount': 0, // Initially unused
        'createdBy': createdBy,
        'quality': 0.0, // Will be updated based on user ratings
        'ratingCount': 0,
        'tags': _generateTags(context, vocabularyModel.english),
        'lastUsedAt': null,
      };

      print('🔄 [FIREBASE] Setting document data...');
      await docRef.set(data);

      final docId = docRef.id;
      print('✅ [FIREBASE] Vocabulary saved successfully with ID: $docId');
      return right(docId);
    } catch (e) {
      print('❌ [FIREBASE] Failed to save vocabulary: $e');
      return left(
        ServerFailure(
          'Failed to save vocabulary to global pool: ${e.toString()}',
        ),
      );
    }
  }

  /// Saves phrase to global content pool for reuse across users
  /// Similar to saveVocabularyToGlobalPool but for phrases
  ///
  /// Parameters:
  /// - phraseModel: The phrase model with essential data
  /// - context: Learning context (level, focus area, difficulty)
  /// - createdBy: User ID who generated this content
  /// - metadata: Additional metadata for tracking (aiProvider, tokensUsed, etc.)
  ///
  /// Returns: Either Failure or the saved phrase ID
  Future<Either<Failure, String>> savePhraseToGlobalPool(
    PhraseModel phraseModel,
    LearningContext context,
    String createdBy, {
    AiProviderType aiProvider = AiProviderType.openai,
    int tokensUsed = 0,
    String requestId = '',
    DateTime? createdAt,
  }) async {
    try {
      print(
        '🔄 [FIREBASE] Saving phrase to global pool: ${phraseModel.english}',
      );
      print(
        '🔄 [FIREBASE] Context: ${context.toJson()}, Created by: $createdBy',
      );

      final docRef =
          firestore
              .collection('global_content')
              .doc('phrases')
              .collection('items')
              .doc();

      final data = {
        'english': phraseModel.english,
        'persian': phraseModel.persian,
        'aiProvider': aiProvider.name,
        'tokensUsed': tokensUsed,
        'requestId': requestId,
        'createdAt': (createdAt ?? DateTime.now()).toIso8601String(),
        'model': 'gpt-3.5-turbo', // Default model, can be made dynamic
        'cost': _calculateCost(tokensUsed, aiProvider),
        'context': context.toJson(),
        'usageCount': 0, // Initially unused
        'createdBy': createdBy,
        'quality': 0.0, // Will be updated based on user ratings
        'ratingCount': 0,
        'tags': _generateTags(context, phraseModel.english),
        'lastUsedAt': null,
      };

      print('🔄 [FIREBASE] Setting phrase document data...');
      await docRef.set(data);

      final docId = docRef.id;
      print('✅ [FIREBASE] Phrase saved successfully with ID: $docId');
      return right(docId);
    } catch (e) {
      print('❌ [FIREBASE] Failed to save phrase: $e');
      return left(
        ServerFailure('Failed to save phrase to global pool: ${e.toString()}'),
      );
    }
  }

  /// Retrieves unused vocabularies for specific learning context
  /// This method enables content reuse and cost optimization
  ///
  /// Parameters:
  /// - level: User's English proficiency level
  /// - focusArea: User's learning focus area (e.g., "business", "travel")
  /// - limit: Maximum number of vocabularies to return
  /// - maxUsageCount: Maximum usage count to consider as "unused"
  ///
  /// Returns: Either Failure or list of unused vocabularies
  Future<Either<Failure, List<VocabularyModel>>>
  getUnusedVocabulariesForContext(
    Level level,
    String focusArea, {
    int limit = 10,
    int maxUsageCount = 5,
  }) async {
    try {
      final querySnapshot =
          await firestore
              .collection('global_content')
              .doc('vocabularies')
              .collection('items')
              .where('context.level', isEqualTo: level.name)
              .where('context.focusArea', isEqualTo: focusArea)
              .where('usageCount', isLessThan: maxUsageCount)
              .orderBy('usageCount')
              .orderBy('quality', descending: true)
              .limit(limit)
              .get();

      final vocabularies =
          querySnapshot.docs.map((doc) {
            final data = doc.data();
            return VocabularyModel(
              english: data['english'] as String,
              persian: data['persian'] as String,
              isUsed: false, // These are unused vocabularies
            );
          }).toList();

      return right(vocabularies);
    } catch (e) {
      return left(
        ServerFailure('Failed to get unused vocabularies: ${e.toString()}'),
      );
    }
  }

  /// Retrieves unused phrases for specific learning context
  /// Similar to getUnusedVocabulariesForContext but for phrases
  ///
  /// Parameters:
  /// - level: User's English proficiency level
  /// - focusArea: User's learning focus area
  /// - limit: Maximum number of phrases to return
  /// - maxUsageCount: Maximum usage count to consider as "unused"
  ///
  /// Returns: Either Failure or list of unused phrases
  Future<Either<Failure, List<PhraseModel>>> getUnusedPhrasesForContext(
    Level level,
    String focusArea, {
    int limit = 10,
    int maxUsageCount = 5,
  }) async {
    try {
      final querySnapshot =
          await firestore
              .collection('global_content')
              .doc('phrases')
              .collection('items')
              .where('context.level', isEqualTo: level.name)
              .where('context.focusArea', isEqualTo: focusArea)
              .where('usageCount', isLessThan: maxUsageCount)
              .orderBy('usageCount')
              .orderBy('quality', descending: true)
              .limit(limit)
              .get();

      final phrases =
          querySnapshot.docs.map((doc) {
            final data = doc.data();
            return PhraseModel(
              english: data['english'] as String,
              persian: data['persian'] as String,
              isUsed: false, // These are unused phrases
            );
          }).toList();

      return right(phrases);
    } catch (e) {
      return left(
        ServerFailure('Failed to get unused phrases: ${e.toString()}'),
      );
    }
  }

  /// Marks vocabulary as used by incrementing usage count
  /// This helps track content popularity and prevent over-reuse
  ///
  /// Parameters:
  /// - vocabularyId: The ID of the vocabulary to mark as used
  ///
  /// Returns: Either Failure or success status
  Future<Either<Failure, bool>> markVocabularyAsUsed(
    String vocabularyId,
  ) async {
    try {
      await firestore
          .collection('global_content')
          .doc('vocabularies')
          .collection('items')
          .doc(vocabularyId)
          .update({
            'usageCount': FieldValue.increment(1),
            'lastUsedAt': DateTime.now().toIso8601String(),
          });
      return right(true);
    } catch (e) {
      return left(
        ServerFailure('Failed to mark vocabulary as used: ${e.toString()}'),
      );
    }
  }

  /// Marks phrase as used by incrementing usage count
  /// Similar to markVocabularyAsUsed but for phrases
  ///
  /// Parameters:
  /// - phraseId: The ID of the phrase to mark as used
  ///
  /// Returns: Either Failure or success status
  Future<Either<Failure, bool>> markPhraseAsUsed(String phraseId) async {
    try {
      await firestore
          .collection('global_content')
          .doc('phrases')
          .collection('items')
          .doc(phraseId)
          .update({
            'usageCount': FieldValue.increment(1),
            'lastUsedAt': DateTime.now().toIso8601String(),
          });
      return right(true);
    } catch (e) {
      return left(
        ServerFailure('Failed to mark phrase as used: ${e.toString()}'),
      );
    }
  }

  /// Saves user learning progress to track what content they've used
  /// This prevents suggesting the same content to the same user
  ///
  /// Parameters:
  /// - userId: The user's ID
  /// - usedVocabularyIds: List of vocabulary IDs the user has used
  /// - usedPhraseIds: List of phrase IDs the user has used
  /// - preferences: User's learning preferences
  ///
  /// Returns: Either Failure or success status
  Future<Either<Failure, bool>> saveUserLearningProgress(
    String userId,
    List<String> usedVocabularyIds,
    List<String> usedPhraseIds,
    Map<String, dynamic> preferences,
  ) async {
    try {
      await firestore
          .collection('users')
          .doc(userId)
          .collection('learning_progress')
          .doc('current')
          .set({
            'usedVocabularies': usedVocabularyIds,
            'usedPhrases': usedPhraseIds,
            'lastActivity': DateTime.now().toIso8601String(),
            'preferences': preferences,
          }, SetOptions(merge: true));
      return right(true);
    } catch (e) {
      return left(
        ServerFailure('Failed to save user learning progress: ${e.toString()}'),
      );
    }
  }

  /// Calculates cost based on token usage and AI provider
  /// This helps track and optimize AI usage costs
  ///
  /// Parameters:
  /// - tokensUsed: Number of tokens used
  /// - provider: AI provider used
  ///
  /// Returns: Calculated cost in USD
  double _calculateCost(int tokensUsed, AiProviderType provider) {
    const Map<AiProviderType, double> costPerToken = {
      AiProviderType.openai: 0.000002, // GPT-3.5-turbo cost per token
      AiProviderType.gemini: 0.000001, // Gemini cost per token (approximate)
      AiProviderType.deepseek:
          0.000001, // DeepSeek cost per token (approximate)
    };

    return tokensUsed * (costPerToken[provider] ?? 0.000002);
  }

  /// Generates tags for content based on context and content
  /// These tags help with content discovery and categorization
  ///
  /// Parameters:
  /// - context: Learning context
  /// - content: The English content (vocabulary or phrase)
  ///
  /// Returns: List of relevant tags
  List<String> _generateTags(LearningContext context, String content) {
    final tags = <String>[];

    // Add level tag
    tags.add(context.level.name);

    // Add focus area tag
    tags.add(context.focusArea);

    // Add difficulty tag
    tags.add(context.difficulty);

    // Add content-based tags (simplified - could be enhanced with NLP)
    if (content.toLowerCase().contains('business')) tags.add('business');
    if (content.toLowerCase().contains('travel')) tags.add('travel');
    if (content.toLowerCase().contains('meeting')) tags.add('meeting');
    if (content.toLowerCase().contains('email')) tags.add('email');
    if (content.toLowerCase().contains('presentation'))
      tags.add('presentation');

    return tags.toSet().toList(); // Remove duplicates
  }
}

// Example usage:
// final dataSource = FirebaseLessonsRemoteDataSource(FirebaseFirestore.instance);
// 
// // Save new vocabulary to global pool
// final context = LearningContext(
//   level: Level.intermediate,
//   focusArea: 'business',
//   difficulty: 'medium',
// );
// final result = await dataSource.saveVocabularyToGlobalPool(
//   vocabularyModel,
//   context,
//   'user123',
//   aiProvider: AiProviderType.openai,
//   tokensUsed: 25,
//   requestId: 'req_123',
// );
//
// // Get unused vocabularies for user context
// final vocabularies = await dataSource.getUnusedVocabulariesForContext(
//   Level.intermediate,
//   'business',
//   limit: 4,
// ); 