/// NavigationLocalDataSourceImpl implements local data operations for navigation state.
///
/// This class provides concrete implementation of local storage operations
/// using SharedPreferences for caching navigation preferences.
///
/// Usage Example:
///   final dataSource = NavigationLocalDataSourceImpl(sharedPreferences);
///   final state = await dataSource.getCachedNavigationState('user123');
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:learning_english/features/navigation/data/datasources/navigation_local_data_source.dart';
import 'package:learning_english/features/navigation/data/models/navigation_state_model.dart';

/// Implementation of NavigationLocalDataSource
class NavigationLocalDataSourceImpl implements NavigationLocalDataSource {
  /// SharedPreferences instance for local storage
  final SharedPreferences _sharedPreferences;

  /// Constructor for NavigationLocalDataSourceImpl
  ///
  /// Parameters:
  ///   - sharedPreferences: SharedPreferences instance for local storage
  const NavigationLocalDataSourceImpl({
    required SharedPreferences sharedPreferences,
  }) : _sharedPreferences = sharedPreferences;

  @override
  Future<NavigationStateModel?> getCachedNavigationState(String userId) async {
    try {
      final navigationStateJson = _sharedPreferences.getString(
        'navigation_state_$userId',
      );
      if (navigationStateJson == null) {
        return null;
      }

      final navigationStateData =
          jsonDecode(navigationStateJson) as Map<String, dynamic>;
      return NavigationStateModel.fromJson(navigationStateData);
    } catch (e) {
      throw CacheException(
        'Failed to get cached navigation state: ${e.toString()}',
      );
    }
  }

  @override
  Future<bool> cacheNavigationState(
    NavigationStateModel navigationState,
  ) async {
    try {
      final navigationStateJson = jsonEncode(navigationState.toJson());
      await _sharedPreferences.setString(
        'navigation_state_${navigationState.userId}',
        navigationStateJson,
      );
      return true;
    } catch (e) {
      throw CacheException('Failed to cache navigation state: ${e.toString()}');
    }
  }

  @override
  Future<bool> saveCurrentIndex(String userId, int currentIndex) async {
    try {
      await _sharedPreferences.setInt('navigation_index_$userId', currentIndex);
      return true;
    } catch (e) {
      throw CacheException('Failed to save current index: ${e.toString()}');
    }
  }

  @override
  Future<int> getCurrentIndex(String userId) async {
    try {
      return _sharedPreferences.getInt('navigation_index_$userId') ?? 0;
    } catch (e) {
      throw CacheException('Failed to get current index: ${e.toString()}');
    }
  }

  @override
  Future<bool> clearCachedNavigationState(String userId) async {
    try {
      await _sharedPreferences.remove('navigation_state_$userId');
      await _sharedPreferences.remove('navigation_index_$userId');
      return true;
    } catch (e) {
      throw CacheException(
        'Failed to clear cached navigation state: ${e.toString()}',
      );
    }
  }

  @override
  Future<bool> isNavigationStateCached(String userId) async {
    try {
      return _sharedPreferences.containsKey('navigation_state_$userId');
    } catch (e) {
      throw CacheException(
        'Failed to check if navigation state is cached: ${e.toString()}',
      );
    }
  }
}

/// Exception thrown when cache operations fail
class CacheException implements Exception {
  /// Error message
  final String message;

  /// Constructor for CacheException
  const CacheException(this.message);

  @override
  String toString() => message;
}
