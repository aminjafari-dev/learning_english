/// NavigationLocalDataSource handles local data operations for navigation state.
///
/// This abstract class defines the contract for local storage operations
/// related to navigation preferences and state.
///
/// Usage Example:
///   final dataSource = NavigationLocalDataSourceImpl(sharedPreferences);
///   final state = await dataSource.getCachedNavigationState('user123');
import 'package:learning_english/features/navigation/data/models/navigation_state_model.dart';

/// Abstract local data source for navigation operations
abstract class NavigationLocalDataSource {
  /// Retrieves cached navigation state for a user
  ///
  /// Parameters:
  ///   - userId: The unique identifier of the user
  ///
  /// Returns:
  ///   - NavigationStateModel?: The cached navigation state or null if not found
  Future<NavigationStateModel?> getCachedNavigationState(String userId);

  /// Caches navigation state for a user
  ///
  /// Parameters:
  ///   - navigationState: The navigation state to cache
  ///
  /// Returns:
  ///   - bool: True if caching was successful
  Future<bool> cacheNavigationState(NavigationStateModel navigationState);

  /// Saves the current tab index for a user
  ///
  /// Parameters:
  ///   - userId: The unique identifier of the user
  ///   - currentIndex: The tab index to save
  ///
  /// Returns:
  ///   - bool: True if saving was successful
  Future<bool> saveCurrentIndex(String userId, int currentIndex);

  /// Retrieves the saved current tab index for a user
  ///
  /// Parameters:
  ///   - userId: The unique identifier of the user
  ///
  /// Returns:
  ///   - int: The saved index or 0 as default
  Future<int> getCurrentIndex(String userId);

  /// Clears cached navigation state for a user
  ///
  /// Parameters:
  ///   - userId: The unique identifier of the user
  ///
  /// Returns:
  ///   - bool: True if clearing was successful
  Future<bool> clearCachedNavigationState(String userId);

  /// Checks if navigation state is cached for a user
  ///
  /// Parameters:
  ///   - userId: The unique identifier of the user
  ///
  /// Returns:
  ///   - bool: True if navigation state is cached
  Future<bool> isNavigationStateCached(String userId);
}
