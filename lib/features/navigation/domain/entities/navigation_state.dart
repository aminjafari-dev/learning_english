/// NavigationState entity represents the core business object for navigation data.
///
/// This entity contains the current navigation state including the selected tab
/// and any user preferences related to navigation.
///
/// Usage Example:
///   final navigationState = NavigationState(currentIndex: 0, userId: 'user123');
class NavigationState {
  /// Current selected tab index (0 for level selection, 1 for profile)
  final int currentIndex;

  /// User ID for storing navigation preferences
  final String userId;

  /// Timestamp when the navigation state was last updated
  final DateTime lastUpdated;

  /// Constructor for NavigationState
  ///
  /// Parameters:
  ///   - currentIndex: The currently selected tab index
  ///   - userId: The unique identifier of the user
  ///   - lastUpdated: When the state was last updated (optional, defaults to now)
  NavigationState({
    required this.currentIndex,
    required this.userId,
    DateTime? lastUpdated,
  }) : lastUpdated = lastUpdated ?? DateTime.now();

  /// Creates a copy of this NavigationState with updated values
  NavigationState copyWith({
    int? currentIndex,
    String? userId,
    DateTime? lastUpdated,
  }) {
    return NavigationState(
      currentIndex: currentIndex ?? this.currentIndex,
      userId: userId ?? this.userId,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NavigationState &&
        other.currentIndex == currentIndex &&
        other.userId == userId &&
        other.lastUpdated == lastUpdated;
  }

  @override
  int get hashCode {
    return currentIndex.hashCode ^ userId.hashCode ^ lastUpdated.hashCode;
  }

  @override
  String toString() {
    return 'NavigationState(currentIndex: $currentIndex, userId: $userId, lastUpdated: $lastUpdated)';
  }
}
