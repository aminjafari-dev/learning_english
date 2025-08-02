// user_preferences_repository.dart
// Repository interface for managing user preferences and settings.
// This repository handles fetching and managing user level and focus areas.
// Separates user preferences management from core daily lessons functionality.

import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/user_preferences.dart';

/// Abstract repository for user preferences management
/// Handles fetching user level from user profile and focus areas from learning focus selection
/// Provides default preferences when user data is not available
abstract class UserPreferencesRepository {
  /// Fetches user preferences (level and focus areas) for personalized content
  /// Combines data from level selection and learning focus selection features
  /// Returns default preferences if user data is not available
  ///
  /// This method:
  /// 1. Gets user ID from the authentication system
  /// 2. Fetches user level from UserRepository
  /// 3. Fetches focus areas from LearningFocusSelectionRepository
  /// 4. Combines them into UserPreferences object
  /// 5. Returns default values if any step fails
  ///
  /// Returns: Either Failure or UserPreferences
  ///
  /// Example usage:
  /// ```dart
  /// final preferencesResult = await userPreferencesRepository.getUserPreferences();
  /// preferencesResult.fold(
  ///   (failure) => print('Error: ${failure.message}'),
  ///   (preferences) => print('User level: ${preferences.level}, Focus: ${preferences.focusAreas}'),
  /// );
  /// ```
  Future<Either<Failure, UserPreferences>> getUserPreferences();


}

// Example usage:
// final repo = ... // get from DI
// 
// // Get current preferences
// final preferences = await repo.getUserPreferences();
// preferences.fold(
//   (failure) => print('Error: ${failure.message}'),
//   (prefs) => print('Level: ${prefs.level}, Areas: ${prefs.focusAreas}'),
// );
// 
// // Update preferences
// final newPrefs = UserPreferences(level: UserLevel.advanced, focusAreas: ['business', 'technology']);
// await repo.updateUserPreferences(newPrefs);