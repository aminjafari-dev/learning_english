// user_preferences_repository_impl.dart
// Implementation of UserPreferencesRepository interface.
// This class handles fetching and managing user preferences from multiple data sources.
// Combines user level from UserRepository and focus areas from LearningFocusSelectionRepository.

import 'package:dartz/dartz.dart';
import 'package:learning_english/core/error/failure.dart';
import 'package:learning_english/core/repositories/user_repository.dart'
    as core_user;
import 'package:learning_english/features/level_selection/domain/repositories/user_repository.dart';
import 'package:learning_english/features/learning_focus_selection/domain/repositories/learning_focus_selection_repository.dart';
import 'package:learning_english/features/level_selection/domain/entities/user_profile.dart'
    as user_profile;
import '../../domain/entities/user_preferences.dart';
import '../../domain/repositories/user_preferences_repository.dart';
import '../../data/models/level_type.dart';

/// Implementation of UserPreferencesRepository
/// Combines data from multiple sources to create complete user preferences
/// Handles user level from user profile and focus areas from learning focus selection
class UserPreferencesRepositoryImpl implements UserPreferencesRepository {
  final UserRepository userRepository;
  final LearningFocusSelectionRepository learningFocusRepository;
  final core_user.UserRepository coreUserRepository;

  /// Constructor for dependency injection
  /// Requires repositories for user level and learning focus areas
  /// Uses core user repository for authentication state (Clean Architecture compliant)
  UserPreferencesRepositoryImpl({
    required this.userRepository,
    required this.learningFocusRepository,
    required this.coreUserRepository,
  });

  @override
  Future<Either<Failure, UserPreferences>> getUserPreferences() async {
    try {
      // Get user ID from core user repository (Clean Architecture compliant)
      final userId = await coreUserRepository.getUserId();

      if (userId == null) {
        print(
          '⚠️ [USER_PREFERENCES] No user ID available, returning default preferences',
        );
        // Return default preferences if user ID is not available
        return right(getDefaultPreferences());
      }

      print('✅ [USER_PREFERENCES] Retrieved user ID: $userId');

      // Get user level from Firestore via UserRepository
      user_profile.Level userLevel =
          user_profile.Level.intermediate; // Default level
      try {
        final userLevelResult = await userRepository.getUserLevel(userId);
        userLevelResult.fold(
          (failure) {
            print(
              '⚠️ [USER_PREFERENCES] Could not fetch user level, using default: ${failure.message}',
            );
            userLevel = user_profile.Level.intermediate;
          },
          (level) {
            if (level != null) {
              userLevel = level;
              print('✅ [USER_PREFERENCES] Retrieved user level: $userLevel');
            } else {
              print(
                '⚠️ [USER_PREFERENCES] No user level found, using default: $userLevel',
              );
            }
          },
        );
      } catch (e) {
        print(
          '⚠️ [USER_PREFERENCES] Error fetching user level, using default: $e',
        );
        userLevel = user_profile.Level.intermediate;
      }

      // Get learning focus areas from local storage via LearningFocusSelectionRepository
      List<String> focusAreas = ['general']; // Default focus area
      try {
        final selectedOptionIds =
            await learningFocusRepository.getLearningFocusSelection();
        if (selectedOptionIds.isNotEmpty) {
          // Convert option IDs to focus area names
          // This mapping should match the options in LearningFocusSelectionPage
          focusAreas = selectedOptionIds.selectedTexts;
          print('✅ [USER_PREFERENCES] Retrieved focus areas: $focusAreas');
        } else {
          print(
            '⚠️ [USER_PREFERENCES] No focus areas selected, using default: $focusAreas',
          );
        }
      } catch (e) {
        print(
          '⚠️ [USER_PREFERENCES] Could not fetch learning focus areas, using default: $e',
        );
        focusAreas = ['general'];
      }

      // Convert user_profile.Level to UserLevel for UserPreferences
      final userLevelEnum = _convertToUserLevel(userLevel);

      // Create UserPreferences with fetched data
      final preferences = UserPreferences(
        level: userLevelEnum,
        focusAreas: focusAreas,
      );

      print(
        '✅ [USER_PREFERENCES] Successfully created user preferences: $preferences',
      );
      return right(preferences);
    } catch (e) {
      print('❌ [USER_PREFERENCES] Error fetching user preferences: $e');
      return left(
        ServerFailure('Failed to fetch user preferences: ${e.toString()}'),
      );
    }
  }

  /// Gets default preferences for users without saved preferences
  /// Provides sensible defaults for new users
  ///
  /// Returns: Default UserPreferences with intermediate level and general focus
  UserPreferences getDefaultPreferences() {
    print('📋 [USER_PREFERENCES] Returning default preferences');
    return UserPreferences(
      level: UserLevel.intermediate,
      focusAreas: ['general'],
    );
  }

  /// Converts user_profile.Level to UserLevel enum
  /// Maps between different level representations in the system
  UserLevel _convertToUserLevel(user_profile.Level profileLevel) {
    switch (profileLevel) {
      case user_profile.Level.beginner:
        return UserLevel.beginner;
      case user_profile.Level.elementary:
        return UserLevel.elementary;
      case user_profile.Level.intermediate:
        return UserLevel.intermediate;
      case user_profile.Level.advanced:
        return UserLevel.advanced;
    }
  }
}

// Example usage:
// final userPreferencesRepo = UserPreferencesRepositoryImpl(
//   userRepository: getIt<UserRepository>(),
//   learningFocusRepository: getIt<LearningFocusSelectionRepository>(),
//   coreUserRepository: getIt<core_user.UserRepository>(),
// );
// 
// // Get current preferences
// final preferences = await userPreferencesRepo.getUserPreferences();
// preferences.fold(
//   (failure) => print('Error: ${failure.message}'),
//   (prefs) => print('Level: ${prefs.level}, Areas: ${prefs.focusAreas}'),
// );