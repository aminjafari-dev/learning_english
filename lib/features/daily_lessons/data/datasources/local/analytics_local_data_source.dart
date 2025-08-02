// analytics_local_data_source.dart
// Specialized local data source for analytics and statistics calculation using Hive.
// This class handles computation of usage statistics, cost analysis, and performance metrics.
// Usage: Use this class to generate analytics reports and statistics from learning request data.

import 'package:hive_flutter/hive_flutter.dart';
import '../../models/learning_request_model.dart';
import '../../models/ai_provider_type.dart';

/// Specialized local data source for analytics and statistics calculation
/// This class focuses solely on computing analytics from learning request data
/// Usage: Initialize once, then use methods to generate various analytics reports
class AnalyticsLocalDataSource {
  static const String _boxName = 'learning_requests';

  late Box<LearningRequestModel> _box;

  /// Initialize Hive box for analytics computation
  /// This method should be called before using any other methods
  /// Example: await dataSource.initialize();
  Future<void> initialize() async {
    try {
      _box = await Hive.openBox<LearningRequestModel>(_boxName);
    } catch (e) {
      throw Exception('Failed to initialize analytics box: ${e.toString()}');
    }
  }

  /// Gets comprehensive analytics data for the current user
  /// Returns usage statistics, cost analysis, and provider performance metrics
  /// Example: final analytics = await dataSource.getUserAnalytics('user123');
  Future<Map<String, dynamic>> getUserAnalytics(String userId) async {
    try {
      // Get all requests for the user
      final userRequests =
          _box.values.where((request) => request.userId == userId).toList();

      // Calculate total tokens used across all requests
      final totalTokens = userRequests.fold<int>(
        0,
        (sum, request) => sum + request.totalTokensUsed,
      );

      // Calculate total estimated cost across all requests
      final totalCost = userRequests.fold<double>(
        0,
        (sum, request) => sum + request.estimatedCost,
      );

      // Generate provider-specific statistics
      final providerStats = await _generateProviderStatistics(userRequests);

      // Calculate total vocabulary and phrase metrics
      final vocabularyMetrics = _calculateVocabularyMetrics(userRequests);
      final phraseMetrics = _calculatePhraseMetrics(userRequests);

      return {
        'totalRequests': userRequests.length,
        'totalVocabularies': vocabularyMetrics['total'],
        'totalPhrases': phraseMetrics['total'],
        'totalTokens': totalTokens,
        'totalCost': totalCost,
        'usedVocabularies': vocabularyMetrics['used'],
        'usedPhrases': phraseMetrics['used'],
        'providerStats': providerStats,
        'usageEfficiency': _calculateUsageEfficiency(
          vocabularyMetrics,
          phraseMetrics,
        ),
        'costPerContent': _calculateCostPerContent(
          totalCost,
          vocabularyMetrics,
          phraseMetrics,
        ),
      };
    } catch (e) {
      throw Exception('Failed to get user analytics: ${e.toString()}');
    }
  }

  /// Generates detailed statistics for each AI provider
  /// Returns metrics like requests, content generated, tokens used, and costs per provider
  /// Example: Used internally by getUserAnalytics to break down performance by provider
  Future<Map<String, Map<String, dynamic>>> _generateProviderStatistics(
    List<LearningRequestModel> userRequests,
  ) async {
    final providerStats = <String, Map<String, dynamic>>{};

    // Iterate through each AI provider type
    for (final provider in AiProviderType.values) {
      final providerRequests =
          userRequests
              .where((request) => request.aiProvider == provider)
              .toList();

      // Calculate provider-specific metrics
      final providerTokens = providerRequests.fold<int>(
        0,
        (sum, request) => sum + request.totalTokensUsed,
      );

      final providerCost = providerRequests.fold<double>(
        0,
        (sum, request) => sum + request.estimatedCost,
      );

      final totalVocabularies = providerRequests.fold<int>(
        0,
        (sum, request) => sum + request.vocabularies.length,
      );

      final totalPhrases = providerRequests.fold<int>(
        0,
        (sum, request) => sum + request.phrases.length,
      );

      final usedVocabularies = providerRequests.fold<int>(
        0,
        (sum, request) =>
            sum + request.vocabularies.where((v) => v.isUsed).length,
      );

      final usedPhrases = providerRequests.fold<int>(
        0,
        (sum, request) => sum + request.phrases.where((p) => p.isUsed).length,
      );

      // Calculate efficiency metrics for this provider
      final vocabularyEfficiency =
          totalVocabularies > 0
              ? (usedVocabularies / totalVocabularies * 100).toStringAsFixed(2)
              : '0.00';

      final phraseEfficiency =
          totalPhrases > 0
              ? (usedPhrases / totalPhrases * 100).toStringAsFixed(2)
              : '0.00';

      providerStats[provider.toString()] = {
        'requests': providerRequests.length,
        'vocabularies': totalVocabularies,
        'phrases': totalPhrases,
        'tokensUsed': providerTokens,
        'estimatedCost': providerCost,
        'usedVocabularies': usedVocabularies,
        'usedPhrases': usedPhrases,
        'vocabularyEfficiency': vocabularyEfficiency,
        'phraseEfficiency': phraseEfficiency,
        'avgCostPerRequest':
            providerRequests.isNotEmpty
                ? (providerCost / providerRequests.length).toStringAsFixed(4)
                : '0.0000',
        'avgTokensPerRequest':
            providerRequests.isNotEmpty
                ? (providerTokens ~/ providerRequests.length)
                : 0,
      };
    }

    return providerStats;
  }

  /// Calculates vocabulary-related metrics
  /// Returns total and used vocabulary counts for analytics
  /// Example: Used internally to compute vocabulary usage statistics
  Map<String, int> _calculateVocabularyMetrics(
    List<LearningRequestModel> userRequests,
  ) {
    final totalVocabularies = userRequests.fold<int>(
      0,
      (sum, request) => sum + request.vocabularies.length,
    );

    final usedVocabularies = userRequests.fold<int>(
      0,
      (sum, request) =>
          sum + request.vocabularies.where((v) => v.isUsed).length,
    );

    return {'total': totalVocabularies, 'used': usedVocabularies};
  }

  /// Calculates phrase-related metrics
  /// Returns total and used phrase counts for analytics
  /// Example: Used internally to compute phrase usage statistics
  Map<String, int> _calculatePhraseMetrics(
    List<LearningRequestModel> userRequests,
  ) {
    final totalPhrases = userRequests.fold<int>(
      0,
      (sum, request) => sum + request.phrases.length,
    );

    final usedPhrases = userRequests.fold<int>(
      0,
      (sum, request) => sum + request.phrases.where((p) => p.isUsed).length,
    );

    return {'total': totalPhrases, 'used': usedPhrases};
  }

  /// Calculates usage efficiency metrics
  /// Returns percentage of content that has been used by the learner
  /// Example: Used to show how effectively the user is utilizing generated content
  Map<String, String> _calculateUsageEfficiency(
    Map<String, int> vocabularyMetrics,
    Map<String, int> phraseMetrics,
  ) {
    final totalContent = vocabularyMetrics['total']! + phraseMetrics['total']!;
    final usedContent = vocabularyMetrics['used']! + phraseMetrics['used']!;

    final overallEfficiency =
        totalContent > 0
            ? (usedContent / totalContent * 100).toStringAsFixed(2)
            : '0.00';

    final vocabularyEfficiency =
        vocabularyMetrics['total']! > 0
            ? (vocabularyMetrics['used']! / vocabularyMetrics['total']! * 100)
                .toStringAsFixed(2)
            : '0.00';

    final phraseEfficiency =
        phraseMetrics['total']! > 0
            ? (phraseMetrics['used']! / phraseMetrics['total']! * 100)
                .toStringAsFixed(2)
            : '0.00';

    return {
      'overall': '$overallEfficiency%',
      'vocabulary': '$vocabularyEfficiency%',
      'phrase': '$phraseEfficiency%',
    };
  }

  /// Calculates cost per content item metrics
  /// Returns cost efficiency metrics for cost-benefit analysis
  /// Example: Used to show cost effectiveness of AI content generation
  Map<String, String> _calculateCostPerContent(
    double totalCost,
    Map<String, int> vocabularyMetrics,
    Map<String, int> phraseMetrics,
  ) {
    final totalContent = vocabularyMetrics['total']! + phraseMetrics['total']!;
    final usedContent = vocabularyMetrics['used']! + phraseMetrics['used']!;

    final costPerTotalContent =
        totalContent > 0
            ? (totalCost / totalContent).toStringAsFixed(4)
            : '0.0000';

    final costPerUsedContent =
        usedContent > 0
            ? (totalCost / usedContent).toStringAsFixed(4)
            : '0.0000';

    final costPerVocabulary =
        vocabularyMetrics['total']! > 0
            ? (totalCost / vocabularyMetrics['total']!).toStringAsFixed(4)
            : '0.0000';

    final costPerPhrase =
        phraseMetrics['total']! > 0
            ? (totalCost / phraseMetrics['total']!).toStringAsFixed(4)
            : '0.0000';

    return {
      'perTotalContent': costPerTotalContent,
      'perUsedContent': costPerUsedContent,
      'perVocabulary': costPerVocabulary,
      'perPhrase': costPerPhrase,
    };
  }

  /// Gets learning progress analytics for a user
  /// Returns progress metrics and learning trends over time
  /// Example: final progress = await dataSource.getLearningProgressAnalytics('user123');
  Future<Map<String, dynamic>> getLearningProgressAnalytics(
    String userId,
  ) async {
    try {
      final userRequests =
          _box.values.where((request) => request.userId == userId).toList();

      // Sort requests by creation date for trend analysis
      userRequests.sort((a, b) => a.createdAt.compareTo(b.createdAt));

      final monthlyProgress = <String, Map<String, int>>{};

      // Group requests by month for trend analysis
      for (final request in userRequests) {
        final monthKey =
            '${request.createdAt.year}-${request.createdAt.month.toString().padLeft(2, '0')}';

        if (!monthlyProgress.containsKey(monthKey)) {
          monthlyProgress[monthKey] = {
            'requests': 0,
            'vocabularies': 0,
            'phrases': 0,
            'usedVocabularies': 0,
            'usedPhrases': 0,
          };
        }

        monthlyProgress[monthKey]!['requests'] =
            monthlyProgress[monthKey]!['requests']! + 1;
        monthlyProgress[monthKey]!['vocabularies'] =
            monthlyProgress[monthKey]!['vocabularies']! +
            request.vocabularies.length;
        monthlyProgress[monthKey]!['phrases'] =
            monthlyProgress[monthKey]!['phrases']! + request.phrases.length;
        monthlyProgress[monthKey]!['usedVocabularies'] =
            monthlyProgress[monthKey]!['usedVocabularies']! +
            request.vocabularies.where((v) => v.isUsed).length;
        monthlyProgress[monthKey]!['usedPhrases'] =
            monthlyProgress[monthKey]!['usedPhrases']! +
            request.phrases.where((p) => p.isUsed).length;
      }

      return {
        'monthlyProgress': monthlyProgress,
        'totalMonthsActive': monthlyProgress.length,
        'firstActivityDate':
            userRequests.isNotEmpty
                ? userRequests.first.createdAt.toIso8601String()
                : null,
        'lastActivityDate':
            userRequests.isNotEmpty
                ? userRequests.last.createdAt.toIso8601String()
                : null,
        'averageRequestsPerMonth':
            monthlyProgress.isNotEmpty
                ? (userRequests.length / monthlyProgress.length)
                    .toStringAsFixed(2)
                : '0.00',
      };
    } catch (e) {
      throw Exception(
        'Failed to get learning progress analytics: ${e.toString()}',
      );
    }
  }

  /// Closes the Hive box to free up resources
  /// Should be called when the data source is no longer needed
  /// Example: await dataSource.dispose();
  Future<void> dispose() async {
    try {
      await _box.close();
    } catch (e) {
      throw Exception(
        'Failed to dispose analytics data source: ${e.toString()}',
      );
    }
  }
}

// Example usage:
// final dataSource = AnalyticsLocalDataSource();
// await dataSource.initialize();
// final analytics = await dataSource.getUserAnalytics('user123');
// final progress = await dataSource.getLearningProgressAnalytics('user123');
// await dataSource.dispose();
