// get_user_preferences_usecase.dart
// Use case for fetching user preferences (level and focus areas) for personalized content generation.
// This combines data from level selection and learning focus selection features.
//
// Usage:
//   final preferences = await getUserPreferencesUseCase(NoParams());
//   preferences.fold(
//     (failure) => print('Error: ${failure.message}'),
//     (preferences) => print('Level: ${preferences.level}, Focus: ${preferences.focusAreas}'),
//   );

import 'package:dartz/dartz.dart';
import 'package:learning_english/core/error/failure.dart';
import 'package:learning_english/core/usecase/usecase.dart';
import '../entities/user_preferences.dart';
import '../repositories/user_preferences_repository.dart';

/// Use case for fetching user preferences for personalized content generation
/// Combines user's English level and selected learning focus areas
/// Updated to use dedicated UserPreferencesRepository
class GetUserPreferencesUseCase implements UseCase<UserPreferences, NoParams> {
  final UserPreferencesRepository repository;

  GetUserPreferencesUseCase(this.repository);

  /// Fetches user preferences (level and focus areas) for personalized content
  /// Returns default preferences if user data is not available
  ///
  /// Parameters:
  /// - params: NoParams (no parameters needed)
  ///
  /// Returns: Either Failure or UserPreferences
  @override
  Future<Either<Failure, UserPreferences>> call(NoParams params) async {
    try {
      return await repository.getUserPreferences();
    } catch (e) {
      return Left(
        ServerFailure('Failed to fetch user preferences: ${e.toString()}'),
      );
    }
  }
}
