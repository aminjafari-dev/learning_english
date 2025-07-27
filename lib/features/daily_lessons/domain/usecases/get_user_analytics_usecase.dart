// get_user_analytics_usecase.dart
// Use case for getting user analytics data.
// Provides insights into user's learning progress and AI usage costs.

import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/daily_lessons_repository.dart';

/// Use case for getting user analytics
/// Provides comprehensive analytics about user's learning progress and AI usage
class GetUserAnalyticsUseCase implements UseCase<Map<String, dynamic>, void> {
  final DailyLessonsRepository repository;

  GetUserAnalyticsUseCase(this.repository);

  /// Gets analytics data for the current user
  /// @param params Not used (void parameter for consistency)
  /// @return Either a Failure or analytics data map
  @override
  Future<Either<Failure, Map<String, dynamic>>> call(void params) async {
    try {
      return await repository.getUserAnalytics();
    } catch (e) {
      return Left(
        ServerFailure('Failed to get user analytics: ${e.toString()}'),
      );
    }
  }
}

// Example usage:
// final useCase = GetUserAnalyticsUseCase(repository);
// final result = await useCase(null);
// result.fold(
//   (failure) => print('Error: ${failure.message}'),
//   (analytics) {
//     print('Total vocabularies: ${analytics['totalVocabularies']}');
//     print('Total phrases: ${analytics['totalPhrases']}');
//     print('Total tokens used: ${analytics['totalTokens']}');
//   },
// );
